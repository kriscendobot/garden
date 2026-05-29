---
title: The Escrow Exchange Contract and the Generic Contract Host (all-or-nothing trade with cancellation; Q.race + Q.all + failOnly composition; setup/play tokens; what Alice and Bob must agree on)
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
---

## Abstract

§5 develops the **escrow exchange contract** as a worked example of *composing* the §4 mint-purse machinery into a non-trivial smart contract. The §5 scenario: Alice has $10 in one bank, Bob has 7 shares of stock at another bank; they wish to trade *all-or-nothing* — both transfers succeed, or neither succeeds (with original assets returned to original owners). Five players are involved: Alice, Bob, a money issuer, a stock issuer, and an *escrow exchange agent* (the contract). The §5 paper shows the escrow exchange contract in **22 lines of JavaScript** using only the §2-§4 primitives. The contract uses a **Q.race against a Q.all** composition: until a player cancels, the Q.all of both transfers wins; either cancellation rejects the race. The §5 paper closes with a structural observation about the *makePurse* discipline: the contract avoids dishonest-purse attacks by using `Q.join` on `(srcPurseP ! makePurse, dstPurseP ! makePurse)` to obtain a *mutually acceptable* fresh escrow purse — neither Alice's purse nor Bob's purse alone can fool the agent. §6 generalizes from the specific escrow-exchange contract to the **generic Contract Host** — infrastructure that can host *any* contract formulated as a function. The Contract Host's `setup` method takes a contract source string, evaluates it (via `confine`), and returns an array of *tokens* (one per contract parameter); the `play` method takes a token, alleged-source, alleged-side-index, and the player's argument, and consumes the token to complete its parameter slot. Once all parameters arrive, the contract function is called, and its result resolves the outcome promise the contract host returned. The §6 architectural payoff: Alice and Bob no longer need to agree on a *specific* trusted broker for each contract; they only need to agree on (a) the issuers of each right, (b) the contract source code, (c) which side they are playing, and (d) a third party they mutually trust to honestly run *some* contract — *whatever it is*. §7 closes with the architectural thesis: human society uses *rights* as a scalable means for organizing complex cooperative interactions of decentralized agents with diverse interests; Dr. SES enables the expression of new kinds of rights and smart contracts *simply*.

## Body

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

## Translation block (paper idiom → contemporary Endo / Agoric surface)

| 2013 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| Escrow exchange contract | Agoric Zoe's *atomic swap* contract is the production enactment. |
| Q.join on shared `makePurse` for purse verification | Agoric ERTP brand-check: `issuer.getBrand() === expectedBrand` is the modern verification. |
| Contract Host with setup + play tokens | **Agoric Zoe** is the production realization. Zoe's *invitation* primitive is the 2013 token; Zoe's contract-instance setup-and-offer flow is the §6 setup-and-play flow. |
| Confine for evaluating contract source | Agoric Zoe runs contracts in Hardened JavaScript compartments via `@endo/static-module-record` / module-source; the architectural pattern is identical. |
| What Alice and Bob must agree on | The same four points apply to Agoric Zoe contracts: agree on the issuers, the contract code (Zoe shows the *instance hash* of the contract), which side you're playing, and a trusted Zoe deployment. |
| Q.race against Q.all | `Promise.race` against `Promise.all` is now ES native; the architectural pattern composes the same way. |
| failOnly idiom | A pattern: a promise that *only* rejects (never resolves successfully); used to cancel a race. |

## Implications for Endo

This section is the **direct architectural ancestor of Agoric Zoe**. The library can cite this paper whenever:

1. **A design names Zoe or smart-contract framework.** §6's Contract Host is Zoe at 22 lines of JavaScript. The contemporary Zoe is the production scaling with additional concerns (deployable contract instances, governance, fees, etc.) but the structural pattern is unchanged.
2. **A design discusses atomic swap / escrow / two-phase commit at the contract layer.** §5 is the canonical worked example. The Q.all + Q.race + failOnly composition is the canonical atomic-commit pattern.
3. **A design discusses contract-participation tokens.** §6's *redeem the token to obtain the exclusive right to play* is the structural ancestor of Zoe's *invitation* primitive. The four-axis taxonomy applies cleanly.
4. **A design discusses what counterparties must agree on.** §6's four-point list (issuers, contract source, side assignment, mutually-trusted contract host) is the canonical answer.

## See also

- [[smart-contract]] — the umbrella concept page. The §5 escrow exchange + §6 Contract Host are the canonical 2013-JavaScript worked example. The cycle-77 concept page now has the Dr. SES lineage anchor and the Zoe production-ancestor lineage.
- [[mint-purse-money]] — §5 escrow exchange uses the §4 mint-purse code as foundational primitive. The two patterns compose.
- [[brand-and-trademark]] — the Q.join on `makePurse` is brand verification at the JavaScript level.
- [[principle-of-least-authority]] — the Contract Host needs *only* the contract source + Q + tokens to run; no other authority. POLA at the contract-runtime layer.
- [[vat-and-compartment]] — the contract runs in a `confine`-isolated compartment; one bundle per contract instance.
- [[agoric-system]] — the broader framework. Zoe is the production agoric-system component this paper anticipates.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the 2000 §6.4 CoveredCallOption is the E-language ancestor of the §5 escrow exchange.

## Common confusions

- **"The escrow exchange is naive — it doesn't handle Byzantine faults."** §5 is explicit about the trust assumptions: Alice and Bob trust the issuers + the contract host; they do not trust each other. If issuers misbehave, the contract loses; if the contract host misbehaves, the contract loses. Byzantine fault tolerance at the issuer / host layer is a *separate* concern; the §5 paper does not address it. Contemporary Agoric production handles it via deployment choices (e.g. running on a blockchain that provides BFT consensus for the issuer + host).
- **"Q.race resolves promiscuously."** §5 is careful about which promises feed the race: only the Q.all of both transfers can *fulfill* the race; the failOnly promises can only *reject* it. So if either Alice or Bob cancels first, the race rejects; if both transfers complete first, the race fulfills with both-completed.
- **"Tokens are just hash keys."** The §6 tokens are *unforgeable references* — `def({})` returns a fresh empty defensible object whose *identity* is the token. The WeakMap uses object-identity, not hash equality, so the token cannot be guessed or forged. The 2013 architectural design depends on this property of JavaScript object identity + WeakMap.
- **"The contract host can read the contract source."** Yes — the contract host *must* read the source to evaluate it via `confine`. But the contract source is *also* a public artifact that Alice and Bob agreed on before initiating the contract instance. The contract host has no privileged read access; it sees what Alice and Bob agreed it would see.
- **"Confining the contract is a sandbox."** Closer than not. The §6 confine creates a fresh global environment containing only the SES whitelisted globals + the explicit endowments (`{ Q: Q }` in §6). The contract has no other ambient authority. The structural-architectural pattern matches the 2003 *Paradigm Regained* §5 arena framing: terms-of-entry checked at compartment-construction time.
- **"This eliminates trust."** No — §6 explicitly enumerates the trust requirements. The reduction is from *contract-specific trust* (the §5 escrow exchange agent) to *generic-host trust* (the §6 Contract Host). Trust is *consolidated* and *amortized* across many contracts, not eliminated.
