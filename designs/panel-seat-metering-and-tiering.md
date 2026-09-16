# Panel-seat metering and per-seat tiering

Status: landed (2026-09-16). Child 4 of orchestration `credit-controls-20260916`
(authorized by kriskowal via liaison muster 2026-09-16). Source investigation:
`mentat-endolin-garden2-credit-investigation-20260905`.

Two coupled changes that close the largest remaining hole the credit
investigation found and cut the panel's per-review cost without demoting review
quality uniformly.

## The problem

The gardening review **panel** (`scripts/jobs/gardening/panel.sh`) is the garden's
single largest concentration of autonomous spend: a code panel fans **~30 juror
seats**, each a subprocess `claude -p`, plus a decider (foreperson) and an
appellate call — ~32 `claude -p` invocations per panel round, and a gauntlet can
run several rounds.

### (a) The metering hole

Every one of those `claude -p` calls is a **nested subprocess** of the supervising
gardener's own top-level `claude -p`. The handler that measures a job's cost
(`scripts/jobs/handlers/monk-claude.sh`) captures Claude's **terminal usage
envelope** (`claude -p --output-format json`, field `.usage`) — but that envelope
accounts for **only the top-level session**. It structurally cannot see the tokens
a nested `claude -p` burned: those are separate API sessions, billed separately,
recorded in separate session-log files.

So the per-job cost ledger (`usage/<base>.jsonl` on `journal2`) recorded ~1 of the
~32 sessions a panel job actually spent. The investigation measured the ledger at
**~15–21% of the host meter-measured billable tokens** for such jobs (true spend
plausibly 2–5× recorded).

Note the weekly-quota gate (`meter_quota_status` → `_meter_session_total`) was
**already** complete for the *local* host: it sums **all** of `~/.claude/projects`,
which includes the nested seat sessions. The hole was in the **per-job ledger** —
which feeds per-PR cost attribution (`cost-by-pr.sh`), campaign spend, reputation
`agentic_dollars`, the **cross-host** journal fallback the leader reads for a
*remote* host's pool (`meter_journal_host_tokens`, which reads `usage/*.jsonl`),
and every human-facing "recorded spend" figure. Those all saw a fraction of truth.

### (b) Everything on Opus

Every seat ran at the fleet's automatic Anthropic ceiling model
(`claude-opus-4-8`). A 30-seat Opus fan-out per round is the panel's cost
multiplier, and most seats' judgments do not need Opus.

## (a) The fix: measure the complete session delta in the handler

The only durable trace of a nested `claude -p` is its **session log**. The fix
measures the handler's **complete session-log delta** over the job's own worktree
session dirs — which captures the top-level session **and** every nested seat
session, since all of them write there — and records that when it materially
exceeds the top-level envelope.

Where the measurement happens matters:

- **In the handler (`monk-claude.sh`), not the agent.** The agent's `claude -p`
  runs with `GARDEN_USAGE_FILE` deliberately unset (an agent must not author or
  erase its own cost record), so a panel-side accumulator cannot reach the ledger.
  The handler is the parent process; it snapshots `meter_job_session_usage` before
  and after the top-level call and owns the record.
- **Before teardown.** `monk-claude.sh` removes the top-level session transcript on
  completion; the snapshot is taken *before* that removal, so the top-level tokens
  are still counted. The before/after **delta** (not a cumulative sum) also makes
  the measurement correct across a resume — prior runs' stale sessions sit in the
  before-snapshot and fall out of the delta.

`augment_usage_with_session_delta` (`usage-meter.sh`) rewrites the usage handoff
from the delta when `billable(delta) > billable(envelope) × 1.05`, preserving the
envelope's `model` / `num_turns` / rusage and dropping `total_cost_usd` (nested
seats span multiple models and cannot be priced from one envelope; the row is
honestly marked `source: session-augmented` and reads as unpriced). A plain job
(no nested `claude -p`) has `delta ≈ envelope`, so the envelope — with its exact
provider dollars — is left untouched.

