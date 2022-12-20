MPC token calculations

## For Community stakers

**How many tokens do I own in total**

$$
\boxed{totalTokensOwned = mpcTokens + stakedTokens + \sum_{v \in vestingAccounts} v.tokens - v.released + \sum_{s \in stakedToOthers}^{} s.delegated + \sum_{\substack{ p \in storedPendingDelegated \; | \\ p.countIndex = -1   \; \&! \; p.addIfSucces}}^{} p.amount + \sum_{\substack{ p \in PendingStakedDelegated \; |  \\ p.delegationType = DELEGATE\_STAKE \; \\  OR \; p.delegationType=RETRACT\_DELEGATED\_STAKE}}^{} p.stored + \sum_{p \in pendingUnstake}^{} p + \sum_{p \in pendingRetracted}^{} p}
$$

**How many have I have staked already**

$$
\boxed{totalStaked = stakedTokens + \sum_{s \in stakedToOthers}^{} s.delegated + \sum_{\substack{ p \in PendingStakedDelegated \; |  \\ p.delegationType = DELEGATE\_STAKE \; \\  OR \; p.delegationType=RETRACT\_DELEGATED\_STAKE}}^{} p.stored + \sum_{p \in pendingUnstake}^{} p + \sum_{p \in pendingRetracted}^{} p}
$$

**How many unvested tokens are available to stake to another node**
$$
\boxed{freeTokens = mpcTokens}
$$

**How many tokens are available to unvest**
$$
\boxed{canBeUnvested = \sum_{v \in vestingAccounts}^{} \left\lfloor \frac{v.tokens }{\left\lfloor\frac{v.rDuration}{v.rInterval}\right\rfloor}\right\rfloor \cdot max\left( 0,\left\lfloor \frac{now-v.tGE}{v.rInterval} \right\rfloor \right) - v.releasedTokens}
$$

**How many tokens are waiting to be accepted by a node operator**

$$
\boxed{For \; user \; U:\\
No. \; 1 \; accountDelegatedTo: \\
delegatedFromOthers[U].pending}
$$

## Node Oprators

**How many tokens do I own in total**

$$
\boxed{totalTokensOwned = mpcTokens + stakedTokens + \sum_{v \in vestingAccounts} v.tokens - v.released + \sum_{s \in stakedToOthers}^{} s.delegated + \sum_{\substack{ p \in storedPendingDelegated \; | \\ p.countIndex = -1   \; \&! \; p.addIfSucces}}^{} p.amount + \sum_{\substack{ p \in PendingStakedDelegated \; |  \\ p.delegationType = DELEGATE\_STAKE \; \\  OR \; p.delegationType=RETRACT\_DELEGATED\_STAKE}}^{} p.stored + \sum_{p \in pendingUnstake}^{} p + \sum_{p \in pendingRetracted}^{} p}
$$

**How many tokens have I staked to my own node excluding from others**
$$
\boxed{stakedToMyNode = stakedTokens}
$$

**How many staked on my node including from others**
$$
\boxed{availableStakes= stakedTokens + \sum_{d \in delegatedStakesFromOthers}^{} d.accepted}
$$

**How many tokens have I accepted into my node from the community**
$$
\boxed{acceptedTokens = \sum_{d \in delegatedStakesFromOthers}^{} d.accepted}
$$

**How many tokens are pending my acceptance into my node**
$$
\boxed{pending  \sum_{d \in delegatedStakesFromOthers}^{} d.pending}
$$
