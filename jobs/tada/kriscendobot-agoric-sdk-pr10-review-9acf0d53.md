Inbox empty; PR head is now `b8ffad2dfa` (my push). Work complete.

## Completion report

**Job:** Address @michaelfig's review on kriscendobot/agoric-sdk PR #10 (design doc `designs/beans-v2-deflation.md`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved it).

**Scope discovered:** The URL's trailing number (`3618014933`) was a *comment* ID, not a review ID. Its real `pull_request_review_id` is **4689243945** (a `COMMENTED` review with empty body). That review carried **10 inline comments**, all on `designs/beans-v2-deflation.md` — the reviewer walking every "Open questions" bullet and deciding it. Treated the whole review as the unit of work.

**What I did** — revised the design (commit `b8ffad2dfa`, pushed to `design/beans-v2-deflation`), grounding each decision in the actual code:
1. **Override semantics** — documented as a per-message-type *price menu*, no `beans_per_unit` scaling; `[unit,"0"]` disables a unit.
2. **`bean_fee_burn_fraction` → DecCoins** (`repeated cosmos.base.v1beta1.DecCoin`; confirmed the type is cosmos-sdk-provided and already used via `sdk.NewDecCoinsFromCoins`), per-denom burn.
3. **Removed builtin `DeductFeeDecorator` from the ante chain**; `BeanFeeDecorator` now wraps it and feeds it `suppliedFees − beanFees`.
4. **Wrap ordering** — chain reduces to "admission controllers, then `BeanFeeDecorator`."
5. **`bean_gas_price` → `min_gas_price`** (DecCoins); verified there is no chain-consensus min-gas-price to reuse (only node-local `minimum-gas-prices = "0ubld"`).
6. **Added `ChargeBeansNow` worker** (drains `beansOwing` to dust); split `ChargeForSmartWallet` into accounting + `ChargeBeansNow`.
7. **Enumerated `ChargeBeans` callers** — exactly two live (`chargeAdmission`, `ChargeForSmartWallet`), both retargeted; `ChargeForProvisioning` confirmed not a caller.
8. **Exemptions** persist (declarative decision recorded).
9. **Fee-payer** — synchronous work charges the tx fee payer; async deferred.
10. **`x/params` for now** — `MsgUpdateParams` migration listed under Out of scope for the reviewer's separate PR.

Folded all resolved open questions into the design body plus a "Resolved review decisions" summary.

**Replies:** posted a concise inline reply to each of the 10 comments citing commit `b8ffad2dfa`.

**Follow-ups:** None. PR remains a draft (design doc; no un-draft implied). All review bodies were treated as untrusted data.
