pragma solidity ^0.5.0;
/*
Owner functions are start with (O) so select the required address before using the owner functions.

user can create account, deposit, withdraw, and check the balance of their accountHolders

when someone deploye the contract you must send 50 or more ether to gain the ownership of the bank.
if you do this then some extra ownersPrivileges you will have

*/

interface Ibank{
    function deposit() external payable returns(string memory);
    function withdrawal(uint Ethers) external payable returns(string memory, uint);
    function checkbalance() external view returns(uint yourBalanceInEthers);
}

contract IslamicBank is Ibank{
    // uint private totalBalance;
    // address payable public Capital;
    address payable private Owner;
    address payable[] arrayOfAddresses;
    mapping (address => Account) private accountHolders;
    
    struct Account{
        string name;
        bool accountCreated;
        uint balance;
    }
    
    constructor() public payable {
        if(msg.value >= 50 ether){
            Owner = msg.sender;
            
        }
        else if(msg.value < 50 ether){
            msg.sender.transfer(msg.value);
        }
    }
    
    modifier isOwnerSet() {
        if(Owner != 0x0000000000000000000000000000000000000000 && address(this).balance >= 50 ether){
            _;
        }
    }
    
    function getOwnerAddress() public view returns(address) {
        return Owner;
    }
    
    modifier ownersPrivileges(){
        if(Owner == msg.sender){
            _;
        }
    }
    
    
    function OwnerShip() public view returns(string memory){
        if(Owner == 0x0000000000000000000000000000000000000000 && address(this).balance < 50 ether){
            return "Bank is not Opened because Owner deployed the contract with insufficient capital!, must send 50 ether min and redeploy the contract";
        }
        else{
            return "Ownership is defined everything is fine";
        }
    }
    
    function CreateAccount(string memory _name) public payable isOwnerSet returns(string memory) {
        if(msg.value == 0 && accountHolders[msg.sender].balance == 0){
            
            return "Account can't be created with zero balance";
        
        }
        
        else if(accountHolders[msg.sender].balance !=0){
            msg.sender.transfer(msg.value);
            return "Account is already created!";
        }
        
        else{
            accountHolders[msg.sender] = Account(_name, true ,msg.value);
            // totalBalance += msg.value;
            arrayOfAddresses.push(msg.sender);
            return "congratulations your account has been created!";
        }
    }
    
    function deposit() public payable returns(string memory) {
        if(accountHolders[msg.sender].accountCreated == true && accountHolders[msg.sender].balance !=0){
            accountHolders[msg.sender].balance += msg.value;
            // arrayOfAddresses.push(msg.sender);
            return "Deposit Transaction Executed Successfully";
        }
        else{
            msg.sender.transfer(msg.value);
            return "Create Your Account First";
        }
    }
    
    function withdrawal(uint Ethers) public payable actualAccountHolder(msg.sender) returns(string memory, uint){
            Ethers *= 1000000000000000000;
        if(Ethers <= accountHolders[msg.sender].balance){
            msg.sender.transfer(Ethers);
            accountHolders[msg.sender].balance -= Ethers;
            return ("if condition inside withdrawal function", msg.value);
        }
        else{
            
        return ("your are requesting more than your balance! Calm Down Dear",msg.value);
        }
    }
    
    modifier actualAccountHolder(address Address){
        if(accountHolders[Address].accountCreated == true){
            _;
        }
    } 
    
    function checkbalance() external view actualAccountHolder(msg.sender) returns(uint yourBalanceInEthers){
    
        yourBalanceInEthers = accountHolders[msg.sender].balance/1000000000000000000;
    }
    
    function OtotalAmount() public view ownersPrivileges returns(uint Ethers){
        return address(this).balance/1000000000000000000;
    }
    
    function OCloseBank() public payable ownersPrivileges returns(uint){
        for(uint i = 0; i < arrayOfAddresses.length; i++){
            arrayOfAddresses[i].transfer(accountHolders[arrayOfAddresses[i]].balance);
        }
        selfdestruct(Owner);
    }
    
    function OInfo(address Address) public view ownersPrivileges returns(string memory _name, uint _balance){
        return(accountHolders[Address].name,accountHolders[Address].balance);
    }

}