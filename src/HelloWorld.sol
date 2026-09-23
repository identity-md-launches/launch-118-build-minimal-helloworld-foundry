// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @title HelloWorld
/// @notice A stateless example with a fixed greeting and no administrative powers.
contract HelloWorld {
    /// @notice Returns the same greeting for every caller.
    function greet() external pure returns (string memory) {
        return "Hello, world!";
    }
}
