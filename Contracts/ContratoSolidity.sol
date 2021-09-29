pragma solidity >=0.7.0 <0.9.0;
contract MyCoin{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
//Asociacion de balance para cada address
    mapping (address => uint256) public balanceOf; 
//Aprobar a una persona para gestionar mis tokens
    mapping (address => mapping(address => uint256)) public allowance; 
    
//Funcion inicializadora del contrato 
    constructor() public{
        name = "My coin";
        symbol = "MC";
        decimals = 18;
        totalSupply = 1000000 * (uint256(10) ** decimals);
        balanceOf[msg.sender] = totalSupply;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

//Esta funcion transfiere tokens de un address a otra.  
    function transfer (address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
         balanceOf[_to] += _value;
         emit Transfer (msg.sender, _to, _value);
         return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
    //Asigna persona autorizada y la cantidad de tokens
    allowance[msg.sender][_spender] = _value;
    emit Approval (msg.sender, _spender, _value);
    return true; 
    }
    
//La dueña del token, a quien va dirigido y el valor. Se comprueba q tenga los token el origen    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balanceOf[_from] >= _value);
//Valido que quien invoca tiene los permisos para manejar esos tokens  
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
//restamos a lo que tiene permiso. 
        allowance[_from][msg.sender] -= _value;
        emit Transfer (_from, _to, _value);
        return true;
    }
}