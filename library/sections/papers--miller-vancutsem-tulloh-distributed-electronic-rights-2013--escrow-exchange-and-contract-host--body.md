---
title: Body
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "14-19 (§5 The Escrow Exchange Contract; §6 The Contract Host; §7 Conclusions)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, eventual-send, patterns]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host
---

### §5 The escrow exchange contract — all-or-nothing trade

The §5 scenario uses five players:

- **Alice** holds money at the money issuer.
- **Bob** holds stock at the stock issuer.
- **Money issuer** runs the §4 mint-purse code.
- **Stock issuer** also runs the §4 mint-purse code, with units representing shares.
- **Escrow exchange agent** runs the §5 contract code.

Alice and Bob trust the issuers with their respective assets but do *not* trust each other or the escrow exchange agent with their assets. The escrow exchange agent only needs trust *from* Alice and Bob; the agent does not need to trust them.

The §5 escrow exchange contract code (Figure 2):

```
var transfer = (decisionP, srcPurseP, dstPurseP, amount) => {
  var makeEscrowPurseP = Q.join(srcPurseP ! makePurse,
                                dstPurseP ! makePurse);
  var escrowPurseP = makeEscrowPurseP ! ();

  Q(decisionP).then(                              // setup phase 2
    _ => { dstPurseP ! deposit(amount, escrowPurseP); },
    _ => { srcPurseP ! deposit(amount, escrowPurseP); });

  return escrowPurseP ! deposit(amount, srcPurseP); // phase 1
};

var failOnly = cancellationP => Q(cancellationP).then(
  cancellation => { throw cancellation; });

var escrowExchange = (a, b) => {           // a from Alice, b from Bob
  var decide;
  var decisionP = Q.promise(resolve => { decide = resolve; });

  decide(Q.race([Q.all([
      transfer(decisionP, a.moneySrcP, b.moneyDstP, b.moneyNeeded),
      transfer(decisionP, b.stockSrcP, a.stockDstP, a.stockNeeded)
    ]),
    failOnly(a.cancellationP),
    failOnly(b.cancellationP)]));
  return decisionP;
};
```

The structural reading of the §5 transfer function:

- **Lines 2-3**: `Q.join(srcPurseP ! makePurse, dstPurseP ! makePurse)` — both purses must return the *same* `makePurse` function. The §4 mint-purse-money pattern guarantees that *all purses of the same currency at the same issuer share the same `makePurse` function as their object identity*. So this Q.join checks: *src and dst are purses of the same currency at the same issuer*. If they aren't, the join fails and the transfer aborts.
- **Line 4**: `makeEscrowPurseP ! ()` — call the shared `makePurse` to create a fresh escrow purse at the same issuer. The escrow purse is at the issuer Alice and Bob both trust, *but the agent has no prior reference to it*; the agent just-now-acquired-it through the contract setup.
- **Line 5-7**: `Q(decisionP).then(...)` — sets up phase 2. When the contract's overall `decisionP` resolves successfully, deposit from the escrow purse to the destination; when it rejects, deposit back to the source. (Source and destination always refer to the *original* purses; the escrow purse is the intermediate.)
- **Line 8**: `return escrowPurseP ! deposit(amount, srcPurseP)` — phase 1 of the two-phase commit: try to transfer the money from src to the escrow purse. If this succeeds, the money is escrowed; the overall contract can decide whether to complete or refund. If this fails, this transfer's promise rejects, and the overall escrowExchange's decisionP rejects.

The structural reading of the §5 escrowExchange function:

- **Line 13-14**: `Q.promise(resolve => { decide = resolve; })` — get a hold on the promise's resolve function. This is the *decisionP* that controls phase 2 of all transfers.
- **Lines 15-19**: `decide(Q.race([Q.all([transfer1, transfer2]), failOnly(a.cancellationP), failOnly(b.cancellationP)]))` — the *race* is what determines the contract's outcome.
  - **Q.all** wins (fulfilling decide) when *both* transfers succeed.
  - **failOnly(a.cancellationP)** rejects decide when Alice fulfills her cancellation promise.
  - **failOnly(b.cancellationP)** rejects decide when Bob fulfills his cancellation promise.
- Whichever resolves first determines the contract's outcome.

The §5 paper notes the **dishonest-purse defense** the Q.join construction provides: the agent has no prior reference to either purse's `makePurse` method. If the agent simply called `srcPurseP ! makePurse()`, Alice could return a dishonest purse that pretends deposits work without actually transferring funds. By requiring `Q.join(srcPurseP ! makePurse, dstPurseP ! makePurse)`, the agent ensures both src and dst purses agree on the same `makePurse` function — and the §4 mint-purse code guarantees that same-purse-function implies same-currency-same-issuer. The agent's correct behavior is thus underwritten by the *issuer*'s correctness, not by trust in either Alice or Bob.

