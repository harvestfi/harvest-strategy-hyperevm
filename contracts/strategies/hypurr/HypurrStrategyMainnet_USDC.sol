//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HypurrStrategy.sol";

contract HypurrStrategyMainnet_USDC is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xb88339CB7199b77E23DB6E890353E22632Ba630f);
    address aToken = address(0x280535137Dd84080d97d0826c577B4019d8e1BEb);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}