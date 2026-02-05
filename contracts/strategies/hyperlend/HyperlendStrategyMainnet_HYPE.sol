//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "../hypurr/HypurrStrategy.sol";

contract HyperlendStrategyMainnet_HYPE is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0x5555555555555555555555555555555555555555);
    address aToken = address(0x0D745EAA9E70bb8B6e2a0317f85F1d536616bD34);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}