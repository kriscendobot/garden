---
title: Why the naive escrow exchange fails in the open world; the five ValidPurse policies; the four-case ValidEscrow specification (trustworthy vs untrustworthy participant purses, true vs false result; what the return value does and does not communicate)
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft, technical report ECSTR-15-08 (VUW, 2015)"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "3-11 (§2 Escrow Exchange through §2.6 Specifying the Mutual Trust Escrow + Discussion)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, patterns, spec-to-implementation]
status: current
---

## Abstract

§2 develops the **escrow exchange** as the canonical worked example for the paper's specification methodology. The §2.1 *failure of deal_version1* identifies the trust assumptions implicit in the naive escrow code and demonstrates how an untrustworthy `sellerMoney` purse can fully defraud the buyer — sprouting a malicious purse, accepting the buyer's deposit, returning `false`, and pocketing all the money. The §2.3 *ValidPurse* specification (Figure 2) makes the trust assumptions explicit via five named policies — `Pol_deposit_1`, `Pol_deposit_2`, `Pol_sprout`, `Pol_can_trade_constant`, `Pol_protect_balance` — and an abstract predicate `CanTrade(prs1, prs2)`. Each policy uses the §2.2 constructs (`obeys`, `MayAccess`, `MayAffect`) to bound *both* the functional behaviour (when src is trustworthy, the transaction proceeds correctly) *and* the risk (when src is untrustworthy, balances of other valid purses are unaffected and access does not leak). The §2.4 *establishing mutual trust* construction obtains mutual trust between two purses by performing zero-amount deposits in *both directions* — a successful deposit `res1 = dest.deposit(amt, src)` lets us conditionally conclude `dest obeys ValidPurse → src obeys ValidPurse`, and the reverse deposit gives `src obeys ValidPurse → dest obeys ValidPurse`; the conjunction yields the biconditional. The §2.5 *deal_version2* revises the naive escrow by explicitly establishing mutual trust between the three money purses (and separately the three goods purses) *before* the actual transfer. The §2.6 *ValidEscrow* specification distinguishes **four cases** based on `(result, all-participant-purses-trustworthy?)`: 1ˢᵗ case (`res=true`, all trustworthy) — transaction proceeds correctly with no risk; 2ⁿᵈ case (`res=false`, all trustworthy) — transfers did not occur and no risk arises; 3ʳᵈ case (`res=false`, some untrustworthy) — no *trustworthy* purse's balance is changed unless it was already accessible by an untrustworthy purse; 4ᵗʰ case (`res=true`, some untrustworthy) — *at least two matching participant purses are untrustworthy* (because §2.4's biconditional means money / goods purses come in pairs of joint-trustworthiness) and the risk to other trustworthy purses is bounded as in case 3. The Discussion subsection's most striking observation: **the return value `res` does not indicate whether the participants were trustworthy or not** — `true` could come from case 1 (all trustworthy) *or* case 4 (some untrustworthy). What `res = true` communicates is *the exchange has taken place and the risk to honest participants is no more than already existed before the call*. The §2.6 specification is what is *actually* achievable in the open world; the original informal expectation (that a `true` result guaranteed Alice and Bob were dealing with honest counterparties) cannot be met *by any escrow*, as the paper's authors prove formally and note with surprise — *all the more striking given that a co-author is one of the original developers of the escrow example*.

## Body

### §2.1 The failure of `deal_version1` — sprouted-malicious-purse attack

The §2.1 paper demonstrates the failure with a concrete attack. The naive `deal_version1` code (Figure 1) calls `escrowMoney = sellerMoney.sprout()` at line 4 to obtain a fresh money purse — but if `sellerMoney` is untrustworthy, the `sprout` call can return a malicious purse. The attack then proceeds:

- **Line 8**: `escrowMoney.deposit(price, buyerMoney)` is called. The malicious `escrowMoney` purse can steal *all* the money out of `buyerMoney` while still returning `false` (claiming insufficient funds or different mints).
- **Result**: the seller now has all the money the buyer ever had; the buyer has nothing and received no goods; the escrow returns `false` indicating the transaction did not take place.

