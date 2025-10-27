//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./MorphoStrategy.sol";

contract MorphoStrategyMainnet_GLT_UETH is MorphoStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xBe6727B535545C67d5cAa73dEa54865B92CF7907);
    address morphoVault = address(0x0571362ba5EA9784a97605f57483f865A37dBEAA);
    address usdc = address(0xb88339CB7199b77E23DB6E890353E22632Ba630f);
    MorphoStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      morphoVault,
      usdc
    );
  }
}
