// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet {
    uint256 public constant MAX_AMOUNT = 1 ether;
    uint256 public numOfFunders;
    string withdrawError = "Cannot withdraw funds more than 1 ether";
    mapping(address => bool) public funders;
    mapping(uint256 => address) public lutFunders;

    constructor() {
        owner = msg.sender;
    }

    function emitLog() public pure override returns (bytes32) {}

    //this is a special function
    //it's called when you make a tx that doesn't specify
    //function name to call

    //External function are part of the contract interface
    //Which means they can be called via contracts other txs.
    receive() external payable {}

    modifier limitWithdraw(uint256 withdrawAmount) {
        require(withdrawAmount < MAX_AMOUNT, withdrawError);
        _;
    }

    function test1() external onlyOwner {
        //management that only admin can use
    }

    function test2() external view onlyOwner {
        //management that only admin can use
        test3();
    }

    function addFunds() external payable {
        address funder = msg.sender;
        if (!funders[funder]) {
            numOfFunders++;
            funders[funder] = true;
            lutFunders[numOfFunders] = funder;
        }
    }

    function withdraw(uint256 withdrawAmount)
        external
        limitWithdraw(withdrawAmount)
    {
        payable(msg.sender).transfer(withdrawAmount);
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);

        for (uint256 i = 0; i < numOfFunders; i++) {
            _funders[i] = lutFunders[i];
        }

        return _funders;
    }

    function getFunderAtIndex(uint8 index) external view returns (address) {
        return lutFunders[index];
    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    //pure, view functions are part of the contract interface
    //pure - even more strict, indicating that it won't read or write state
    //view - indicates that the function will not alter the storage state in any way.
    //No gas fees
    //Transactions have gas fees
}

//const instance = await Faucet.deployed()
//instance.addFunds({from:accounts[0], value:"1000000000000000000"})
//instance.withdraw("5500000000000000000",{from:accounts[0]})
