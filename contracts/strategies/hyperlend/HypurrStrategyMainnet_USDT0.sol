//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HyperlendStrategy.sol";

contract HyperlendStrategyMainnet_USDT0 is HyperlendStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xB8CE59FC3717ada4C02eaDF9682A9e934F625ebb);
    address aToken = address(0x10982ad645D5A112606534d8567418Cf64c14cB5);
    HyperlendStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}