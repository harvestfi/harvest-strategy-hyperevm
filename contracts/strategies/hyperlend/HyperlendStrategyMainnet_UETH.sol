//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "../hypurr/HypurrStrategy.sol";

contract HyperlendStrategyMainnet_UETH is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xBe6727B535545C67d5cAa73dEa54865B92CF7907);
    address aToken = address(0xdBA3B25643C11be9BDF457D6b3926992A735c523);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}