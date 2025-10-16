const prompt = require('prompt');
const ULRegistryContract = artifacts.require("UniversalLiquidatorRegistry");
const { ethers } = require("ethers");
const addresses = require("../../test/test-config.js")

async function main() {
  prompt.start();    
  const registry = await ULRegistryContract.at(addresses.UniversalLiquidator.UniversalLiquidatorRegistry);
  const {dex, name} = await prompt.get(['dex', 'name']);

  const Dex = artifacts.require(dex);
  const contract = await Dex.new();
  try {
    await hre.run("verify:verify", {address: contract.address}); 
  } catch (e) {
    console.log("Verification error:", e);
  }

  const nameBytes = ethers.utils.id(name);
  console.log(`${dex} id:`, nameBytes);
  console.log(`${dex} address:`, contract.address);
  await registry.addDex(nameBytes, contract.address);
  console.log("Dex added to the Registry:", nameBytes, contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
