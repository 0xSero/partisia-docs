# How to run a reader node


## Why you need a reader node

Readers are useful for getting information from the blockchain. Be it from the state of accounts and contracts or information about specific blocks. It is more than likely that you will need to utilize a reader for any dApp. If many parties query the same reader, it might be slowed down or become unstable. For this reason you will want to have your own reader for development.

## Step by step

To get your reader node you are completing 4 of the 10 steps from the block producer node guide. Use the links below, so you do not end up following unnecessary steps.

1. [Recommended hardware and software](recommended-hardware-and-software.md)
1. [Get a VPS](vps.md)
1. [Secure your VPS](secure-your-vps.md)
1. [Run a reader node on a VPS](reader-node-on-vps.md)

## How to get information from the reader

You can query a reader for many kinds of information. The blockchain state is available as JSON. Let us say you want to know how much value is on a specific account or even on the entire blockchain in the form of MPC tokens and BYOC. You can call up the reader and get the JSON of each account state on each shard and sum the values.

You can make a script to solve these types of problems. To do this you need to know the fields in a state that you are checking, so you can parse them correctly. You also need to be sure that your call hits the correct URL of the reader and shard containing the information. Below is an example of a Python script calling the PBC infrastructure reader for account information and summing up the values in each account.

```PYTHON
import requests
import json

urls = [
    "https://reader.partisiablockchain.com/shards/Shard0/blockchain/accountPlugin/local/",
    "https://reader.partisiablockchain.com/shards/Shard1/blockchain/accountPlugin/local/",
    "https://reader.partisiablockchain.com/shards/Shard2/blockchain/accountPlugin/local/"
]

sum_staked_to_contract = 0
sum_staked_tokens = 0
sum_vesting_accounts_tokens = 0
sum_balances = 0
sum_delegated_from_others = 0
sum_pending_delegated_stakes = 0

for url in urls:
    try:
        payload = json.dumps({"path": []})
        headers = {"Content-Type": "application/json"}
        response = requests.request("POST", url, headers=headers, data=payload)

        accounts = json.loads(response.text)["accounts"]
        for account in accounts:
            # Sum stakedToContract values
            staked_to_contract = account.get("value", {}).get("stakedToContract", [])
            if staked_to_contract:
                for value in staked_to_contract:
                    sum_staked_to_contract += int(value["value"])

            # Sum stakedTokens values
            staked_tokens = account.get("value", {}).get("stakedTokens", 0)
            sum_staked_tokens += int(staked_tokens)

            # Sum vestingAccounts tokens
            vesting_accounts = account.get("value", {}).get("vestingAccounts", [])
            if vesting_accounts:
                for account_vesting in vesting_accounts:
                    sum_vesting_accounts_tokens += int(account_vesting["tokens"])

            # Sum account balances
            account_coins = account.get("value", {}).get("accountCoins", [])
            if account_coins:
                for coin in account_coins:
                    sum_balances += int(coin["balance"])

            # Sum delegatedStakesFromOthers values
            delegated_stakes_from_others = account.get("value", {}).get("delegatedStakesFromOthers", [])
            if delegated_stakes_from_others:
                for delegate in delegated_stakes_from_others:
                    sum_delegated_from_others += int(delegate["value"]["acceptedDelegatedStakes"])
                    sum_pending_delegated_stakes += int(delegate["value"]["pendingDelegatedStakes"])

    except Exception as e:
        print("Error occurred:", e)

print("Total stakedToContract:", sum_staked_to_contract)
print("Total stakedTokens:", sum_staked_tokens)
print("Total vestingAccounts tokens:", sum_vesting_accounts_tokens)
print("Total account balances:", sum_balances)
print("Total delegatedStakesFromOthers:", sum_delegated_from_others)
print("Total pendingDelegatedStakes:", sum_pending_delegated_stakes)

```