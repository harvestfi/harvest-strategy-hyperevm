const makeVault = require("./make-vault.js");
const addresses = require("../test-config.js");
const IController = artifacts.require("IController");
const IFeeRewardForwarder = artifacts.require("IFeeRewardForwarder");
const Vault = artifacts.require("VaultV2");
const IUpgradeableStrategy = artifacts.require("IUpgradeableStrategy");

const Utils = require("./Utils.js");

async function impersonates(targetAccounts){
  console.log("Impersonating...");
  for(i = 0; i < targetAccounts.length ; i++){
    console.log(targetAccounts[i]);
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [
        targetAccounts[i]
      ]
    });
  }
}

async function setupCoreProtocol(config) {
  // Set vault (or Deploy new vault), underlying, underlying Whale,
  // amount the underlying whale should send to farmers
  if(config.existingVaultAddress != null){
    vault = await Vault.at(config.existingVaultAddress);
    console.log("Fetching Vault at: ", vault.address);
  } else {
    const implAddress = config.vaultImplementationOverride || addresses.VaultImplementationV2;
    vault = await makeVault(implAddress, addresses.Storage, config.underlying.address, 100, 100, {
      from: config.governance,
    });
    console.log("New Vault Deployed: ", vault.address);
  }

  controller = await IController.at(addresses.Controller);
  feeRewardForwarder = await IFeeRewardForwarder.at(await controller.feeRewardForwarder());


  if (config.feeRewardForwarder) {/*
    const FeeRewardForwarder = artifacts.require("FeeRewardForwarder");
    const feeRewardForwarder = await FeeRewardForwarder.new(
      addresses.Storage,
      addresses.FARM,
      addresses.miFARM,
      addresses.UniversalLiquidatorRegistry
    );

    config.feeRewardForwarder = feeRewardForwarder.address;*/
    console.log("Setting up a custom fee reward forwarder...");
    await controller.setFeeRewardForwarder(
      config.feeRewardForwarder,
      { from: config.governance }
    );

    const NoMintRewardPool = artifacts.require("NoMintRewardPool");
    const farmRewardPool = await NoMintRewardPool.at("0x8f5adC58b32D4e5Ca02EAC0E293D35855999436C");
    await farmRewardPool.setRewardDistribution(config.feeRewardForwarder, {from: config.governance});

    console.log("Done setting up fee reward forwarder!");
  }

  let rewardPool = null;

  if (!config.rewardPoolConfig) {
    config.rewardPoolConfig = {};
  }
  // if reward pool is required, then deploy it
  if(config.rewardPool != null && config.existingRewardPoolAddress == null) {
    const rewardTokens = config.rewardPoolConfig.rewardTokens || [addresses.FARM];
    const rewardDistributions = [config.governance];
    if (config.feeRewardForwarder) {
      rewardDistributions.push(config.feeRewardForwarder);
    }

    if (config.rewardPoolConfig.type === 'PotPool') {
      const PotPool = artifacts.require("PotPool");
      console.log("reward pool needs to be deployed");
      rewardPool = await PotPool.new(
        rewardTokens,
        vault.address,
        64800,
        rewardDistributions,
        addresses.Storage,
        "fPool",
        "fPool",
        18,
        {from: config.governance }
      );
      console.log("New PotPool deployed: ", rewardPool.address);
    } else {
      const NoMintRewardPool = artifacts.require("NoMintRewardPool");
      console.log("reward pool needs to be deployed");
      rewardPool = await NoMintRewardPool.new(
        rewardTokens[0],
        vault.address,
        64800,
        rewardDistributions,
        addresses.Storage,
        "0x0000000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000",
        {from: config.governance }
      );
      console.log("New NoMintRewardPool deployed: ", rewardPool.address);
    }
  } else if(config.existingRewardPoolAddress != null) {
    const PotPool = artifacts.require("PotPool");
    rewardPool = await PotPool.at(config.existingRewardPoolAddress);
    console.log("Fetching Reward Pool deployed: ", rewardPool.address);
  }

  // default arguments are storage and vault addresses
  config.strategyArgs = config.strategyArgs || [
    addresses.Storage,
    vault.address
  ];

  for(i = 0; i < config.strategyArgs.length ; i++){
    if(config.strategyArgs[i] == "storageAddr") {
      config.strategyArgs[i] = addresses.Storage;
    } else if(config.strategyArgs[i] == "vaultAddr") {
      config.strategyArgs[i] = vault.address;
    } else if(config.strategyArgs[i] == "poolAddr" ){
      config.strategyArgs[i] = rewardPool.address;
    } else if(config.strategyArgs[i] == "universalLiquidatorRegistryAddr"){
      config.strategyArgs[i] = universalLiquidatorRegistry.address;
    }
  }

  let strategyImpl = null;

  if (!config.strategyArtifactIsUpgradable) {
    strategy = await config.strategyArtifact.new(
      ...config.strategyArgs,
      { from: config.governance }
    );
  } else {
    strategyImpl = await config.strategyArtifact.new();
    const StrategyProxy = artifacts.require("StrategyProxy");

    const strategyProxy = await StrategyProxy.new(strategyImpl.address);
    strategy = await config.strategyArtifact.at(strategyProxy.address);
    await strategy.initializeStrategy(
      ...config.strategyArgs,
      { from: config.governance }
    );
  }

  console.log("Strategy Deployed: ", strategy.address);

  if (config.liquidationPath) {
    const path = config.liquidationPath.path;
    const router = addresses[config.liquidationPath.router];
    await feeRewardForwarder.setConversionPath(
      path[0],
      path[path.length - 1],
      path,
      router,
      {from: config.governance}
    );
  }

  if (config.announceStrategy === true) {
    // Announce switch, time pass, switch to strategy
    await vault.announceStrategyUpdate(strategy.address, { from: config.governance });
    console.log("Strategy switch announced. Waiting...");
    await Utils.waitHours(13);
    await vault.setStrategy(strategy.address, { from: config.governance });
    await vault.setVaultFractionToInvest(100, 100, { from: config.governance });
    console.log("Strategy switch completed.");
  } else if (config.upgradeStrategy === true) {
    // Announce upgrade, time pass, upgrade the strategy
    const strategyAsUpgradable = await IUpgradeableStrategy.at(await vault.strategy());
    await strategyAsUpgradable.scheduleUpgrade(strategyImpl.address, { from: config.governance });
    console.log("Upgrade scheduled. Waiting...");
    await Utils.waitHours(13);
    await strategyAsUpgradable.upgrade({ from: config.governance });
    await vault.setVaultFractionToInvest(100, 100, { from: config.governance });
    strategy = await config.strategyArtifact.at(await vault.strategy());
    console.log("Strategy upgrade completed.");
  } else {
    await controller.addVaultAndStrategy(
      vault.address,
      strategy.address,
      { from: config.governance }
    );
    console.log("Strategy and vault added to Controller.");
  }

  return [controller, vault, strategy, rewardPool];
}

async function depositVault(_farmer, _underlying, _vault, _amount) {
  await _underlying.approve(_vault.address, _amount, { from: _farmer });
  await _vault.deposit(_amount, { from: _farmer });
}

module.exports = {
  impersonates,
  setupCoreProtocol,
  depositVault,
};
