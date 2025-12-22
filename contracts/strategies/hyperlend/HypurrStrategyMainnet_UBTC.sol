//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HyperlendStrategy.sol";

contract HyperlendStrategyMainnet_UBTC is HyperlendStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0x9FDBdA0A5e284c32744D2f17Ee5c74B284993463);
    address aToken = address(0xd2012c6DfF7634f9513A56a1871b93e4505EA851);
    HyperlendStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}