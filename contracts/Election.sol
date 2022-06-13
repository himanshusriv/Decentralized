pragma solidity >=0.4.2 <0.9.0; //We have to specify what version of compiler this code will use

contract Election {
  
  struct Candidate {
    uint id;
    string partyName;
    string name;
    uint voteCount;
  }

  struct Voter {
    uint id;
    address voterAddress;
    bool voted;
  }

  mapping(uint => Candidate) public candidates;
  mapping(address => Voter) public voters;

  uint public candidatesCount;
  uint public votersCount; 
  uint public totalVoted = 0;
  address private owner;

  event eventVote (
    uint indexed _candidateId
  );

  event OwnerSet(address indexed oldOwner, address indexed newOwner);

  modifier isOwner() {
    require(msg.sender == owner ,  "unauthorized");
    _;
  }

  constructor() public{
    owner = msg.sender;
    emit OwnerSet(address(0),owner);
  }

  function getOwner() public view returns(address) {
    return owner;
  }
  
  function changeOwner(address newOwner) public isOwner{
    emit OwnerSet(owner,newOwner);
    owner = newOwner;
  }

  function addCandidate (string memory _partyName,string memory _name) public isOwner {
    candidatesCount++;
    candidates[candidatesCount] = Candidate(candidatesCount,_partyName,_name,0);
  }

  function addVoters(address _voterAddress) public isOwner {
    votersCount++;
    voters[_voterAddress] = Voter(votersCount, _voterAddress, false);
  }

  function vote(uint _candidateId) public {
    require(voters[msg.sender].id > 0);
    require(!voters[msg.sender].voted);
    require(_candidateId > 0 && _candidateId <= candidatesCount);

    voters[msg.sender].voted = true;
    candidates[_candidateId].voteCount++;
    totalVoted++;
    emit eventVote(_candidateId);
  }

  function voteCount(uint _candidateId) public view returns (string memory, string memory, uint) {
    return(candidates[_candidateId].partyName, candidates[_candidateId].name, candidates[_candidateId].voteCount);
  }

  function totalVoters() public view returns (uint) {
    return votersCount;
  }

  function votingRate() public view returns (uint) {
    return totalVoted;
  }
  
  function Winner() public view returns (uint,string memory, string memory, uint) { 
    uint winner = 1; 
    for(uint i = 1; i <= candidatesCount; i++) {
      if(candidates[i].voteCount > candidates[winner].voteCount){
        winner = i;
      }
    }
    return(candidates[winner].id,candidates[winner].partyName, candidates[winner].name, candidates[winner].voteCount);  
  } 
  
}