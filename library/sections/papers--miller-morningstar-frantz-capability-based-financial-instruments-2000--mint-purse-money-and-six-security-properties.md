---
title: The Capability-Based Money Example (MintMaker, mint, purse, sealed `decr`; six demonstrable security properties; visual-inspection proofs)
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "15-20 (§3.4 Simple Money — the canonical capability-based money example with its six security properties walked through Alice-pays-Bob)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
---

## Abstract

§3.4 presents what has become **the most-cited single example in the capability-security literature**: a complete money implementation in ~25 lines of E built entirely from object-capability primitives + sealer/unsealer pairs from §3.3. The construction is deliberately minimal — it explicitly does *not* provide blinding, non-repudiation, accounting controls against a cheating issuer, or asset-backing — but it demonstrably has **six security properties** that can be verified by *visual inspection of the code*: (1) only someone with the mint of a given currency can violate conservation of that currency; (2) the mint can only inflate its own currency; (3) no one can affect the balance of a purse they don't have; (4) with two purses of the same currency, one can transfer money between them; (5) balances are always non-negative integers; (6) a reported successful deposit can be trusted as much as one trusts the purse one is depositing into. The structural insight that makes this example matter for the library: **capability discipline enables visual-inspection security proofs**. A reader can scan the code, identify the few load-bearing scope-and-sealing properties, and verify the six properties without needing to reason about the entire universe of programs that might interact with the money. The §3.4 walkthrough of `Alice pays Bob $10` is the canonical Alice-Bob worked example for object-capability programmers; the `deposit` method's use of `unsealer unseal(src getDecr)(amount)` is the canonical *rights amplification* application (you must hold *both* a same-currency purse AND have an amount within balance for the transfer to succeed).

## Body

### §3.4 The MintMaker code

The §3.4 paper opens with a critical disclaimer: *"We are not proposing to actually do money this way!"* The simple example provides none of: blinding (anonymity), non-repudiation (reliable receipts), accounting controls (catching a cheating mint), or backing by widely-valued assets. **Nevertheless this simple money is a wonderful small example of the directness and simplicity with which capabilities allow the expression of arrangements in which mutually suspicious parties can cooperate safely.**

The code:

