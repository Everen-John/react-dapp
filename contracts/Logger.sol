// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

//Its a way for a designer to say that
//"Any child of the abstract contract has to implement the specified methods"

abstract contract Logger {
    uint256 public testNum;

    constructor() {
        testNum = 1000;
    }

    function emitLog() public pure virtual returns (bytes32);

    function test3() internal view returns (uint256) {
        return testNum;
    }
}
