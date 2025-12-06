//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HypurrStrategy.sol";

contract HypurrStrategyMainnet_UBTC is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0x9FDBdA0A5e284c32744D2f17Ee5c74B284993463);
    address aToken = address(0x02379E4a55111d999Ac18C367F5920119398b94B);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}