```
Define MintMaker(name) : any {
    define [sealer, unsealer] := BrandMaker pair(name)
    define mint {
        to printOn(out) {
            out print(`<$name's mint`)
        }
        to makePurse(balance : (_ = 0)) : any {
            define decr(amount : (0..balance)) {
                balance -= amount
            }
            define purse {
                to printOn(out) {
                    out print(`<has $balance $name bucks`)
                }
                to getBalance : any { balance }
                to sprout : any { mint makePurse(0) }
                to getDecr { sealer seal(decr) }

                to deposit(amount : integer, src) {
                    unsealer unseal(src getDecr)(amount)
                    balance += amount
                }
            }
        }
    }
}
```

The structure is *nested* in a way unusual to readers of less-capability-oriented languages:

- **`MintMaker(name)`** makes mints. Each mint defines a separate currency that is not directly convertible with other currencies (money-changers could trade one for the other, providing indirect convertibility).
- **`mint`** can `printOn` itself and `makePurse(balance)` purses of new units. The `mint` directly holds the sealer/unsealer pair: the sealer is used by purses (via `getDecr`) to seal their private `decr` function; the unsealer is used by purses (via `deposit`) to verify that an incoming source-purse's sealed-decr came from a same-currency purse.
- **`purse`** can report its balance, sprout new empty purses of the same currency, expose its sealed `decr` envelope (the *rights amplification* hook), and accept a deposit from another purse.

The `name` variable and the `printOn` methods illustrate no security properties; they exist purely for debugging. Strip them and the example still works.

### The six security properties — verified by visual inspection

The paper claims that the above code *demonstrably* has the following six properties, verifiable by inspection:

1. **Only someone with the mint of a given currency can violate conservation of that currency.** Verification: the `decr` function is the *only* way to decrement a purse's balance, and `decr` is only ever sealed (never returned in cleartext). The sealer that seals `decr` is encapsulated in the mint's lexical scope; only mint-and-its-purses can reach it. To violate conservation of currency *X*, you would need mint-of-X's sealer to forge a `decr`; only the mint-of-X has it.

2. **The mint can only inflate its own currency.** Verification: a mint has access only to the sealer of *its own* currency's brand. To inflate another currency, the mint would need that currency's sealer; the §3.3 sealer/unsealer pair primitive does not let you obtain another pair's sealer from outside its creation context.

3. **No one can affect the balance of a purse they don't have.** Verification: `balance` is a free variable of the `purse` and `decr` closures. The only way to affect the balance is to invoke a method on the purse (or call `decr` from within the purse). To invoke a method on a purse, you must hold a reference to it. *Only connectivity begets connectivity*; the §3 enumeration is what makes this property hold.

4. **With two purses of the same currency, one can transfer money between them.** Verification: the `deposit(amount, src)` method calls `unsealer unseal(src getDecr)(amount)`. The unseal succeeds *only if* `src getDecr` returned an envelope sealed by the same sealer the receiving purse's mint owns — i.e., *src must be a same-currency purse*. If so, the amount is decremented from `src` (via the recovered `decr`) and incremented on the receiving purse.

5. **Balances are always non-negative integers.** Verification: the `decr` function has the type-guard `amount : (0..balance)` — the binding fails (throws) if amount is outside `0..balance`. The `deposit` method has `amount : integer`. Together: balance can only be decremented by `0..balance` (so post-decrement is non-negative) and incremented by `integer ≥ 0` (since the corresponding decrement on the source purse already enforced the bound). E's soft type declarations are the language-level enforcement.

6. **A reported successful deposit can be trusted as much as one trusts the purse one is depositing into.** Verification: this is the deepest property. If Bob's `BobMainPurse.deposit(10, paymentFromAlice)` *returns without throwing*, then Bob can be confident his balance has been credited with $10 — *because Bob trusts BobMainPurse* (it's Bob's own purse, whose code Bob has either inspected or otherwise has reason to trust). The deposit's behavior depends only on the receiving purse's code; if Bob trusts the receiving purse's code, Bob can trust the deposit report.

The §3.4 closing inspection methodology is the second-deepest property of the example: *capability-system rules together with scoping rules allow us to "prove" many security properties through simple visual inspection*. The reader can scan for occurrences of `sealer` and `unsealer` and quickly determine they never escape from the mint and purses of their creating currency. The reader can scan for occurrences of `decr` and see that it can only escape *sealed in an envelope*; since the unsealer cannot escape, the sealed `decr` can only appear as the result of *visible unseal operations*; since this unseal-result is only invoked and never sent in a message, `decr` cannot escape. **Three lines of scoping arguments are sufficient to prove the six properties.**

### Alice pays Bob $10 — the canonical worked example

The §3.4 walkthrough of `Alice pays Bob $10` traces the mechanism. Initial conditions: Alice and Bob each have a main purse of the same currency, and Alice has at least $10.

```
? define paymentForBob := AliceMainPurse sprout
# value: <has 0 MarkM bucks>

? paymentForBob deposit(10, AliceMainPurse)

