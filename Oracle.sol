// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable {
    struct Request {
        string identifier;
        uint256[] responses;
        address[] respondedNodes;
        bool resolved;
        uint256 result;
    }

    mapping(uint256 => Request) public requests;
    mapping(address => bool) public authorizedNodes;
    uint256 public requestCount;
    uint256 public constant MIN_RESPONSES = 3;

    event DataRequested(uint256 requestId, string identifier);
    event DataProvided(uint256 requestId, address node, uint256 data);

    constructor() Ownable(msg.sender) {}

    function registerNode(address node) external onlyOwner {
        authorizedNodes[node] = true;
    }

    function createRequest(string memory _identifier) external returns (uint256) {
        uint256 requestId = requestCount++;
        Request storage r = requests[requestId];
        r.identifier = _identifier;
        r.resolved = false;

        emit DataRequested(requestId, _identifier);
        return requestId;
    }

    function fulfillRequest(uint256 _requestId, uint256 _data) external {
        require(authorizedNodes[msg.sender], "Not an authorized node");
        Request storage r = requests[_requestId];
        require(!r.resolved, "Request already resolved");

        r.responses.push(_data);
        r.respondedNodes.push(msg.sender);

        emit DataProvided(_requestId, msg.sender, _data);

        if (r.responses.length >= MIN_RESPONSES) {
            r.result = aggregate(r.responses);
            r.resolved = true;
        }
    }

    function aggregate(uint256[] memory _values) internal pure returns (uint256) {
        // Simple average aggregation for demonstration
        uint256 sum = 0;
        for (uint256 i = 0; i < _values.length; i++) {
            sum += _values[i];
        }
        return sum / _values.length;
    }
}
