// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunityEditing {
    struct Content {
        uint256 id;
        string title;
        string body;
        address creator;
        uint256 approvals;
        uint256 disapprovals;
    }

    uint256 public contentCount;
    mapping(uint256 => Content) public contents;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ContentCreated(uint256 id, string title, address indexed creator);
    event ContentUpdated(uint256 id, string title, address indexed editor);
    event ContentApproved(uint256 id, address indexed voter);
    event ContentDisapproved(uint256 id, address indexed voter);

    modifier onlyValidId(uint256 _id) {
        require(_id < contentCount, "Content does not exist.");
        _;
    }

    function createContent(string memory _title, string memory _body) public {
        contents[contentCount] = Content({
            id: contentCount,
            title: _title,
            body: _body,
            creator: msg.sender,
            approvals: 0,
            disapprovals: 0
        });

        emit ContentCreated(contentCount, _title, msg.sender);
        contentCount++;
    }

    function editContent(uint256 _id, string memory _title, string memory _body)
        public
        onlyValidId(_id)
    {
        Content storage content = contents[_id];
        require(msg.sender != address(0), "Invalid address.");

        content.title = _title;
        content.body = _body;

        emit ContentUpdated(_id, _title, msg.sender);
    }

    function approveContent(uint256 _id) public onlyValidId(_id) {
        require(!hasVoted[_id][msg.sender], "You have already voted.");

        Content storage content = contents[_id];
        content.approvals++;
        hasVoted[_id][msg.sender] = true;

        emit ContentApproved(_id, msg.sender);
    }

    function disapproveContent(uint256 _id) public onlyValidId(_id) {
        require(!hasVoted[_id][msg.sender], "You have already voted.");

        Content storage content = contents[_id];
        content.disapprovals++;
        hasVoted[_id][msg.sender] = true;

        emit ContentDisapproved(_id, msg.sender);
    }

    function getContent(uint256 _id)
        public
        view
        onlyValidId(_id)
        returns (
            string memory title,
            string memory body,
            address creator,
            uint256 approvals,
            uint256 disapprovals
        )
    {
        Content memory content = contents[_id];
        return (
            content.title,
            content.body,
            content.creator,
            content.approvals,
            content.disapprovals
        );
    }
}