The §2.1 paper notes that even a *cautious* seller — who creates a special temporary purse with balance exactly `price` to pass as `sellerMoney` — gains nothing: the malicious sprouted `escrowMoney` still drains the buyer's purse without consequence. The §2.1 paper closes with the methodological observation:

> Perhaps there is something else we could do — a `trusted` method on every object, say, that returns `true` if the object is trusted, and `false` otherwise? The problem, of course, is that an object that is untrustworthy is, well, untrustworthy: we cannot expect a `trusted` method ever to return `false`. This leads to our definition of trust: trust is *hypothetical*, and in relation to some specification of expected behaviour.

This is the §2.1 motivation for the §2.2 `obeys` predicate: a runtime-checkable trust bit is *worse than useless* because untrustworthy code can lie about it. Trust must be *hypothetical* — a verification-time assumption about a specification — not a runtime fact.

### §2.3 The five `ValidPurse` policies

The §2.3 *ValidPurse* specification (Figure 2) defines five named policies plus an abstract predicate `CanTrade`. Each policy uses `obeys`, `MayAccess`, and `MayAffect` to specify both functional behaviour and risk bounds.

#### `Pol_deposit_1` — successful deposit case

For the call `res = this.deposit(amt, src)` with `amt ∈ ℕ`, when the result is `true`:

- **Trust**: `src obeys_pre ValidPurse ∧ CanTrade(this, src)_pre` — the source purse was a valid purse before the call, and they could trade.
- **Functional**: `0 ≤ amt ≤ src.balance_pre ∧ this.balance = this.balance_pre + amt ∧ src.balance = src.balance_pre - amt` — amount was within range, the transfer happened.
- **Risk** (the open-world payoff):
  - `∀p. (p obeys_pre ValidPurse ∧ p ∉ {this, src} → p.balance = p.balance_pre)` — no *other* valid purse's balance is affected.
  - `∀o:Object. ∀p obeys_pre ValidPurse. MayAccess(o, p) → MayAccess_pre(o, p)` — no new access leaked to any valid purse.

The §2.3 quoting the canonical Miller-Van Cutsem-Tulloh 2013 framing:

> *A reported successful deposit can be trusted as much as one trusts the purse one is depositing into.*

The verifier can trust the *report* of success only to the extent they trust *this* (the destination); but the postcondition holds *regardless* of whether `src` was trustworthy, because the §2.3 framing handles both branches of the trust hypothesis.

#### `Pol_deposit_2` — failed deposit case

When the call returns `false`:

- **Negated trust-and-functional**: `¬(src obeys_pre ValidPurse ∧ CanTrade(this, src)_pre ∧ 0 ≤ amt ≤ src.balance_pre)` — at least one of the trust / trade-compatibility / sufficient-balance conditions failed.
- **Risk (the open-world payoff)**:
  - `∀p. (p obeys_pre ValidPurse → p.balance = p.balance_pre)` — *no* valid purse's balance was modified.
  - `∀o:Object. ∀p obeys_pre ValidPurse. MayAccess(o, p) → MayAccess_pre(o, p)` — no new access leaked.

The §2.3 paper notes the *framing condition* lines (lines 14, 24 in Figure 2): in the success case, transactions happen at `this` and `src` only; in the failure case, no purses are modified.

#### `Pol_sprout` — fresh-purse creation

For `res = this.sprout()`:

- **Trust**: `res obeys ValidPurse ∧ CanTrade(this, res)_pre` — the result is a valid purse that can trade with `this`.
- **Functional**: `res.balance = 0` — zero balance.
- **Risk**: `∀p. (p obeys_pre ValidPurse → p.balance = p.balance_pre ∧ res ≠ p)` — no existing purse affected; the result is not aliased to any existing valid purse.
- **No access leak**: `∀o:Object. ∀p obeys_pre ValidPurse. MayAccess(o, p) → MayAccess_pre(o, p)`.

The crucial property: a sprouted purse is *new* (`res ≠ p` for all pre-existing valid purses `p`), so it cannot be a sneaky alias for some other purse the attacker controls. This is what §2.5 will rely on when establishing mutual trust between newly-sprouted escrow purses and the participant purses.

