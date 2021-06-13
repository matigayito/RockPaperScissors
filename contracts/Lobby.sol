// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

// imports en remix
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract RockPaperScissors is Ownable{
    
 
    struct Game{
        address payable player1;
        address payable player2;
        uint bet;
        bool isFull;
    }
    Game[] games;
    
    function createGame(address payable _host,uint _bet) public{
        games.push(Game(_host,payable(address(0x0)),_bet,false));
    }
    function findGame(uint _minBet, uint _maxBet, address payable _searchingPlayer) public{
        for(uint i = 0; i < games.length; i++){
            if(games[i].isFull == false && games[i].bet > _minBet && games[i].bet < _maxBet){
                joinGame(games[i], _searchingPlayer);
                Game memory joinedGame = games[i];
                games[i] = games[games.length-1];
                delete games[games.length-1];
                // return joinedGame;
            }
        }
    }
    
    
   function joinGame(Game memory _game , address payable joinedPlayer) internal pure {
        _game.isFull = true;
        _game.player2 = joinedPlayer;
    }
    
     function play(uint  _movePlayer1, uint  _movePlayer2, Game memory _game) public{
         require(_movePlayer1 >=0 && _movePlayer1 <=2 && _movePlayer2 >=0 && _movePlayer2 <=2);
         
         uint playerWiner = checkPlay(_movePlayer1,_movePlayer2);
         if(playerWiner == 0){ // esto es una idea nomas, no esta bien aplicada la recursividad
             play(_movePlayer1,_movePlayer2,_game);
         }else if (playerWiner == 1){
             _game.player1.transfer(_game.bet);
         }else{ 
             _game.player2.transfer(_game.bet);
         }
         
     }
     
     function checkPlay(uint _movePlayer1, uint _movePlayer2) internal pure returns (uint winer) {
         // 0 = Rock
         // 1 = Paper
         // 2 = Scissors
         //Tie
         if(_movePlayer1 == 0 && _movePlayer2 == 0 || _movePlayer1 == 1 && _movePlayer2 == 1 
            || _movePlayer1 == 2 && _movePlayer2 == 2){
             return (0); // its a tie
         }
         //Player 1 Wins
         if(_movePlayer1 == 0 && _movePlayer2 == 2 ||
            _movePlayer1 == 1 && _movePlayer2 == 0 ||
            _movePlayer1 == 2 && _movePlayer2 == 1){
                
             return (1); //  player 1 Wins
             
         }else return(2);//  player 2 Wins
         
     }
}   