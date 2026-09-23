All helpers exist and are wired. The job is fully complete. Here is my completion report.

---

## Completion report: `fix-live-budget-admission-enforcement`

**Status: already done by a prior claimant — verified complete, nothing to redo.**

I re-derived state from committed history and the journal. The prior attempt landed and pushed everything as commit **`d0a5a5e908` "feat(budget): enforce live pool admission"**, which *is* the current `origin/main2` HEAD. My fresh worktree is clean and aligned (`HEAD == origin/main2`). All six design §8 pieces are present, wired, and passing tests:

1. **Meter on** — `budget-pools-placeholder.tsv` seeds the two Anthropic accounts (`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`) at a **`5000000` weekly-token placeholder cap each, explicitly flagged NOT CALIBRATED** pending a `/usage`-derived figure. It's also seeded into the live journal at `config/budget-pools` (journal entry `1822bd609c`). Window anchored to Friday 21:00 Pacific (`GARDEN_TOKEN_RESET_DOW=5`, `RESET_HHMM=21:00`, DST-aware `meter_week_anchor_epoch`).
2. **`pool_admits <pool>`** — in `usage-meter.sh`, generalizing `meter_quota_status` to a pool arg, `off/unknown/ok/backoff` verdict, 0.85 high-water, **fail-open** preserved.
3. **Claim gate** — `claim-job.sh:147` declines-and-backs-off on confirmed `backoff`, warns (doesn't block) on `unknown`.
4. **Direct-post routing** — `post-job.sh` routes to `plan/ --budget-hold` at fleet `backoff`.
5. **Promotion gate** — `foreman.sh` halts deferred-plan promotion/pump when every pool is at high water.
6. **`budget-level.sh`** — leader-only no-LLM leveler, run as a **scheduler preflight** (`scheduler.sh:349`); plus `budget-refresh.sh` + leader-gated `garden-budget-refresh.{service,timer}` to return budget-held plans at the anchor.

**Verification:** the test suite `scripts/jobs/test/live-budget-admission-test.sh` passes **7/7** (anchor backoff, fail-open on unreadable meter, post routing, scaler publisher, claim decline, foreman halt, leveler raise/lower with floor 1). Systemd units auto-discover via the `garden-*.timer` glob in `install-units.sh`; leader-only gating is via `ExecCondition=is-main-host.sh`.

**Drift note:** no reconciliation needed — the design snapshot matched reality; the recent budget-adjacent work (`budgeted-campaign-dispatch`, `recurring-budget-calibration`, `garden-budget-attribution`) is complementary and did not pre-cover any of these six pieces. The meter is already live in production (journal shows real `budget-live(endolin-garden-ece02cb4) backoff` entries).

**Follow-up (unchanged from build):** the `5000000` weekly cap is a placeholder; a maintainer `/usage`-derived per-account figure should replace it in `config/budget-pools`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-live-budget-admission-enforcement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (721313 cached reads)
- Output: 6510 tokens
- Cost: $0.9420235
- Wall-clock: 100s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
