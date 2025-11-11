//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./MorphoStrategy.sol";

contract MorphoStrategyMainnet_GLT_USDT0 is MorphoStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) external initializer {
    address underlying = address(0xB8CE59FC3717ada4C02eaDF9682A9e934F625ebb);
    address morphoVault = address(0x53A333e51E96FE288bC9aDd7cdC4B1EAD2CD2FfA);
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
