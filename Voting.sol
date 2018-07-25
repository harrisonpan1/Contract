pragma solidity ^0.4.0;
contract Voting{
    
    //individual Voter
    struct Voter{
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    //indidual proposal
    struct proposal{
        bytes32 name;
        uint voteCount;
    }
    
    address public chairman;
    mapping (address => Voter) public voters;
    proposal[] public proposals;
    
    function Voting (bytes32[] proposalNames){
        chairman = msg.sender;
        voters[chairman].weight = 1;
        for (uint i = 0; i < proposalNames.length; i++)
            proposals.push(proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
    }
    
    function giveRightToVote(address voter){
        if (msg.sender != chairman || voters[voter].voted)
            throw;
        voters[voter].weight = 1;
    }
    
    function delegate(address to){
        Voter sender = voters[msg.sender];
        if(sender.voted)
            throw;
            
        while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
            to = voters[to].delegate;
        
        if (to == msg.sender)
            throw;
        
        sender.voted = true;
        sender.delegate = to;
        Voter delegate = voters[to];
        
        if (delegate.voted)
            proposals[delegate.vote].voteCount += sender.weight;
        else
            delegate.weight += sender.weight;
            
    }
    
    function vote(uint proposal){
        Voter sender = voters[msg.sender];
        if (sender.voted) throw;
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }
    
    function winningProposal() constant returns (uint winningProposal){
        uint winningVoteCount = 0;
        for(uint p = 0; p < proposals.length; p++){
            if (proposals[p].voteCount > winningVoteCount)
            {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }
    
}
