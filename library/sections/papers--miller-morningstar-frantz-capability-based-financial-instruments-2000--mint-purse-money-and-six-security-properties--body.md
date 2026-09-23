---
title: Body
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
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties
---

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
