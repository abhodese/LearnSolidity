pragma solidity >=0.8.0;

contract Library {
    struct Book {
        string name;
        uint256 availableCopies;
        uint256 ownerCount;
        mapping(uint256 => address) ownersHistory;
    }

    Book myBook;

    mapping(uint256 => Book) public BookLedger;
    mapping(string => bool) private isPresent;
    mapping(address => mapping(uint256 => bool)) private isAlreadyIssued;

    modifier bookNotPresent(string memory _name) {
        require(!isPresent[_name], "Book Already present");
        _;
    }

    function addBook(uint256 _bookId, string memory _name, uint256 _copies) public {
        require(bytes(_name).length != 0, "Name cannot be empty");

        BookLedger[_bookId].name = _name;
        BookLedger[_bookId].availableCopies = _copies;
    }

    function addBookCopies(uint256 _bookId, uint256 _copies) public
    {
        require(_copies > 0, "!zero");
        require(bytes(BookLedger[_bookId].name).length != 0, "Book does not exist");
        BookLedger[_bookId].availableCopies = _copies;
    }

    function borrowBook(uint256 _id) public {
        require(!isAlreadyIssued[msg.sender][_id], "Book is already issued");
        isAlreadyIssued[msg.sender][_id] = true;
        Book storage book = BookLedger[_id];
        book.ownersHistory[book.ownerCount] = msg.sender;

    }

    function returnBook(uint256 _id) public {
        require(isAlreadyIssued[msg.sender][_id], "Book is not issued");
        isAlreadyIssued[msg.sender][_id] = false;
    }
}
