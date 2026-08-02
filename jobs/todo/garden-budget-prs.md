---
role: assayer
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-02T21:55:49Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Budget 3/5 — aggregate session cost up to merged pull requests

Third child of orchestration `garden-budget-attribution`. Runs after
`garden-budget-ledger` and **depends on its output** — read that job's `tada/`
report first. If the ledger did not land, or landed with coverage too low to
aggregate meaningfully, say so and stop rather than producing a number you cannot
defend.

## Goal

Roll per-session cost up to the **merged pull request** — the maintainer calls
this the *Gimix escrow oracle*: the unit of delivered value the garden should be
able to price.

## The join is the hard part — do not regex the prose

A liaison sampled 600 `jobs/tada/*.md` reports and found only **16%** cite a PR
URL anywhere in their body (95 reports, 111 distinct PRs). Report prose is not a
reliable join key. Build a real one. Candidate spine, in rough order of
reliability:

- job base → per-job worktree (`scripts/jobs/ensure-project-worktree.sh`, keyed
  by job base) → branch → PR
- the job body's `pr:` frontmatter and the gauntlet stage fields
  (`gauntlet`, `gauntlet_stage`, `pr:`) — present on staged jobs
- `journal/pr-mirrors/` and `journal/panel-runs/` — both already key by PR
- the comment/CI watchers' directive identity (`jobs/index/<hash>`), which maps a
  GitHub comment to the job it minted

Measure and report join coverage. A PR whose cost is assembled from 3 of its 9
contributing jobs must be labelled as such, not published as the PR's cost.

## Also

Many jobs legitimately map to **no** PR (scholar cycles, presses, watchdogs,
garden-internal builds). Those are real cost against the same budget. Decide how
they are represented — an "unattributed" bucket is acceptable and honest; silently
dropping them is not, because the per-PR figures would then understate the true
cost of running the garden.

## Definition of done

A deterministic job→PR join with a measured coverage figure; per-merged-PR cost
aggregation on the true-cost basis from child 1; an explicit unattributed bucket;
a `tada/` report showing the top PRs by cost and stating join coverage plainly.


---

## AMENDED 2026-08-02 by the liaison — children 1 and 2 have landed

Read `jobs/tada/garden-budget-ratecard.md` and `jobs/tada/garden-budget-ledger.md`
before you start. What they changed for you:

### You now have a read side — use it, don't rebuild it

Child 2 built **`scripts/jobs/cost.sh`** with `--by job|role|model|day|host`,
`--since`, `--job`, `--json`, and an always-printed coverage line. Aggregate
through it rather than re-parsing `usage/*.jsonl` yourself. Per-record `host`
attribution was already present, so the per-account split is available.

### Coverage is better than the original brief said, and still the limiting factor

- cumulative **456/4129 = 11.0%** (was 8.6%)
- **recent 177 of the last 200 completions = 88.5%** — the wiring works now; the
  gap is historical and unrecoverable

**This bounds your whole result.** Merged PRs older than the ledger wiring cannot
be costed from records that were never written. Say so per-PR rather than
publishing a number assembled from a fraction of its contributing jobs. A PR
costed from 3 of its 9 jobs must be labelled, not averaged.

Also inherited: only three handlers (`gardener-claude`, `mystic-kimi`,
`cleric-codex`) write priced records; the spine's session-delta fallback is
producing **zero** rows in production, and standing services (foreman, triager,
watchman, bulletin) never reach `complete-job.sh` at all. Those are known and
out of your scope — but they mean "unattributed" is a real bucket, not a rounding
error, and it must appear in your output.

### Costs are now true, not notional

The rate card is on one true basis (anthropic pooled **0.000069 $/s**, kimi
0.001338, fireworks 0.000509) and child 2 made the reducer treat a flat-provider
`total_cost_usd` as censored, so the whole event log re-prices through it.
Verified live by the liaison: the reducer resolves anthropic → 0.000069.

**Do not use `total_cost_usd` from `usage/*.jsonl` as money.** On a flat $400/mo
subscription it is notional list price and overstates ~8.7x. If you need per-job
cost, take it from the reducer's projection or from `cost.sh`, not the raw field.

### One check worth making while you are in here

The **tracked seed** `scripts/jobs/rate-card-defaults.md` on `main2` still
carries the old notional per-model Anthropic rows (0.005139 / 0.007661 / 0.005003,
dated 2026-07-29). It is fallback-only — the live journal card wins and resolves
correctly today — so this is latent, not active. But a fresh instance with no
journal card, or a lost card, would silently price Anthropic ~75x too high. If it
is cheap to correct while you are working, do it and say so; if not, leave it and
report it. Do not let it expand your scope.
