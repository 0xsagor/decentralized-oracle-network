# Decentralized Oracle Network

This repository implements a lightweight, professional-grade Oracle system. It allows smart contracts to access external data (like asset prices or weather) without relying on a single centralized source.

### Architecture
* **Request Lifecycle:** A Consumer contract submits a request; Nodes listen and provide data.
* **Aggregation:** Multiple nodes provide data, and the contract calculates the median to prevent outliers or malicious reporting.
* **Incentives:** Nodes must stake tokens to participate and are slashed for providing inaccurate data.

### Technical Components
* **Oracle.sol:** Manages node registration, requests, and data aggregation.
* **Node Client:** A JavaScript-based service that fetches data from external APIs and submits it on-chain.