For the delta to see the seats, panel seats must write into a job session dir.
`panel.sh` now runs every seat / decider / appellate `claude -p` from `cd "$wt"`
(the reviewed worktree, which is this job's own base-keyed worktree) — the idiom
the cost-gated seat-gates already used. This also strictly improves seat
correctness: a bare `gh pr view $pr` now resolves against the repo under review,
not an ambient repo.

**How much closer the ledger gets.** For a gauntlet/panel job the per-job ledger
goes from counting ~1 of ~32 `claude -p` sessions to counting all of them —
closing essentially the whole gap for those jobs. Fleet-wide, recorded per-job
spend should rise from the investigation's ~15–21% toward parity with the host
meter (the residual being any nested call whose cwd is not a job dir, and
non-panel jobs, which were already near-complete). The cross-host remote-pool
fallback and reputation cost signals become accurate for the first time.

## (b) Per-seat tiering

Seats run `claude -p` inside the monk's Anthropic-authenticated environment, so the
reachable models are Anthropic-only: the ceiling model (Opus, inherited when no
`--model` is passed), Sonnet, and Haiku. The map downshifts **only** — a seat is
never routed *above* the inherited ceiling — so tiering can only reduce cost.

`scripts/jobs/gardening/seat-model-tiers.tsv` maps each seat to a review tier;
`panel.sh`'s `seat_model_flag` resolves it to a `claude --model` value (`opus` →
inherit / no flag; `sonnet`/`haiku` → explicit). Overridable wholesale
(`GARDEN_PANEL_SEAT_TIERS`) or per-tier (`GARDEN_PANEL_MODEL_SONNET`,
`GARDEN_PANEL_MODEL_HAIKU`). Unknown seats default to `opus` (fail-safe: an
unmapped seat keeps full capability).

### Tier assignments and rationale

**Opus (10 seats + inherit) — deepest reasoning; a miss is subtle and expensive.**
The set is confined to four review families where review-miss clusters or the cost
of an escape justify the strongest model:

| Seat | Why Opus |
| --- | --- |
| `saboteur`, `breaker` | Adversarial. Finding creative failure modes / invariant attacks rewards the strongest reasoning; a weaker model reviews only the obvious. |
| `warden`, `locksmith`, `wire-watcher` | Security boundary (SES/hardened-JS, prototype pollution, on-the-wire trust). A missed finding is a security hole, the most expensive class of escape. |
| `integrator`, `purist`, `engine-realist`, `spec-keeper` | The expert-distilled deep lenses (kriskowal, erights, mhofman, gibson042). Each encodes hard-won architectural / ocap / engine / spec taste; `integrator` also owns the cross-boundary ownership-map cluster (endojs/endo-but-for-bots#1018). Downshifting these would blunt exactly the judgment they exist to concentrate. |
| `decomplector` (design panel) | Simple-vs-easy / complection is the deepest design-panel judgment and the design half of the ownership-map cluster. |

**Haiku (6 seats + appellate) — mechanical, narrow, or deterministic-pre-pass-gated.**

| Seat | Why Haiku |
| --- | --- |
| `orthographer`, `coverage-auditor` | Already fronted by a deterministic pre-pass (British-spelling grep; c8 coverage-of-new-lines). The LLM step is a narrow adjudication over pre-flagged candidates, not open reasoning. |
| `archivist`, `pruner` | Docs/comment accuracy, banner detection, documentation-padding — mechanical prose/structure checks, `archivist` often driven by the banner pre-pass. |
| `copyeditor`, `pedant` | Prose mechanics / formal style on design PRs — grammar, voice, formatting. |
| `appellate` | Advisory only; conservatively lists small in-context follow-ups before un-draft. Never blocks; a cheap model suffices. |

**Sonnet (21 seats + decider) — the default: a strong general reviewer.**
Everything else: `assessor`, `benchmarker`, `changeset-auditor`, `corner-prober`,
`curator`, `duality-auditor`, `fast-checker`, `gateway`, `migrator`, `packager`,
`prover`, `releaser`, `scribe`, `stylist`, `surfacer`, `transplanter`, `typist`
(code), and `critic`, `skeptic`, `ergonomist`, `novice` (design). Sonnet 5 is a
highly capable reviewer for scoped correctness/hygiene/clarity judgments; these
seats have a clear rubric and a bounded surface, so Sonnet matches Opus in
practice. The **decider** (foreperson) applies a mechanical disposition rubric
("any concrete request-changes finding → must-fix") and is Sonnet.

Candidates to revisit if a quality regression shows up: `critic` and `typist`
(broadest / most correctness-adjacent of the Sonnet set) are the first to promote
back to Opus.

### Rough cost effect

A code panel drops from 30 Opus seats to ~9 Opus + ~17 Sonnet + ~4 Haiku. At
Sonnet ≈ ⅕ and Haiku ≈ 1/15 of Opus per token, that is ~55–60% off the panel's
per-round LLM cost while the 9 highest-stakes seats keep Opus.

## What this does not change

The four-tier fleet dispatch vocabulary (`skills/model-selection`) and the
role/tier map are untouched: seat tiering is an intra-panel concern, resolved by
`panel.sh` against Anthropic CLI model aliases, orthogonal to how the *panel job
itself* is dispatched. Reversible by editing the TSV or setting
`GARDEN_PANEL_SEAT_TIERS` / `GARDEN_PANEL_MODEL_*`.