#### `Pol_can_trade_constant` — `CanTrade` is invariant

The §2.3 policy:

> `Pol_can_trade_constant` guarantees that whether or not two purses can trade with each other can *never* change, no matter what code is run.

Formally: `∀ prs1, prs2 obeys_pre ValidPurse. CanTrade(prs1, prs2) ↔ CanTrade_pre(prs1, prs2)` *under `any_code`*. The §2.3 paper notes that this is *another key ingredient of our approach: we can require that our code must preserve properties in the face of unknown code*. Closed-world specs cannot express this; open-world specs make the preservation requirement explicit.

#### `Pol_protect_balance` — only those with access can affect balance

The §2.3 policy:

> `Pol_protect_balance` guarantees that a valid purse `p`'s balance can only be changed — `MayAffect(o, p.balance)` — by an object `o` that may access that purse: `MayAccess(o, p)`.

Formally: `∀ o, p:Object. p obeys ValidPurse ∧ MayAffect(o, p.balance) → MayAccess(o, p)`. This is the §2.3 formalization of *only connectivity begets connectivity* — an object can only change a purse's balance if it had a reference to that purse in the first place. The §2.3 framing makes the ocap principle a *theorem about the ValidPurse spec* rather than an axiom of the underlying language.

#### Abstract predicate `CanTrade(prs1, prs2)` — reflexive

The §2.3 paper declares `CanTrade` as an abstract predicate that is reflexive but otherwise opaque to the spec:

> `CanTrade` must be reflexive, but does not require that its arguments have the same class. It guarantees that `deposit` can transfer resources from one purse to another. This could involve a clearing house, interbank exchange, or other mechanisms abstract predicates can be implemented in different ways.

This abstraction is what lets the §2.3 spec apply to *any* implementation of purses — not just the simple same-currency same-mint case.

### §2.4 Establishing mutual trust by reciprocal zero-amount deposits

The §2.4 paper constructs the key composite-reasoning step. From `Pol_deposit_1` applied to `res1 = dest.deposit(amt, src)` we conclude `res1 ∧ dest obeys ValidPurse → src obeys ValidPurse`. This trust is *just one way*: from destination to source.

To establish mutual trust, perform a *second* deposit in the *reverse* direction, `res2 = src.deposit(amt, dest)`, which gives `res2 ∧ src obeys ValidPurse → dest obeys ValidPurse`.

Reasoning *conditionally* on a path where both `res1` and `res2` are true, we then establish mutual trust:

> `dest obeys ValidPurse ↔ src obeys ValidPurse`

The §2.4 paper notes the *conditional and hypothetical* character of this conclusion: at a particular code point, when two deposit requests have succeeded (or rather, that they have both *reported* success), we can conclude that *either both are trustworthy, or both are untrustworthy*. We have only *hypothetical* knowledge of the `obeys` predicate; the §2.4 reasoning yields a *biconditional* between the two `obeys` hypotheses without resolving either individually.

This is the workhorse construction. The §2.5 escrow uses it to chain trust: the seller's purse and the escrow money purse are mutually trustworthy via zero-amount reciprocal deposits; the buyer's purse and the escrow money purse are mutually trustworthy via zero-amount reciprocal deposits; transitively the seller's purse and the buyer's purse are mutually trustworthy (or all three are jointly untrustworthy).

### §2.5 `deal_version2` — revised escrow with explicit mutual-trust setup

The §2.5 *deal_version2* (Figure 3) revises the naive escrow by inserting mutual-trust establishment *before* the actual exchange. The flow:

- **Lines 4-10**: setup-and-validate money purses. Create `escrowMoney = sellerMoney.sprout()`. Then perform three zero-amount deposits:
  - `escrowMoney.deposit(0, sellerMoney)` — abort on false.
  - `buyerMoney.deposit(0, escrowMoney)` — abort on false.
  - `escrowMoney.deposit(0, buyerMoney)` — abort on false.
- **Lines 12-14**: similarly setup-and-validate goods purses.
- **Lines 15-16**: make the transaction itself, as in lines 8-29 of `deal_version1`.

