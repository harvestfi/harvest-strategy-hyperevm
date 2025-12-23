//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "../hypurr/HypurrStrategy.sol";

contract HyperlendStrategyMainnet_USDC is HypurrStrategy {

  constructor() {}

  function initializeStrategy(
    address _storage,
    address _vault
  ) public initializer {
    address underlying = address(0xb88339CB7199b77E23DB6E890353E22632Ba630f);
    address aToken = address(0x744E4f26ee30213989216E1632D9BE3547C4885b);
    HypurrStrategy.initializeBaseStrategy(
      _storage,
      underlying,
      _vault,
      aToken
    );
  }
}