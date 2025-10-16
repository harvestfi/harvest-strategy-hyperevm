// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "../../VaultProxy.sol";
import "../../interface/IVault.sol";
import "../interface/IVaultFactory.sol";
import "../../inheritance/OwnableWhitelist.sol";

contract RegularVaultFactory is OwnableWhitelist, IVaultFactory {
  address public vaultImplementation = 0xD1F6e6483872099E3535134D8dc9372E20433fAb;
  address public lastDeployedAddress = address(0);

  function deploy(address _storage, address underlying) override external onlyWhitelisted returns (address) {
    lastDeployedAddress = address(new VaultProxy(vaultImplementation));
    IVault(lastDeployedAddress).initializeVault(
      _storage,
      underlying,
      10000,
      10000
    );

    return lastDeployedAddress;
  }

  function changeDefaultImplementation(address newImplementation) external onlyOwner {
    require(newImplementation != address(0), "Must be set");
    vaultImplementation = newImplementation;
  }

  function info(address vault) override external view returns(address Underlying, address NewVault) {
    Underlying = IVault(vault).underlying();
    NewVault = vault;
  }
}