### §6 The Contract Host — hosting any contract

§6 takes the next architectural step: *once Alice and Bob agree on a contract, how do they arrange for it to be run in a mutually trusted manner?* The §5 escrow exchange required Alice and Bob to agree on a specific escrow exchange agent. If they negotiated a custom contract specialized to their needs, they should not expect to find a mutually-trusted third party specializing in running that particular contract.

The §6 paper develops the **Contract Host** — infrastructure that can host *any* contract formulated as a function. The Contract Host code (Figure 3):

```
var makeContractHost = () => {
  var m = WeakMap();

  return def({
    setup: contractSrc => {
      contractSrc = ''+contractSrc;
      var tokens = [];
      var argPs = [];
      var resolve;
      var resultP = Q.promise(r => { resolve = r; });
      var contract = confine(contractSrc, { Q: Q });

      var addParam = (i, token) => {
        tokens[i] = token;
        var resolveArg;
        argPs[i] = Q.promise(r => { resolveArg = r; });
        m.set(token, (allegedSrc, allegedI, arg) => {
          if (contractSrc !== allegedSrc) {
            throw new Error('unexpected contract: '+contractSrc);
          }
          if (i !== allegedI) {
            throw new Error('unexpected side: '+i);
          }
          m.delete(token);
          resolveArg(arg);
          return resultP;
        });
      };
      for (var i = 0; i < contract.length; i++) {
        addParam(i, def({}));
      }
      resolve(Q.all(argPs).then(
        args => contract.apply(undefined, args)));
      return tokens;
    },
    play: (tokenP, allegedSrc, allegedI, arg) => Q(tokenP).then(
      token => m.get(token)(allegedSrc, allegedI, arg))
  });
};
```

The §6 paper walks the structural reading:

- **`setup(contractSrc)`**: One party (Bob in the running example) initiates the contract instance by sending the contract host the contract source code. The host evaluates it via `confine` in a fresh global environment with only `Q` as endowment. The host allocates one unguessable *token* per contract parameter (each `def({})` returns a tamper-proof empty object whose identity serves as the token). Each token is registered in the host's WeakMap with a *play-this-token* callback.
- **`play(tokenP, allegedSrc, allegedI, arg)`**: A player calls play with their token, their alleged source-code claim, their alleged side-index, and their argument. The host looks up the play-callback in the WeakMap (using the token as the unforgeable identifier), verifies the alleged source matches the actual contract source, verifies the alleged side matches the expected index, deletes the token (so it cannot be redeemed twice), and resolves the corresponding parameter promise with the argument.
- **`Q.all(argPs).then(args => contract.apply(undefined, args))`**: Once all parameters arrive, the contract function is called with the collected arguments, and its result resolves the previously-returned `resultP`.

The §6 paper closes with the architectural payoff:

> By redeeming the token, Alice obtains the exclusive right to play a specific contract whose logic she knows, and whose play she expects to cause external effects. This eright is exclusive, specific, measurable, and exercisable.

So the *contract participation token* is itself an eright that exemplifies all four corner cases of the §3.3 rights taxonomy: exclusive (token consumed on play), specific (designates the contract instance), measurable (can be checked against the alleged source/side), exercisable (play causes contract effects).

**What must Alice and Bob agree on?** Per the §6 paper:

- The *issuers* of each of the rights at stake.
- The *source code* of the contract.
- *Who is to play which side* of the contract.
- *A third party they mutually trust to run their agreed code, **whatever it is**, honestly*.

The reduction: the trust requirement is *not* about agreeing on a contract-specific broker, but about agreeing on a *generic* contract host they both trust. The contract host runs *whatever contract code Alice and Bob agreed on*, with no special-case logic for any particular contract.

### §7 Conclusions

§7 closes the paper with the architectural framing:

> In human society, rights are a scalable means for organizing the complex cooperative interactions of decentralized agents with diverse interests. This perspective is helping us shape JavaScript into a distributed resilient secure programming language. We show how this platform would enable the expression of new kinds of rights and smart contracts *simply*, supporting new forms of cooperation among computational agents.

The §7 closing acknowledgements thank the e-lang community, the Google Caja group for SES growth and deployment, TC39 for making ES5 + successors friendly to ocaps, Tyler Close for Ken + Q, Terence Kelly for the new Ken, and **Kris Kowal for the new Q** — the contemporary @endo/eventual-send package.
