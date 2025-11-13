//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./MorphoStrategy.sol";

contract MorphoStrategyMainnet_FLX_USDT0_FRONTIER is MorphoStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) external initializer {
    address underlying = address(0xB8CE59FC3717ada4C02eaDF9682A9e934F625ebb);
    address morphoVault = address(0x9896a8605763106e57A51aa0a97Fe8099E806bb3);
    address ueth = address(0xBe6727B535545C67d5cAa73dEa54865B92CF7907);
    MorphoStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      morphoVault,
      ueth
    );
  }
}
