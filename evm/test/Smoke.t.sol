// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

/// @notice Always-pass sanity check for CI without RPC.
contract SmokeTest is Test {
    function test_toolchain() public pure {
        assertTrue(true);
    }

    function test_forkBlockPinDocumented() public pure {
        // Origin-style submissions pin a mainnet block in the fork test file, e.g.:
        // vm.createSelectFork(vm.envString("ETH_RPC_URL"), 21_000_000);
        // Re-pin when state drift invalidates your PoC.
        uint256 examplePinnedBlock = 21_000_000;
        assertGt(examplePinnedBlock, 0);
    }
}