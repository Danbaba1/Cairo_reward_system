#[cfg(test)]
mod Tests {
    use starknet::ContractAddress;
    use starknet::testing;
    use super::RewardSystem;

    #[test]
    #[available_gas(2000000)]
    fn test_add_points() {
        let mut contract_state = RewardSystem::contract_state_for_testing();
        let user = testing::get_address(1);
        
        RewardSystem::RewardSystemImpl::add_points(ref contract_state, user, 100);
        
        let points = RewardSystem::RewardSystemImpl::get_points(@contract_state, user);
        assert(points == 100, 'Incorrect points balance');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_redeem_points() {
        let mut contract_state = RewardSystem::contract_state_for_testing();
        let user = testing::get_address(1);
        
        // First add points
        RewardSystem::RewardSystemImpl::add_points(ref contract_state, user, 100);
        
        // Set the caller address for testing
        testing::set_contract_address(user);
        
        // Redeem points
        RewardSystem::RewardSystemImpl::redeem_points(ref contract_state, 50);
        
        let points = RewardSystem::RewardSystemImpl::get_points(@contract_state, user);
        assert(points == 50, 'Incorrect points after redeem');
    }
}
