# Starknet Reward System Smart Contract

## Overview
This is a Starknet smart contract that implements a points-based reward system. Users can accumulate and redeem points through a transparent and secure blockchain mechanism.

## Features
- Add points for users
- Redeem points
- Track individual user points
- Track total points distributed
- Event logging for points addition and redemption

## Contract Interface
The contract provides the following functions:
- `add_points(user: ContractAddress, points: u64)`: Add points to a specific user
- `redeem_points(points: u64)`: Redeem points for the caller
- `get_points(user: ContractAddress) -> u64`: Retrieve points balance for a user
- `get_total_points_distributed() -> u64`: Get the total points distributed across all users

## Events
The contract emits two types of events:
- `PointsAdded`: Triggered when points are added to a user's account
- `PointsRedeemed`: Triggered when a user redeems points

## Security Features
- Prevents point redemption if insufficient balance
- Uses Starknet's built-in address and storage mechanisms
- Tracks total points distributed

## Technical Details
- Written in Cairo
- Developed for Starknet
- Uses Starknet's `ContractAddress` and storage `Map`

## Usage Example
```cairo
// Adding points to a user
reward_system.add_points(user_address, 100);

// Checking user's point balance
let points = reward_system.get_points(user_address);

// Redeeming points
reward_system.redeem_points(50);
```

## Error Handling
- Throws 'Insufficient points' error when attempting to redeem more points than available

## Deployment
To deploy this contract, you'll need:
- Starknet development environment
- Cairo compiler
- Starknet CLI or compatible deployment tool

