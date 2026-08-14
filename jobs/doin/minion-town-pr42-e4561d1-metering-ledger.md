---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree `worktrees/kriscendobot-minion.town`). Design `designs/weblet-usage-metering.md` merged to main via https://github.com/kriscendobot/minion.town/pull/42 (head e4561d1), with the § 10 policy questions decided by the maintainer in review https://github.com/kriscendobot/minion.town/pull/42#pullrequestreview-4932690275.
Role: builder. Build **only increment 1 of § 8 Integration and build sequence** — the provider-neutral resource-ledger core: account and subaccount records (`CreditAccountRecord` per § 2), reserve/settle/refund operations (§ 4), double-entry billing events written in the same transaction as every balance mutation, and the statistics projection interface (§ 5) as a pure projection of that event history. Implement in memory first, then a DynamoDB adapter, reusing the existing `iss`+`sub` account root and billing event ids. **No live pricing and no debit path**: no changes to `makeStubPaymentProcessor`, no gateway or daemon wiring, publish stays priced at `0n`.
Tests: carry the § 9 items that apply to this increment — property tests over issuance/transfer/reservation/settlement/refund in arbitrary retry order proving conservation and no negative ordinary account; crash-point tests around each DynamoDB boundary proving one receipt and one net balance effect; concurrent race for the last credits proving at most one reservation succeeds and duplicate measures return the same receipt; statistics rebuilt from events and compared byte-for-byte including late settlement and price-version/annotation changes.
Out of scope (do not start, and do not stub in ways that presume their shape): § 8 increments 3–6. Increment 3 (gateway traffic/storage), 4 (daemon compute), 5 (ERTP receiver), and 6 (statistics UI/subscriptions) either depend on upstream Endo work still open — endojs/endo-but-for-bots#982 (worker-name override), #983 (live reference retention root), #984 (durable-ledger worker), #637 (AWS storage platform) — or on decisions § 10 leaves open (launch dimension set, minimum billable quantum, rounding rule, grant size/rollover). Note in the PR description which § 10 open sub-questions the ledger's schema leaves free rather than resolving them unilaterally.
Follow-up (do not post now; it belongs after this lands): § 8 increment 2, replacing `makeStubPaymentProcessor` with the operator adapter for the already-wired `PublishMeasure` at a configurable zero schedule.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T06:01:38Z
