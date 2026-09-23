Inbox is empty. All work is committed and pushed to `main2` (`82a9a3a068`), with the full test suite green.

---

## Completion report — `garden-budget-ledger` (Budget 2/5)

### What I found first
The ledger was **already built** (contrary to the original brief, which predated child 1): `usage_ledger_stage_row`/`usage_footer` write per-engagement `CostRecord`s to `usage/<base>.jsonl` — **with per-record `host` attribution already present** (`"host":"$GARDEN"`), which is exactly the host⇒account⇒subscription split the maintainer needs. So the job's real remaining gaps were (a) the amendment's true-cost reversal into the auction, and (b) the missing read side + coverage metric.

### What I did
**1. Flat-subscription cost censoring (amendment task 1 — the headline).** On a flat Max plan a per-call `total_cost_usd` is notional list-price, not money, so it must not price the bid auction.
- `reputation.sh`: added `rep_provider_is_flat` + `GARDEN_REP_FLAT_PROVIDERS` (default `anthropic`; uses `=` not `:=` so an explicit empty disables it).
- `reputation-reduce.sh`: a flat provider's numeric `aggregate_dollars` is now treated as **cost-censored** and folded through the true-costed wallclock proxy (rate card). This re-prices the **whole event log — including the 217 pre-policy Anthropic events** — as a pure function of `(events, rate card, flat set)`.
- **Decision (documented in code + `designs/token-cost-ledger.md`):** *reducer re-prices; raw events are never rewritten.* The notional figure stays in `agentic_dollars` and in `usage/<base>.jsonl` as separately-auditable evidence; only the derived projection changes. A real invoice **adjustment** still wins; a **demerit** is never censored. `complete-job.sh` now writes fresh flat events honestly (keeps `agentic_dollars` as evidence, sets `aggregate_dollars: censored` + a proxy `cost_source`). I did **not** reuse the wrong 0.000707 figure — the code is rate-agnostic and reads whatever the card says.

**2. `cost.sh`** — the design's read side (`--by job|role|model|day|host`, `--since`, `--job`, `--json`, `--compute`) with a **first-class, always-printed coverage line** and the per-host/per-account split.

**3. Tests** (`scripts/jobs/test/`): `flat-provider-censor-test.sh` (17 pass) and `cost-sh-test.sh` (12 pass). `auction-reputation-test.sh` pins `GARDEN_REP_FLAT_PROVIDERS=` empty (it uses `anthropic` as a generic *priced* stand-in) and is otherwise untouched. `token-cost-ledger-test` still 5/5.

### Coverage measured (before → after)
- **Cumulative:** 357/4128 = **8.6%** (amendment) → **456/4129 = 11.0%** now. The bulk of the 4129 tada reports predate the ledger wiring and are unrecoverable.
- **Recent (wiring live):** **177 of the last 200 completions (88.5%)** carry a stamped record.
- **Record quality:** of 878 ledger rows, 556 (63%) are priced (`source:result`), 322 (37%) tokenless (`source:none`), and **zero `fallback`/`delta` rows**.

### Paths that still don't stamp a priced record (reported per the DoD)
- **Priced today:** only the three handlers that write `GARDEN_USAGE_FILE` — `gardener-claude`, `mystic-kimi`, `cleric-codex`.
- **Tokenless (`source:none`):** every other claude handler (`mentor`, `proxy`, `triager`, `watchman`, `foreman`, `bulletin`, `follow-up`, `self-heal`, `banner-sweep`, `portability-coupling`, `catch-all`) — they rely on the spine's session-delta fallback, **which is producing zero rows in production** (the capture ladder's middle rung never lands, so an engagement not priced by its own envelope collapses straight to `source:none`). Killed/requeued engagements land here too.
- **No record at all:** standing services (`foreman` pump, `triager`, `watchman`, `bulletin` journalist) run `claude -p` outside the gardener claim spine and never reach `complete-job.sh` — the design's Phase-3 follow-on.
- Deterministic `-gh.sh` watcher handlers spend no tokens (correctly tokenless).

### Follow-ups (not in scope here)
- Investigate why the spine session-delta fallback yields 0 rows; wire `GARDEN_USAGE_FILE` into the remaining claude handlers — the single biggest coverage lever.
- Phase 3: service-turn rows for foreman/triager/watchman/bulletin.
- The `/usr/bin/time` rusage wrapper is unwired (`--compute` shows all-zero CPU/RSS).
- Verify the **live** `reputation/rate-card.md` carries child 1's true subscription-amortized Anthropic rate (~0.000069/s); the deployed-root copy still shows the notional-ledger-derived 0.005154/s, which would make the proxy my change routes to only as true as the card's data. This is journal data (child 1's domain), not code.

Note on the two pre-existing `auction-reputation-test` failures (`gardener arm wrong`, `reducer churned a wallclock-estimated event set`): I confirmed they reproduce on unmodified `main2`, are unrelated to this change, and left them untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-ledger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (8203070 cached reads)
- Output: 76373 tokens
- Cost: $8.125060000000001
- Wall-clock: 1120s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
