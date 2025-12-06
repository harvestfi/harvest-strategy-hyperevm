//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HypurrStrategy.sol";

contract HypurrStrategyMainnet_USDT0 is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xB8CE59FC3717ada4C02eaDF9682A9e934F625ebb);
    address aToken = address(0x1Ca7e21B2dAa5Ab2eB9de7cf8f34dCf9c8683007);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}