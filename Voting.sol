// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting {
    struct Voter {
        bool voted;  
        uint256 vote; 
    }
    struct Proposal {
        string name;
        uint256 voteCount; 
    }
    address public chairperson; 
    mapping(address => Voter) public voters; 
    Proposal[4] public proposals; 
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can perform this action");
        _;
    }

  
    constructor(string[4] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].voted = true; 
        voters[chairperson].vote = 0;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals[i] = Proposal({
                name: proposalNames[i],
                voteCount: 0
            });
        }
    }
    function vote(uint256 proposal) public {
        require(!voters[msg.sender].voted, "Already voted.");
        require(proposal < 4, "Invalid proposal.");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = proposal;
        proposals[proposal].voteCount++;
    }

    // Function to get the winning proposal
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < 4; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    // Function to get the name of the winning proposal
    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

    // Function to allow the chairperson to close the voting
    function closeVoting() public onlyChairperson {
        selfdestruct(payable(chairperson)); // Destroy the contract and transfer remaining funds to the chairperson
    }
}