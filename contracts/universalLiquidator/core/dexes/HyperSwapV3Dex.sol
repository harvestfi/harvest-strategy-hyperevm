// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// imported contracts and libraries
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// interfaces
import "../../../base/interface/universalLiquidator/ILiquidityDex.sol";
import "../../../base/interface/uniswap/ISwapRouter02.sol";

// libraries
import "../../libraries/Addresses.sol";

// constants and types
import {UniV3DexStorage} from "../storage/UniV3Dex.sol";

contract HyperSwapV3Dex is Ownable, ILiquidityDex, UniV3DexStorage {
    using SafeERC20 for IERC20;

    function doSwap(
        uint256 _sellAmount,
        uint256 _minBuyAmount,
        address _receiver,
        address[] memory _path
    ) external override returns (uint256) {
        address sellToken = _path[0];

        IERC20(sellToken).safeIncreaseAllowance(
            Addresses.hyperswapV3Router,
            _sellAmount
        );

        bytes memory encodedPath = abi.encodePacked(sellToken);
        for (uint256 idx = 1; idx < _path.length; ) {
            encodedPath = abi.encodePacked(
                encodedPath,
                pairFee(_path[idx - 1], _path[idx]),
                _path[idx]
            );
            unchecked {
                ++idx;
            }
        }

        ISwapRouter02.ExactInputParams memory param = ISwapRouter02
            .ExactInputParams({
                path: encodedPath,
                recipient: _receiver,
                amountIn: _sellAmount,
                amountOutMinimum: _minBuyAmount
            });

        return ISwapRouter02(Addresses.hyperswapV3Router).exactInput(param);
    }

    function pairFee(
        address _sellToken,
        address _buyToken
    ) public view returns (uint24 fee) {
        if (_pairFee[_sellToken][_buyToken] != 0) {
            return _pairFee[_sellToken][_buyToken];
        } else {
            return 500;
        }
    }

    function setFee(
        address _token0,
        address _token1,
        uint24 _fee
    ) external onlyOwner {
        _pairFee[_token0][_token1] = _fee;
        _pairFee[_token1][_token0] = _fee;
    }

    receive() external payable {}
}
