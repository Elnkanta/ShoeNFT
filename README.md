# ShoeNFT

A decentralized platform for creating and trading limited edition digital shoe NFTs with provable scarcity and authenticity on the Stacks blockchain.

## Overview

ShoeNFT allows shoe designers, brands, and enthusiasts to mint digital representations of shoes as non-fungible tokens (NFTs). Each NFT represents a unique digital shoe with verifiable ownership and provenance.

## Features

- Mint limited edition digital shoe NFTs
- Transfer ownership of shoe NFTs
- View metadata including creator, model, and edition number
- Implements the SIP-009 NFT standard for compatibility with Stacks ecosystem

## Contract Functions

### Core Functions

- `mint`: Create a new shoe NFT with metadata
- `transfer`: Transfer ownership of a shoe NFT
- `get-token-metadata`: Retrieve metadata for a specific token

### SIP-009 Standard Functions

- `get-last-token-id`: Get the ID of the last minted token
- `get-token-uri`: Get the URI for a specific token
- `get-owner`: Get the owner of a specific token

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- [Hiro Wallet](https://wallet.hiro.so/)

### Installation

1. Clone this repository
2. Install dependencies with `npm install`
3. Run tests with `clarinet test`