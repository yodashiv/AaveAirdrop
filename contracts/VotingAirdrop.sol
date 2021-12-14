// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.0;

import "./IGovernancePowerDelegationToken.sol";

contract VotingAirdrop {
    address owner;
    address[] delegatees;

    address aaveTokenAddr;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    /** @notice Add this delegatee to the list of delegatees
     *  param: delegatee, address of delegatee
     */ 
    function addDelegatee(address delegatee) public onlyOwner {
        delegatees.push(delegatee);
    }

    /** notice: Assumes that the whale has delegated appropriate voting power to this contract
     */
    function distributeVotingPower() public onlyOwner {
        IGovernancePowerDelegationToken aaveToken = IGovernancePowerDelegationToken(aaveTokenAddr);
        uint256 totalVotingPower = aaveToken.getPowerCurrent(msg.sender, IGovernancePowerDelegationToken.DelegationType.VOTING_POWER);
        uint256 votingPowerPerDelegatee = totalVotingPower / delegatees.length;
        for (uint i = 0; i < delegatees.length; i++) {
            aaveToken.delegateByType(delegatees[i], IGovernancePowerDelegationToken.DelegationType.VOTING_POWER, votingPowerPerDelegatee);
        }
    }

}