? bob foo(..., paymentForBob, ...)
```

Step by step:

1. Alice **sprouts** a new empty purse from her main purse. The sprout method returns `mint makePurse(0)` — a freshly-minted, same-currency, zero-balance purse.
2. Alice **transfers** $10 from `AliceMainPurse` into `paymentForBob` via `paymentForBob.deposit(10, AliceMainPurse)`. Under the hood: paymentForBob's mint's unsealer unseals `AliceMainPurse.getDecr` to recover the AliceMainPurse-specific `decr`; the recovered `decr` is invoked with `10` (which is ≤ AliceMainPurse's balance); AliceMainPurse's balance is decremented by 10; then paymentForBob's balance is incremented by 10.
3. Alice **sends Bob `foo(..., paymentForBob, ...)`**. The Granovetter Operator: Alice introduces Bob to `paymentForBob`, transferring the right to send messages to that purse — including the right to deposit from it into Bob's main purse.

What might Bob's `foo` method look like?

```
define Bob {
    to foo(..., payment, ...) {
        BobMainPurse deposit(10, payment)
        # proceed only if we got $10
        ...
    }
}
```

The §3.4 closing argument: this last `deposit` operation is *key*. Its success assures Bob that his main purse has been credited with $10. Under *all* other conditions it must fail. Under *all* conditions, the integrity of the money system must be conserved. All this despite the use of the `payment` parameter, which since it was received from an untrusted source may be any arbitrary object. The `deposit` method must verify that the `src` purse is a purse of the same currency, and if so, that it has adequate funds; if so it must decrement the `src` purse's balance and increment its own balance by the same amount.

The mechanism: in the `deposit` method, the payment is bound to the `src` parameter and the following body is executed:

```
unsealer unseal(src getDecr)(amount)
```

This asks the `src` purse for its `decr` function. A purse implemented by the above code will return an envelope containing the `decr` function and sealed with the sealer of its creating mint. Other objects might return anything. Whatever we get back from `getDecr` we then unseal with the unsealer of our creating mint. This will succeed *only if* the argument is an envelope sealed with the corresponding sealer. One can only get such an envelope from a purse created by the same mint, and therefore of the same currency. **Otherwise it will throw an exception, preventing further action.**

If we succeed at unsealing, we know we have a `decr`-function facet of *some* purse of the same currency. We call it with the amount to transfer. Its `amount` parameter is declared `amount : (0..balance)`, which only binds to the argument if the argument is between 0 and balance; otherwise the binding throws. **Finally, only if the call to the hidden `decr` function succeeds do we increment our own balance.**

## Translation block (paper idiom → Endo / Hardened JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| MintMaker / mint / purse                   | `@agoric/ertp` (or the Agoric IST module equivalent): `makeIssuerKit` → `{ mint, brand, issuer }`. The Endo / Agoric production enactment of this paper's worked example. |
| `BrandMaker pair(name)`                    | `@endo/marshal`'s `makeBrand(iface)` returning a brand. |
| `sealer seal(decr)`                        | A brand-stamped value; @endo/marshal-style "mark this as belonging to this brand". |
| `unsealer unseal(envelope)`                | A brand-checked unwrap; throws if the value wasn't stamped by the matching brand. |
| `decr(amount : (0..balance))`              | An exo method with a method-guard from @endo/patterns: `M.gte(0)` and `M.lte(balance)` shape constraint. |
| `purse.sprout`                             | An issuer method that creates a fresh empty purse of the same brand. Agoric ERTP equivalent: `issuer.makeEmptyPurse()`. |
| `deposit(amount, src)` with sealed-decr verification | An exo method that uses brand-verification via @endo/patterns to confirm `src` is a same-brand purse before invoking its internal balance-mutation. |
| Visual-inspection proof methodology        | The discipline an Endo design reviewer follows: identify the load-bearing scope + brand properties, verify them by reading, accept the design without exhaustive code-path analysis. |

## Implications for Endo

This example is the **canonical citation for several Endo / Agoric primitives and disciplines**:

1. **Brand discipline is sealer/unsealer.** The brand pair Endo's `@endo/marshal` provides IS the §3.3 sealer/unsealer pair. The MintMaker example is the canonical use of brands: the mint's brand stamps the `decr` envelope; the purse's brand-verification on incoming `getDecr` envelopes enforces same-currency.
2. **Rights amplification by composition.** The `deposit` method demonstrates that two references brought together can yield authority neither has alone: you need *both* a same-currency purse AND an amount-within-balance for the transfer to succeed. This is the operational form of §3.3's can+can-opener. Endo's `@endo/exo` class kit method-guards are the language-level enforcement.
3. **The six demonstrable security properties as a design checklist.** When an Endo design proposes a new value-bearing instrument (purse, escrow, escrow-purse-with-policy), the design review can directly invoke the six properties as a checklist. Property 1 (conservation), Property 4 (transferability), and Property 6 (deposit-report trust) are the most-load-bearing.
4. **Visual-inspection proofs.** The §3.4 closing argument that scoping + sealing arguments are *sufficient* to prove security properties is the design-review methodology Endo design reviews implicitly follow. The library can cite this section as the *theoretical justification* for not requiring exhaustive model-checking on Endo bundles whose authority structure is clear-by-inspection.
5. **Agoric ERTP is this example, productionized.** Agoric's Electronic Right Transfer Protocol (ERTP) — the `makeIssuerKit` → `{ mint, brand, issuer }` pattern — is the production enactment of this §3.4 paper code. The library should cite this section whenever discussing ERTP design choices that trace back to the §3.4 invariants.

## See also

- [[caretaker-pattern]] — the §3.4 `decr` function is a *narrower facet* of the purse; the purse's `getDecr` exposes only the sealed-form, not the function itself. Same pattern.
- [[four-ways-to-acquire-references]] — the §3.4 deposit verification depends on *only connectivity begets connectivity*: the unsealer is unreachable except from same-currency purses, which is enforced by the four-ways constraint.
- [[security-as-extreme-modularity]] — the §3.4 visual-inspection-proof methodology IS the operational form of *security as extreme modularity*. The reader is doing the same code review they would do for modularity; the security properties fall out for free.
- [[smallcaps-encoding]] — Endo's marshal serialization layer; brand-stamped values are serialized with their brand identity preserved, enabling cross-vat verification of the same six properties.
- `papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement` — Paradigm Regained's Cassie+Max factory + factoryStamp is the 2003 generalization of this 2000 paper's BrandMaker + sealer/unsealer. The factoryStamp pattern is the trademark form; the sealer/unsealer is the sibling form.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — vats as units of persistence and migration; the §3.4 money example is *single-vat* by default but §4 will distribute it across multiple vats using Pluribus.

## Common confusions

- **"This is real money."** §3.4's opening disclaimer is explicit: this example provides *none* of blinding, non-repudiation, accounting controls, or asset backing. It is a *minimal* example demonstrating that capabilities can express the structure of money; it is not a recommendation to deploy this code. Agoric ERTP and similar production systems add the missing properties on top of the same structural pattern.
- **"Property 6 requires trusting the network."** No — Property 6 says trust in the *deposit report* is bounded by trust in the *receiving purse's code*. The receiving purse is Bob's own; Bob can inspect its code or otherwise have reason to trust it. The network is not in the trust path because the receiving purse's `deposit` method is the one verifying.
- **"The unsealer could be stolen by inspecting the mint."** §3.3 sealer/unsealer pairs are unguessable language primitives. Inspection of the mint *from outside* cannot reach the sealer/unsealer — they are free variables of nested closures, only reachable from inside the mint's scope. *Only connectivity begets connectivity* protects them.
- **"`decr` could escape by being passed to an attacker as a sealed envelope."** Yes, it can — but the *envelope* is useless without the matching unsealer, which is only accessible to the matching mint's purses. The attacker holding a sealed `decr` envelope can pass it around but cannot use it.
- **"This requires named brands ('MarkM')."** No — the `name` parameter is purely cosmetic. Strip it (along with `printOn`) and all six properties still hold. The brand's *identity* is its sealer/unsealer pair, not the string label.
- **"Visual inspection isn't a proof."** §3.4's closing argument is that scoping + sealing arguments are *sufficient* given the language-level enforcement of *only connectivity begets connectivity*. The proof is informal but rigorous: the inspector identifies the load-bearing scope boundaries, verifies the sealer/unsealer never escape, and concludes the properties hold. This is the *security-as-extreme-modularity* discipline (the 2026-05-21 library concept page) applied to this example.
