// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library DataTypes {
    struct PathInfo {
        bytes32 dex;
        address[] paths;
    }

    struct SwapInfo {
        address dex;
        address[] paths;
    }
}
