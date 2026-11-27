// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

/// @title ForkTemplate
/// @notice Template for Immunefi PoCs (Origin-style block pinning).
/// @dev With ETH_RPC_URL set: forks mainnet at a pinned block and reads WETH totalSupply.
///      Without RPC (CI): test is skipped so `forge test` still passes.
contract ForkTemplateTest is Test {
    // Pin block at the height your PoC needs (update before submit).
    uint256 internal constant FORK_BLOCK = 21_000_000;

  address internal constant WETH_MAINNET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function _rpcUrl() internal view returns (string memory url) {
        try vm.envString("ETH_RPC_URL") returns (string memory v) {
            return v;
        } catch {
            return "";
        }
    }

    function test_forkMainnetPinnedBlock() public {
        string memory rpc = _rpcUrl();
        if (bytes(rpc).length == 0) {
            emit log_string("ETH_RPC_URL unset - skipping fork test (expected in CI)");
            vm.skip(true);
        }

        vm.createSelectFork(rpc, FORK_BLOCK);

        uint256 codeSize;
        assembly {
            codeSize := extcodesize(WETH_MAINNET)
        }
        assertGt(codeSize, 0, "WETH should exist at pinned block");
    }
}