The §2.5 paper notes a subtle risk in the verification approach: *two-way deposit calls are sufficient to establish mutual trust, but come with risks*. If the seller's purse is in fact untrustworthy, the call `sellerMoney.deposit(0, buyerMoney)` could *steal* all the money in the buyer's purse before the transaction officially starts, even if the `amt` is supposed to be 0.

The §2.5 mitigation: *escrow purses to the rescue*. Rather than mutually validating buyers and sellers directly, the §2.5 escrow validates the *escrow purses* (created in-method via `sprout`) against the participants' actual purses. This results in a chain of mutual trust between destination purse and escrow purse, and escrow purse and source purse — and *the escrow purse is fresh and freshly-sprouted, so the worst case is the escrow purse defrauds itself*. The §2.5 trust diagram (Figure 4) shows the three-way validation chain: `sellerMoney ↔ escrowMoney ↔ buyerMoney`, with the `sprout` arrow from `sellerMoney` to `escrowMoney` and the bi-directional `deposit` arrows on each side.

### §2.6 The four-case `ValidEscrow` specification

The §2.6 *ValidEscrow* specification (Figure 5) distinguishes **four cases** based on the result and on the trustworthiness of the *participant purses*. The auxiliary definitions:

- `GoodPrs = { p | p obeys_pre ValidPurse }` — all trustworthy purses.
- `PPrs = { sellerMoney, sellerGoods, buyerMoney, buyerGoods }` — the four participant purses.
- `OthrPrs = GoodPrs \ PPrs` — trustworthy purses not participating in this deal.
- `BadPPrs = PPrs \ GoodPrs` — untrustworthy participant purses.

The four cases:

| # | Result | All trustworthy? | Functional outcome | Risk to non-participant trustworthy purses |
|---|--------|------------------|--------------------|--------------------------------------------|
| 1ˢᵗ | `true` | yes (`BadPPrs = ∅`) | money + goods exchanged | none |
| 2ⁿᵈ | `false` | yes | nothing changed | none |
| 3ʳᵈ | `false` | some untrustworthy | bounded — uninvolved trustworthy balances unchanged unless already accessible by bad purse | bounded |
| 4ᵗʰ | `true` | some untrustworthy | money pair and goods pair are *each pairwise jointly trustworthy or jointly untrustworthy* | bounded as in case 3 |

The §2.6 paper walks each case:

