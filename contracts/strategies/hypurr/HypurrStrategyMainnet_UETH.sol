//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./HypurrStrategy.sol";

contract HypurrStrategyMainnet_UETH is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xBe6727B535545C67d5cAa73dEa54865B92CF7907);
    address aToken = address(0x68717797aAAe1b009C258b6fF5403AeCCB7010c0);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}