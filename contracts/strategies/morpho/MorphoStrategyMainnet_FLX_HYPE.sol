//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./MorphoStrategy.sol";

contract MorphoStrategyMainnet_FLX_HYPE is MorphoStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0x5555555555555555555555555555555555555555);
    address morphoVault = address(0x2900ABd73631b2f60747e687095537B673c06A76);
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
