# Voting Smart Contract Rust Source Code

See [Voting Contract Explained](voting-contract.ms)

````rust
#![allow(unused_variables)]
extern crate create_type_derive;
#[macro_use]
extern crate pbc_contract_codegen;
extern crate pbc_contract_common;

use std::collections::{BTreeMap, BTreeSet};
use std::io::{Read, Write};

use pbc_contract_common::address::Address;
use pbc_contract_common::context::ContractContext;
use pbc_traits::*;

#[state]
pub struct VotingContractState {
    proposal_id: u64,
    mp_addresses: Vec<Address>,
    votes: BTreeMap<Address, u8>,
    closed: u8,
}

impl VotingContractState {
    fn register_vote(&mut self, address: Address, vote: u8) {
        self.votes.insert(address, vote);
    }

    fn close_if_finished(&mut self) {
        if self.votes.len() == self.mp_addresses.len() {
            self.closed = 1;
        };
    }
}

#[action]
pub fn vote(context: ContractContext, state: VotingContractState, vote: u8) -> VotingContractState {
    assert_eq!(state.closed, 0, "The poll is closed");
    assert!(
        state.mp_addresses.contains(&context.sender),
        "Only members of the parliament can vote"
    );
    assert!(
        vote == 0 || vote == 1,
        "Only \"yes\" and \"no\" votes are allowed"
    );

    let mut new_state = state;
    new_state.register_vote(context.sender, vote);
    new_state.close_if_finished();
    new_state
}

#[init]
pub fn initialize(
    _ctx: ContractContext,
    proposal_id: u64,
    mp_addresses: Vec<Address>,
) -> VotingContractState {
    assert_ne!(
        mp_addresses.len(),
        0,
        "Cannot start a poll without parliament members"
    );

    let mut address_set = BTreeSet::new();
    for mp_address in mp_addresses.iter() {
        address_set.insert(*mp_address);
    }
    assert_eq!(
        mp_addresses.len(),
        address_set.len(),
        "Duplicate MP address in input"
    );

    VotingContractState {
        proposal_id,
        mp_addresses,
        votes: BTreeMap::new(),
        closed: 0,
    }
}
````
