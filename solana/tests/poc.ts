import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { PublicKey, SystemProgram, Keypair } from "@solana/web3.js";
import { expect } from "chai";

describe("poc", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.Poc as Program;
  const counter = Keypair.generate();

  it("initialize then increment", async () => {
    await program.methods
      .initialize(new anchor.BN(0))
      .accounts({
        counter: counter.publicKey,
        user: provider.wallet.publicKey,
        systemProgram: SystemProgram.programId,
      })
      .signers([counter])
      .rpc();

    await program.methods
      .increment()
      .accounts({
        counter: counter.publicKey,
      })
      .rpc();

    const acct = await program.account.counter.fetch(counter.publicKey);
    expect(acct.count.toNumber()).to.equal(1);
  });
});