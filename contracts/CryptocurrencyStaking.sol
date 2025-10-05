// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title DEADMANStaking
 * @dev Staking contract for DEADMAN tokens with flexible rewards
 */
contract CryptocurrencyStaking is Ownable, ReentrancyGuard, Pausable {
    
    IERC20 public immutable stakingToken;
    
    // Staking configuration
    uint256 public constant MINIMUM_STAKE = 100 * 10**18; // 100 tokens minimum
    uint256 public constant MAXIMUM_STAKE = 1000000 * 10**18; // 1M tokens maximum
    
    // Reward rates (basis points: 500 = 5%)
    uint256 public constant DAILY_REWARD_RATE = 27; // 0.27% daily (~10% annual)
    uint256 public constant WEEKLY_REWARD_RATE = 200; // 2% weekly
    uint256 public constant MONTHLY_REWARD_RATE = 900; // 9% monthly
    
    // Staking periods (in seconds)
    uint256 public constant DAILY_PERIOD = 1 days;
    uint256 public constant WEEKLY_PERIOD = 7 days;
    uint256 public constant MONTHLY_PERIOD = 30 days;
    
    // Staking pools
    enum StakingPeriod { DAILY, WEEKLY, MONTHLY }
    
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 lastClaimTime;
        StakingPeriod period;
        bool active;
    }
    
    // User stakes mapping
    mapping(address => Stake[]) public userStakes;
    mapping(address => uint256) public totalStakedByUser;
    
    // Global statistics
    uint256 public totalStaked;
    uint256 public totalRewardsPaid;
    uint256 public rewardPool;
    
    // Events
    event Staked(address indexed user, uint256 amount, StakingPeriod period, uint256 stakeIndex);
    event Unstaked(address indexed user, uint256 amount, uint256 stakeIndex);
    event RewardClaimed(address indexed user, uint256 reward, uint256 stakeIndex);
    event RewardPoolFunded(uint256 amount);
    event EmergencyUnstake(address indexed user, uint256 amount, uint256 penalty);
    
    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }
    
    /**
     * @dev Stake tokens for a specific period
     * @param amount Amount of tokens to stake
     * @param period Staking period (0=Daily, 1=Weekly, 2=Monthly)
     */
    function stake(uint256 amount, StakingPeriod period) external nonReentrant whenNotPaused {
        require(amount >= MINIMUM_STAKE, "Staking: Amount below minimum");
        require(amount <= MAXIMUM_STAKE, "Staking: Amount above maximum");
        require(totalStakedByUser[msg.sender] + amount <= MAXIMUM_STAKE, "Staking: User stake limit exceeded");
        
        // Transfer tokens from user
        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Staking: Transfer failed");
        
        // Create new stake
        userStakes[msg.sender].push(Stake({
            amount: amount,
            startTime: block.timestamp,
            lastClaimTime: block.timestamp,
            period: period,
            active: true
        }));
        
        // Update totals
        totalStakedByUser[msg.sender] += amount;
        totalStaked += amount;
        
        emit Staked(msg.sender, amount, period, userStakes[msg.sender].length - 1);
    }
    
    /**
     * @dev Calculate pending rewards for a stake
     * @param user User address
     * @param stakeIndex Index of the stake
     */
    function calculateReward(address user, uint256 stakeIndex) public view returns (uint256) {
        Stake memory userStake = userStakes[user][stakeIndex];
        if (!userStake.active) return 0;
        
        uint256 timeStaked = block.timestamp - userStake.lastClaimTime;
        uint256 rewardRate;
        uint256 periodLength;
        
        if (userStake.period == StakingPeriod.DAILY) {
            rewardRate = DAILY_REWARD_RATE;
            periodLength = DAILY_PERIOD;
        } else if (userStake.period == StakingPeriod.WEEKLY) {
            rewardRate = WEEKLY_REWARD_RATE;
            periodLength = WEEKLY_PERIOD;
        } else {
            rewardRate = MONTHLY_REWARD_RATE;
            periodLength = MONTHLY_PERIOD;
        }
        
        uint256 completePeriods = timeStaked / periodLength;
        return (userStake.amount * rewardRate * completePeriods) / 10000;
    }
    
    /**
     * @dev Claim rewards for a specific stake
     * @param stakeIndex Index of the stake to claim rewards from
     */
    function claimReward(uint256 stakeIndex) external nonReentrant {
        require(stakeIndex < userStakes[msg.sender].length, "Staking: Invalid stake index");
        
        Stake storage userStake = userStakes[msg.sender][stakeIndex];
        require(userStake.active, "Staking: Stake not active");
        
        uint256 reward = calculateReward(msg.sender, stakeIndex);
        require(reward > 0, "Staking: No rewards available");
        require(rewardPool >= reward, "Staking: Insufficient reward pool");
        
        // Update stake
        userStake.lastClaimTime = block.timestamp;
        
        // Update totals
        rewardPool -= reward;
        totalRewardsPaid += reward;
        
        // Transfer reward
        require(stakingToken.transfer(msg.sender, reward), "Staking: Reward transfer failed");
        
        emit RewardClaimed(msg.sender, reward, stakeIndex);
    }
    
    /**
     * @dev Unstake tokens after the staking period
     * @param stakeIndex Index of the stake to unstake
     */
    function unstake(uint256 stakeIndex) external nonReentrant {
        require(stakeIndex < userStakes[msg.sender].length, "Staking: Invalid stake index");
        
        Stake storage userStake = userStakes[msg.sender][stakeIndex];
        require(userStake.active, "Staking: Stake not active");
        
        uint256 periodLength;
        if (userStake.period == StakingPeriod.DAILY) {
            periodLength = DAILY_PERIOD;
        } else if (userStake.period == StakingPeriod.WEEKLY) {
            periodLength = WEEKLY_PERIOD;
        } else {
            periodLength = MONTHLY_PERIOD;
        }
        
        require(
            block.timestamp >= userStake.startTime + periodLength,
            "Staking: Staking period not completed"
        );
        
        // Claim any pending rewards first
        uint256 reward = calculateReward(msg.sender, stakeIndex);
        if (reward > 0 && rewardPool >= reward) {
            rewardPool -= reward;
            totalRewardsPaid += reward;
            require(stakingToken.transfer(msg.sender, reward), "Staking: Reward transfer failed");
            emit RewardClaimed(msg.sender, reward, stakeIndex);
        }
        
        // Return staked tokens
        uint256 stakedAmount = userStake.amount;
        userStake.active = false;
        totalStakedByUser[msg.sender] -= stakedAmount;
        totalStaked -= stakedAmount;
        
        require(stakingToken.transfer(msg.sender, stakedAmount), "Staking: Unstake transfer failed");
        
        emit Unstaked(msg.sender, stakedAmount, stakeIndex);
    }
    
    /**
     * @dev Emergency unstake with penalty (50% of staked amount)
     * @param stakeIndex Index of the stake to emergency unstake
     */
    function emergencyUnstake(uint256 stakeIndex) external nonReentrant {
        require(stakeIndex < userStakes[msg.sender].length, "Staking: Invalid stake index");
        
        Stake storage userStake = userStakes[msg.sender][stakeIndex];
        require(userStake.active, "Staking: Stake not active");
        
        uint256 stakedAmount = userStake.amount;
        uint256 penalty = stakedAmount / 2; // 50% penalty
        uint256 returnAmount = stakedAmount - penalty;
        
        // Update state
        userStake.active = false;
        totalStakedByUser[msg.sender] -= stakedAmount;
        totalStaked -= stakedAmount;
        rewardPool += penalty; // Add penalty to reward pool
        
        require(stakingToken.transfer(msg.sender, returnAmount), "Staking: Emergency unstake failed");
        
        emit EmergencyUnstake(msg.sender, returnAmount, penalty);
    }
    
    /**
     * @dev Fund the reward pool (only owner)
     * @param amount Amount of tokens to add to reward pool
     */
    function fundRewardPool(uint256 amount) external onlyOwner {
        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Staking: Fund transfer failed");
        rewardPool += amount;
        emit RewardPoolFunded(amount);
    }
    
    /**
     * @dev Get user's total pending rewards
     * @param user User address
     */
    function getTotalPendingRewards(address user) external view returns (uint256) {
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < userStakes[user].length; i++) {
            if (userStakes[user][i].active) {
                totalRewards += calculateReward(user, i);
            }
        }
        return totalRewards;
    }
    
    /**
     * @dev Get user's active stakes count
     * @param user User address
     */
    function getUserActiveStakesCount(address user) external view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < userStakes[user].length; i++) {
            if (userStakes[user][i].active) {
                count++;
            }
        }
        return count;
    }
    
    /**
     * @dev Pause staking (only owner)
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause staking (only owner)
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}