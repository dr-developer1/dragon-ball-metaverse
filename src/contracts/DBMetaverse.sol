pragma solidity >=0.7.0 <0.9.0;

contract DBMetaverse {

    address public owner;
    uint public entranceFee = 0.1 ether;

    constructor() {
        owner = msg.sender;
    }

    struct Item {
        string name;
        uint price;
        address owner;
    }

    struct Tournament {
        string name;
        uint entryFee;
        address[] participants;
    }

    Item[] public items;
    Tournament[] public tournaments;

    mapping(address => Item[]) public userItems;
    mapping(address => bool) public tournamentParticipants;

    function getItems() public view returns (Item[] memory) {
        return items;
    }

    function getTournaments() public view returns (Tournament[] memory) {
        return tournaments;
    }

    function getMyItems() public view returns (Item[] memory) {
        return userItems[msg.sender];
    }

    function myItemsCount() public view returns (uint) {
        return userItems[msg.sender].length;
    }

    function itemsCount() public view returns (uint) {
        require(msg.sender == owner, "Only the owner can see the number of items.");
        return items.length;
    }

    function enterPark() public payable {
        require(msg.value >= entranceFee, "Not enough Ether provided.");
        payable(owner).transfer(entranceFee);
    }

    function buyItem(uint _itemId) public payable {
        Item memory item = items[_itemId];
        require(msg.value >= item.price, "Not enough Ether provided.");
        payable(item.owner).transfer(item.price);
        userItems[msg.sender].push(item);
        item.owner = msg.sender;
    }

    function tradeItems(uint _itemId1, uint _itemId2, address _from, address _to) public {
        Item memory item1 = userItems[_from][_itemId1];
        Item memory item2 = userItems[_to][_itemId2];

        require(item1.owner == _from, "The first user doesn't own the first item.");
        require(item2.owner == _to, "The second user doesn't own the second item.");

        item1.owner = _to;
        item2.owner = _from;

        userItems[_to].push(item1);
        userItems[_from].push(item2);
        delete userItems[_from][_itemId1];
        delete userItems[_to][_itemId2];
    }

    function createTournament(string memory _name, uint _entryFee) public {
        Tournament memory newTournament = Tournament({
            name: _name,
            entryFee: _entryFee,
            participants: new address[](0)
        });
        tournaments.push(newTournament);
    }

    function joinTournament(uint _tournamentId) public payable {
        Tournament storage tournament = tournaments[_tournamentId];
        require(msg.value >= tournament.entryFee, "Not enough Ether provided.");
        payable(owner).transfer(tournament.entryFee);
        tournament.participants.push(msg.sender);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw.");
        payable(owner).transfer(address(this).balance);
    }

    function createItem(string memory _name, uint _price) public {
        require(msg.sender == owner, "Only the owner can create items.");
        Item memory newItem = Item({
            name: _name,
            price: _price,
            owner: msg.sender
        });
        items.push(newItem);
    }

}