//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./MorphoStrategy.sol";

contract MorphoStrategyMainnet_GLT_USDC is MorphoStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xb88339CB7199b77E23DB6E890353E22632Ba630f);
    address morphoVault = address(0x08C00F8279dFF5B0CB5a04d349E7d79708Ceadf3);
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
