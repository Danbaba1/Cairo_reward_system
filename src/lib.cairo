use core::starknet::ContractAddress;
use starknet::storage::Map;

#[starknet::interface]
trait IRewardSystem<TContractState> {
    fn add_points(ref self: TContractState, user: ContractAddress, points: u64);
    fn redeem_points(ref self: TContractState, points: u64);
    fn get_points(self: @TContractState, user: ContractAddress) -> u64;
    fn get_total_points_distributed(self: @TContractState) -> u64;
}

#[starknet::contract]
mod RewardSystem {
    use core::starknet::{ContractAddress, get_caller_address};
    use starknet::storage::Map;
    use super::IRewardSystem;

    #[storage]
    struct Storage {
        user_points: Map<ContractAddress, u64>,
        total_points_distributed: u64
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PointsAdded: PointsAdded,
        PointsRedeemed: PointsRedeemed
    }

    #[derive(Drop, starknet::Event)]
    struct PointsAdded {
        #[key]
        user: ContractAddress,
        points: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PointsRedeemed {
        #[key]
        user: ContractAddress,
        points: u64
    }

    #[abi(embed_v0)]
    impl RewardSystemImpl of IRewardSystem<ContractState> {
        fn add_points(ref self: ContractState, user: ContractAddress, points: u64) {
            let current_points = self.user_points.read(user);
            let new_points = current_points + points;
            self.user_points.write(user, new_points);
            
            let total_distributed = self.total_points_distributed.read();
            self.total_points_distributed.write(total_distributed + points);
            
            self.emit(Event::PointsAdded(PointsAdded { user, points }));
        }
        
        fn redeem_points(ref self: ContractState, points: u64) {
            let caller = get_caller_address();
            let current_points = self.user_points.read(caller);
            
            assert(current_points >= points, 'Insufficient points');
            
            let new_points = current_points - points;
            self.user_points.write(caller, new_points);
            
            self.emit(Event::PointsRedeemed(PointsRedeemed { user: caller, points }));
        }
        
        fn get_points(self: @ContractState, user: ContractAddress) -> u64 {
            self.user_points.read(user)
        }

        fn get_total_points_distributed(self: @ContractState) -> u64 {
            self.total_points_distributed.read()
        }
    }
}