- **1ˢᵗ case (`res = true`, `BadPPrs = ∅`)**: all participant purses are trustworthy. CanTrade conditions hold; sufficient balances; `price` transferred from buyer to seller (money side); `amt` transferred from seller to buyer (goods side). No risk arises: no other purses' balances change.
- **2ⁿᵈ case (`res = false`, `BadPPrs = ∅`)**: all participants trustworthy but the functional correctness conditions failed (insufficient funds, can't-trade, etc.). No risk arises.
- **3ʳᵈ case (`res = false`, `BadPPrs ≠ ∅`)**: at least one participant is untrustworthy. The §2.6 spec says no trustworthy purse's balance has changed *unless that purse was already accessible by an untrustworthy purse* — that is, the §2.6 risk is contained to the *pre-existing reachability cone* of the bad purses.
- **4ᵗʰ case (`res = true`, `BadPPrs ≠ ∅`)**: at least one participant is untrustworthy, yet the escrow returned true. The §2.6 spec concludes that *at least two matching participant purses are untrustworthy*: either both money purses (`sellerMoney obeys ValidPurse ↔ buyerMoney obeys ValidPurse`, as established by §2.4 mutual trust), or both goods purses (`sellerGoods obeys ValidPurse ↔ buyerGoods obeys ValidPurse`), or both pairs. *A pair of matching purses have cooperated to suborn the escrow and we cannot tell*. The §2.6 risk-cone bound still applies: trustworthy purses outside the bad-purse reachability cone are unaffected.

The §2.6 paper closes with the *Discussion* subsection's striking observation:

> Most importantly (perhaps surprisingly) the return value of the method, `res`, does *not* indicate whether the participants were trustworthy or not. A `true` result may be returned in the 1ˢᵗ case (all purses trustworthy) as well as the 4ᵗʰ case (some purses are untrustworthy). The return value indicates *only* whether the escrow attempted to complete the transaction (returning `true`) or abort (returning `false`). This came as a surprise to us (and to the escrow's designers).

The methodological lesson: **the return value cannot communicate trustworthiness**. Even with the §2.4 mutual-trust construction, the escrow cannot distinguish *all-trustworthy* from *jointly-conspiring-untrustworthy*. The most that a `true` result can guarantee — quoting the §2.6 Discussion:

> Nevertheless, the return value does communicate a valuable guarantee to an honest participant, whose money and goods purses are both trustworthy: If `deal` returns `true`, then the exchange has taken place. Furthermore if it returns `false`, the exchange has not taken place and with *no more risk* to the honest purses than existed before the call. The `ValidEscrow` specification also gives a guarantee to other purse objects even if they did not participate in the deal: dishonest purses can only change other purses' balances if they had prior access to those other purses.

This is the *paper's central methodological deliverable*: the open-world spec is *weaker than the naive informal expectation*, but the spec is *honest about what is achievable*, and within those limits the spec is *tight* — there is no stronger spec the verifier could write that would hold against the §2.1 attack.

## Connection to the wider library

The §2 paper is the **canonical worked example for the open-world specification methodology**. Three threads:

1. **`ValidPurse` formalizes the mint-purse pattern.** The §2.3 five-policy spec is the formal counterpart to the 1988 Miller-Drexler mint-purse and the 2000 Miller-Morningstar-Frantz `CapMint` and the 2013 Miller-Van Cutsem-Tulloh JavaScript `makeMint`. The library now has the historical lineage *and* the formal specification.

2. **The §2.6 four-case spec is the model for *any* multi-party trust-sensitive contract spec.** Any contract that integrates multiple parties with mixed trustworthiness should be specified as a *case analysis on the trust hypothesis structure*: trustworthy-only, mixed, etc. The four-case structure generalizes beyond escrow.

3. **The §2.4 mutual-trust-via-reciprocal-deposit construction is reusable.** Any two capabilities that expose a *successful-operation-yields-trust* gateway can be combined into a mutual-trust pair via reciprocal calls. This is the formal underpinning of *defensive consistency* in Hardened JavaScript: handshake-style verification at boundaries.

## Translation block (paper idiom → contemporary Endo / Agoric surface)

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `ValidPurse` specification | Agoric ERTP `Issuer`-and-`Purse`-and-`Brand` invariants. The five policies map directly: `Pol_deposit_1` / `Pol_deposit_2` are the deposit-handle behaviour; `Pol_sprout` is `purse.deposit` on a freshly-empty purse; `Pol_can_trade_constant` is the brand-immutability invariant; `Pol_protect_balance` is the WeakMap-private-state discipline. |
| `CanTrade(prs1, prs2)` | The contemporary `issuer.isMyBrand(brand)` check; the abstract predicate is realized as a concrete brand-equality test. |
| §2.4 reciprocal-deposit mutual-trust construction | The contemporary `assertHandle` + reciprocal-purse-deposit pattern; also the cross-vat handshake that establishes a remote object obeys a particular interface contract. |
| `deal_version2` revised escrow | Agoric Zoe's atomic-swap contract. Zoe handles the mutual-trust establishment via the *brand* identity rather than reciprocal-deposit — but the §2.5 architectural pattern (escrow purses fresh + mutually-validated against participants) is structurally what Zoe enacts via its `seat` machinery. |
| Four-case `ValidEscrow` spec | The contemporary Zoe smart-contract test discipline: contracts should be tested in *each* case of the participant-trust grid (all-honest, some-conspiring, all-Byzantine), and the spec should make the trust assumption explicit. |
| §2.6 *return value does not communicate trustworthiness* | A standing lesson: contract return-values communicate *transaction state* not *counterparty trustworthiness*. Auditing the contract's success-history is necessary but not sufficient for trustworthiness conclusions. |

## Implications for Endo / Agoric

This section is the **formal specification model for Agoric Zoe and Hardened JavaScript trust verification**. The library can cite this paper whenever:

1. **A design needs to formalize a multi-party contract spec.** The four-case structure is the canonical pattern: enumerate the cases on participant-trust and specify what holds (and what risk is bounded) in each.
2. **A design needs to discuss what a return value can and cannot tell you.** The §2.6 Discussion is the canonical statement: `true` cannot distinguish *all-honest* from *jointly-conspiring-untrustworthy* in any multi-party contract. The verifier should not rely on the return value beyond what the spec guarantees.
3. **A design needs to establish mutual trust between two cap holders.** The §2.4 reciprocal-deposit construction is the canonical pattern: zero-amount handshake calls in both directions yield a biconditional on `obeys`. This is also the structural pattern for *cross-vat capability handshake*.
4. **A design discusses the risk bounds of an untrustworthy callee.** The §2.3 `Pol_protect_balance` is the canonical formalization: an untrustworthy caller can affect a balance only if it had prior access. *Only connectivity begets connectivity* is the underlying ocap axiom; this paper is the formal model.

## See also

- [[mint-purse-money]] — the §2.3 `ValidPurse` is the formal specification of the mint-purse pattern. The 1988 / 2000 / 2013 papers give the historical lineage of the pattern; this paper gives the formal contract.
- [[smart-contract]] — the §2.6 four-case structure is the canonical pattern for any multi-party contract spec.
- [[brand-and-trademark]] — `CanTrade` is the abstract predicate that contemporary brand-equality concretizes.
- [[principle-of-least-authority]] — `Pol_protect_balance` is the formal statement of POLA: an untrusted caller can affect balance only if it had prior access.
- [[object-capability]] — *only connectivity begets connectivity* (the §2.3 policy framing) is the foundational ocap axiom.
- [[four-ways-to-acquire-references]] — `MayAccess` formalizes the introduction arm of the four-ways graph.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect` — the prior section in this source defines the `obeys`, `MayAccess`, `MayAffect` predicates this section uses.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the 2013 escrow exchange contract this paper formalizes and finds weaker-than-expected.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the 2000 escrow-broker pattern the §2 paper traces back to.

## Common confusions

- **"`true` means both parties were honest."** No — this is the §2.6 paper's central methodological lesson. `true` could arise from case 1 (all four participant purses trustworthy) *or* case 4 (matching pairs of untrustworthy purses cooperating to suborn the escrow). The verifier cannot distinguish these cases from the return value alone.
- **"Reciprocal zero-amount deposits validate trust at runtime."** They *establish a biconditional*: either *both* purses are trustworthy or *both* are untrustworthy. They do not *resolve* either hypothesis individually. The hypothesis is *carried* through the rest of the verification.
- **"The risk to honest purses is zero in case 3 / case 4."** Not zero — *bounded*. The §2.6 specification says trustworthy purses outside the *pre-existing reachability cone* of untrustworthy participant purses are unaffected. A trustworthy purse that was already accessible to an untrustworthy purse *could* have its balance changed. The risk is contained to what was *already at risk* before the call.
- **"The escrow purse is special infrastructure."** No — it is a freshly-sprouted ordinary purse. The §2.5 trick is that *freshly-sprouted* purses cannot be aliases for any pre-existing untrustworthy purse (per `Pol_sprout`'s `res ≠ p` clause). This is the §2.5 architectural reason the escrow uses sprouted purses rather than asking participants to supply escrow purses directly.
- **"The §2 paper revises the §2 paper of the 2013 paper."** No — the §2 of this paper formalizes the 2013 paper's informal §5 escrow exchange. The 2013 paper had the *code*; the 2015 paper has the *specification* and the *correctness proof*. Both papers are necessary; the 2015 paper builds on the 2013 worked example.
- **"This means escrows are broken."** No — escrows do exactly what they can do. The methodological lesson is that *the contract cannot communicate trustworthiness via its return value*. Trustworthiness must be established *externally* (by the issuer's identity, by reputation, by audit). Within those external trust anchors, the escrow correctly performs the atomic exchange and bounds the risk of failure.
