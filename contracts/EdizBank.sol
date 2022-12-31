// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ediz20.sol";

contract EdizBank {

    event token_deposit(address Depositer, uint256 Amount);
    event token_withdraw(address Taker, uint256 Amount);
    event eth_withdraw(address TakerEth, uint256 Amount);
    event eth_deposit(address DepositerEth, uint256 Amount);


    ERC20 Token;
    address _tknAddress;
    uint256 private _totalCustomer;

    mapping(address => mapping(address => uint256)) _balanceOfCustomerToken;
    mapping(address => uint256) _balanceOfCustomerEther;
    mapping(address => bool) _isCustomer;

    constructor(address tokenAddress){
        Token = ERC20(tokenAddress);
        _tknAddress = tokenAddress;
    }

    function deposit(uint256 _amount) public {

        require(_amount > 0, "Gas is not free");
        if(!_isCustomer[msg.sender]){
            _totalCustomer++;
            _isCustomer[msg.sender] = true;
        }
        _balanceOfCustomerToken[msg.sender][_tknAddress] += _amount;

        bool isPayed = Token.transferFrom(msg.sender, address(this), _amount);
        require(isPayed, "Token couldn't enter");
        emit token_deposit(msg.sender, _amount);
    }

    function depositEther() public payable{
        require(msg.value > 0, "Gas is not free");
        if(!_isCustomer[msg.sender]){
            _totalCustomer++;
            _isCustomer[msg.sender] = true;
        }
        _balanceOfCustomerEther[msg.sender] += msg.value;

        emit eth_deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(_amount <= _balanceOfCustomerToken[msg.sender][_tknAddress], "You are broke man!!");
        _balanceOfCustomerToken[msg.sender][_tknAddress] -= _amount;

        bool isTransfered = Token.transferFrom(address(this), msg.sender, _amount);
        require(isTransfered, "Token couldn't transfered");
        emit token_withdraw(msg.sender, _amount);
    }

    function withdrawEther(uint256 _amountOfEther, address payable _to) external {
        require(_amountOfEther <= _balanceOfCustomerEther[msg.sender], "Not enough balance");
        _balanceOfCustomerEther[msg.sender] -= _amountOfEther;

        _to.transfer(_amountOfEther);
        emit eth_withdraw(msg.sender, _amountOfEther);
    }
    
}