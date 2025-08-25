# Artisan Authenticity Verification System

A comprehensive blockchain-based system for verifying the authenticity of artisan and craft products, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized platform for:
- **Maker Identity Verification**: Authenticate artisan credentials and skill certifications
- **Product Authentication**: Verify the authenticity and provenance of craft products
- **Traditional Technique Preservation**: Document and preserve traditional crafting methods
- **Fair Trade Pricing**: Ensure transparent and fair compensation for artisans
- **Cultural Heritage Protection**: Safeguard traditional crafts and cultural practices

## System Architecture

The system consists of five interconnected smart contracts:

### 1. Artisan Registry (`artisan-registry.clar`)
- Manages artisan profiles and skill certifications
- Handles verification status and reputation scoring
- Stores artisan metadata and contact information

### 2. Product Authentication (`product-auth.clar`)
- Creates unique product certificates with immutable records
- Links products to verified artisans
- Manages product lifecycle and ownership transfers

### 3. Technique Documentation (`technique-docs.clar`)
- Preserves traditional crafting techniques and methods
- Associates techniques with cultural regions and artisans
- Maintains historical documentation and media references

### 4. Fair Trade Pricing (`fair-trade.clar`)
- Establishes transparent pricing mechanisms
- Tracks artisan compensation and profit sharing
- Manages escrow for secure transactions

### 5. Cultural Heritage (`cultural-heritage.clar`)
- Protects traditional craft categories and cultural significance
- Manages heritage site associations
- Tracks cultural impact and preservation efforts

## Key Features

- **Decentralized Verification**: No single point of failure for authenticity verification
- **Immutable Records**: Blockchain-based certificates that cannot be forged
- **Cultural Preservation**: Digital documentation of traditional techniques
- **Fair Compensation**: Transparent pricing and payment tracking
- **Consumer Trust**: Verifiable authenticity for buyers
- **Artisan Empowerment**: Direct connection between makers and consumers

## Data Structures

### Artisan Profile
- Principal address and identity verification
- Skill certifications and specializations
- Reputation score and verification status
- Cultural heritage associations

### Product Certificate
- Unique product identifier and metadata
- Artisan attribution and technique documentation
- Pricing information and ownership history
- Authenticity verification timestamp

### Technique Documentation
- Traditional method descriptions and instructions
- Cultural significance and historical context
- Associated artisans and regional variations
- Media references and educational materials

## Getting Started

1. Install dependencies: `npm install`
2. Run tests: `npm test`
3. Deploy contracts using Clarinet
4. Initialize system with cultural heritage data

## Testing

The system includes comprehensive tests using Vitest:
- Unit tests for each contract function
- Integration tests for cross-contract interactions
- Edge case testing for security vulnerabilities
- Performance testing for scalability

## Security Considerations

- Input validation for all user-provided data
- Access control for sensitive operations
- Protection against common smart contract vulnerabilities
- Immutable record keeping for audit trails

## Contributing

Please read the PR-DETAILS.md file for contribution guidelines and development standards.
