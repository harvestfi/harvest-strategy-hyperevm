//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HypurrStrategy.sol";

contract HypurrStrategyMainnet_HYPE is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0x5555555555555555555555555555555555555555);
    address aToken = address(0x7C97cd7B57b736c6AD74fAE97C0e21e856251dcf);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}