// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract RealState {

    struct Property {
        uint256 price; 
        address owner;
        bool forsale;
        string name;
        string description;
        string location;
        string locality;
        address previousowner;
        address nominee;
    }

    mapping (uint256 => Property) public properties;



    function addProperty(
        uint256 _id,
        uint256 _price, 
        address _owner,
        bool _forsale,
        string memory _name,
        string memory _description,
        string memory _location,
        string memory _locality,
        address _previousowner,
        address _nominee
    ) public {
        Property memory newProperty = Property({
            price: _price,
            owner: _owner,
            forsale: _forsale,
            name: _name,
            description: _description,
            location: _location,
            locality: _locality,
            previousowner: _previousowner,
            nominee: _nominee
        });

        properties[_id] = newProperty;

       
    }

    function transferOwnership(uint256 _id, address _newOwner) internal {
        Property storage prop = properties[_id];
        address previousOwner = prop.owner;
        prop.previousowner = previousOwner;
        prop.owner = _newOwner;
        prop.forsale = false; // if it is sold then for sale option should be hidden

        // sale is done thts why sending money to owner
        payable(previousOwner).transfer(prop.price);

       
    }

    function buyProperty(uint256 _id) public payable {
        Property storage prop = properties[_id];
        
        // if the property is for sale
        require(prop.forsale, "Property is not for sale");

        // Check if the correct amount of Ether was sent
        uint256 expectedPrice = prop.price;
        uint256 sentAmount = msg.value;

        require(sentAmount == expectedPrice, "Incorrect price sent. Please send the exact amount.");

        // Ensure the buyer is not the current owner
        require(msg.sender != prop.owner, "Owner cannot buy their own property");

        // Transfer ownership and handle payment
        transferOwnership(_id, msg.sender);

       
    }

    function setNominee(uint256 _id, address _newNominee) public {
        Property storage prop = properties[_id];
        require(msg.sender == prop.owner, "Only the owner can set the nominee");
        prop.nominee = _newNominee;

       
    }
}
