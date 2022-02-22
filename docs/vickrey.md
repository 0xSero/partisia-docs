# Example of a zero knowledge smart contract on PBC - Vickrey Auction
One of the smart contracts you will be able to implement on PBC is a Vickrey Auction, which is a sealed bid auction where the second highest bid wins. 
When some valuable item changes hands through an auction it is desirable to have the change in ownership registered on an immutable record.  It is however highly undesirable that individual maximum bids are public, since the seller can use a third party to drive up the price to the highest possible price. One of the great advantages of PBC over other blockchains is that zero knowledge computations can be performed on the network parallel to the public transactions on the blockchain.
The second price auction takes as input a list of prices for each account, ordered in arrival by a number. When the computation is initiated by the contract owner, the zero knowledge computation nodes reads the collected input and then create a bit vector consisting of prices and the ordering number. The list of bit vectors is now sorted in MPC. The winner is the first entry (the bidder with the highest price-bid), the price is determined by the size of the second highest bid.

The contract follows these phases: 
- Input
Each participant in the computation delivers their input to the computation. Either via the blockchain with the shares in encrypted form (making the nodes stateless) or directly to the nodes (making the data information-theoretic secure). In both cases the inputter provides commitments stored on the blockchain of each share so the nodes can ensure internal consistency among the nodes.
- Computation
The computation takes the input and runs the designated computation, the separation into phases makes the computation rerunnable without any data leaks. This means that the computation can be restarted in case of a server failure or any other unexpected problem.
- Commitment of output
Each node sends a commit to the chain of each of their shares. When the smart contract has received the shares from every node, the smart contract initiates the next phase.
- Output.
Every node now sends their shares to the smart contract, when a majority has released their shares, the contract has complete information and can open the result up.

Below you can see the Java implementation of the zero knowledge smart contract for the Vickrey Auction:
````json
/** Contract for a second price auction. */
public final class SecondPriceAuctionContract extends RealContract<Winner, StateVoid> {

  /** Create a new second price auction contract. */
  public SecondPriceAuctionContract() {
    super(
        new RealComputation<>() {
          @Override
          public <
                  NumberT extends SharedNumber<NumberT>,
                  BitT extends SharedBit<BitT>,
                  E extends FiniteFieldElement<E>>
              void compute(
                  ZkComputationState<Winner, StateVoid, RealClosed<StateVoid>> state,
                  RealProtocol<NumberT, BitT, E> protocol) {
            ShareStorage<NumberT, BitT> storage = protocol.storage();
            List<SecretBid<NumberT>> bids =
                state.getVariables().stream()
                    .map(ZkClosed::getId)
                    .sorted()
                    .map(id -> new SecretBid<>(id, storage.load(id).get(0).getNumber()))
                    .collect(Collectors.toList());
            ComputeWinner<BitT, NumberT, E> computeWinner = new ComputeWinner<>(bids);
            FiniteFieldElementFactory<E> factory = protocol.elementFactory();
            computeWinner.execute(protocol, Math.max(factory.elementBitSize(), 32));
          }
        });
  }

  @Override
  public Winner onCreate(
      ZkContractContext context,
      ZkState<StateVoid, RealClosed<StateVoid>> zkState,
      SafeDataInputStream invocation) {
    return new Winner();
  }

  /** An open input from the contract owner is treated as the signal to execute the auction. */
  @Override
  public Winner onOpenInput(
      ZkContractContext context,
      ZkState<StateVoid, RealClosed<StateVoid>> zkState,
      Winner state,
      SafeDataInputStream invocation) {
    if (!context.getContractOwner().equals(context.getFrom())) {
      throw new IllegalArgumentException("Only owner can start computation");
    }
    if (zkState.getVariables().size() < 2) {
      throw new IllegalArgumentException("Need at least two bids to compute");
    }
    // computation has two outputs: the bid and the winner id.
    zkState.startComputation(Collections.nCopies(2, null));
    return state;
  }

  /** Treat secret inputs as bids. */
  @Override
  public Winner onSecretInput(
      ZkContractContext context,
      ZkState<StateVoid, RealClosed<StateVoid>> zkState,
      Winner state,
      SecretInputBuilder<StateVoid> input,
      SafeDataInputStream invocation) {
    if (zkState.getCalculationStatus() != CalculationStatus.WAITING) {
      throw new IllegalStateException("Cannot submit inputs after computation has started");
    }
    input.expectBitLength(32);
    zkState.getVariables(context.getFrom()).stream()
        .map(ZkClosed::getId)
        .forEach(zkState::deleteVariable);
    zkState.getPendingInputs(context.getFrom()).stream()
        .map(ZkClosed::getId)
        .forEach(zkState::deletePendingInput);
    return state;
  }

  @Override
  public Winner onComputeComplete(
      ZkContractContext context,
      ZkState<StateVoid, RealClosed<StateVoid>> zkState,
      Winner state,
      List<Integer> createdVariables) {
    zkState.openVariables(createdVariables);
    return state;
  }

  @Override
  public Winner onVariablesOpened(
      ZkContractContext context,
      ZkState<StateVoid, RealClosed<StateVoid>> zkState,
      Winner state,
      List<Integer> openedVariables) {
    RealClosed<StateVoid> winnerVariable = zkState.getVariable(openedVariables.get(0));
    RealClosed<StateVoid> priceVariable = zkState.getVariable(openedVariables.get(1));
    byte[] openWinnerValue = packBitArrayIntoByteArray(winnerVariable.getOpenValue());
    ShareReader winnerReader =
        ShareReader.create(openWinnerValue, winnerVariable.getShareBitLengths().get(0));
    int winnerId = (int) winnerReader.readLong(32);
    BlockchainAddress winnerAddress = zkState.getVariable(winnerId).getOwner();
    byte[] openPriceValue = packBitArrayIntoByteArray(priceVariable.getOpenValue());
    ShareReader priceReader =
        ShareReader.create(openPriceValue, priceVariable.getShareBitLengths().get(0));
    int winnerPrice = (int) priceReader.readLong(32);
    zkState.contractDone();
    return new Winner(winnerAddress, winnerPrice);
  }

  // Pack a little endian bit array into a little endian byte array
  private byte[] packBitArrayIntoByteArray(byte[] bits) {
    int byteLength = ZkClosed.getByteLength(bits.length);
    byte[] result = new byte[byteLength];
    int byteIndex = 0;
    int bitIndex = 0;

    for (byte bit : bits) {
      result[byteIndex] = (byte) (result[byteIndex] | ((bit & 1) << bitIndex));
      bitIndex++;
      if (bitIndex == Byte.SIZE) {
        bitIndex = 0;
        byteIndex++;
      }
    }
    return result;
  }

  @Immutable
  static final class Winner implements StateSerializable {

    final BlockchainAddress bidder;
    final int price;

    public Winner() {
      bidder = null;
      price = 0;
    }

    Winner(BlockchainAddress bidder, int price) {
      this.bidder = bidder;
      this.price = price;
    }

    boolean hasWinner() {
      return this.bidder != null;
    }
  }
}
````

This Java version of the zero knowledge contract has already been run and tested on the TestNet. But, for security reasons the deployable version on MainNet will have to be developed in a Rust like environment. 
