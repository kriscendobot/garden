---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-05): design (and hand off to a build)
an automated **PR completion receipt** — emitted for every PR the garden
finishes work on, merged OR closed, posted as a PR comment AND archived in the
journal.

## Required content (from the maintainer, verbatim requirements)

Per engagement on the PR:
- which **model** was used
- **tokens** used
- **harness** (the CLI/agent kind — `claude`, `codex`, `kimi`, etc. — this
  garden's `agent_bin`/worker-kind concept)
- **role** (builder, designer, fixer, weaver, a juror seat, etc.)
- **notional cost** (list-price)
- **calibrated estimated cost** (this instance's actual metered/measured basis)

Plus, once per PR:
- a **heuristic cost for maintainer review**, based on the amount of feedback
  the PR received (define the heuristic — see grounding below).

Delivery:
- Posted as a **comment on the PR** (merged or closed — not just merged).
- **Archived in the journal**, categorized by **repository, date, and PR
  number**.

## Existing infrastructure to build on — read before designing anything new

This garden already has almost every primitive this needs; the job is
composition and one new heuristic, not invention from scratch:

- **`scripts/jobs/cost-by-pr.sh`** already does the hard part: joining
  `usage/*.jsonl` job records to their merged PR (two-edge join: `jobs/index/`
  directive identity, then validated PR-number-in-basename), and prices on
  **two bases already**: NOTIONAL (the usage ledger's list-price
  `total_cost_usd`, which `cost-by-pr.sh`'s own header says overstates ~8.7x
  against a flat subscription) and the garden's own TRUE-COST basis (each
  reputation event's capped-proxy wallclock times `reputation/rate-card.md`).
  That TRUE-COST basis is almost certainly what "calibrated estimated cost"
  should mean here — read `cost-by-pr.sh`'s header and `designs/
  token-cost-ledger.md` closely before defining a third basis from scratch.
  Note today it only handles MERGED PRs (its own header: "roll up to the
  MERGED pull request") — extending it to closed-without-merge PRs is in
  scope for this design.
- **`reputation/events/<job-base>.md`** (journal) already carries per-engagement
  role/host/model records that `reputation.sh`/`reputation-reduce.sh` price
  against `reputation/rate-card.md` — the per-engagement rows the receipt
  needs (model, harness/provider, role, tokens) likely come from here plus
  `usage/<job-base>.jsonl`, not a new ledger.
- **`usage/<job-base>.jsonl`** and the `## Cost` block `complete-job.sh` stamps
  on every `jobs/tada/<base>.md` report already carry tokens/model/cost per
  engagement — the per-job source `cost-by-pr.sh` already parses.
- **The maintainer-review-feedback heuristic is new** — no existing script
  computes it. Ground it in the garden's own prior finding: `journal/
  library` (or ask `journal/` search) for **"human review dominates machine
  cost"** — ~50-190x at the median, i.e. review time/attention is the truly
  expensive resource, not tokens. A defensible heuristic likely counts
  something like: number of review rounds / `panel-runs/<repo>-<pr>/` seat
  count, review comment count and total length via `gh api` review/comment
  threads, number of fix-loop iterations the PR needed (`gauntlet.sh`'s
  `iteration`/`resumes` fields, or the archived `jobs/gauntlet-archived/`
  records' history for a PR already gauntleted). Propose a concrete formula
  and show its output is at least directionally sane against 2-3 real PRs
  before committing to it.
- **Comment-posting infrastructure already exists** for the one safe-to-watch
  repo class (`endojs/endo-but-for-bots`, the garden's own repos, and any
  auto-provisioned own-fork) — panel.sh and others already post PR comments
  via the fleet's identity-pinned `gh` wrapper. Reuse that path; do not invent
  a new posting mechanism. Per CLAUDE.md's monitoring-safety constraint, do
  **not** widen commenting to any repo outside the already-authorized set.

## What to design

1. **Receipt schema** — a concrete Markdown (or Markdown+table) shape covering
   every required field above, both the per-engagement rows and the one
   per-PR maintainer-review-heuristic figure. Keep it legible as a plain PR
   comment (GitHub comment-body size limits apply — `panel.sh`'s foreperson
   verdict distillation for GitHub's ~65KB review-body limit is the precedent
   to reuse for a PR with many engagements).
2. **The maintainer-review-feedback heuristic** — a defined, reproducible
   formula (see grounding above), not an ad hoc guess each time.
3. **The trigger** — deterministic, no-`claude -p` where possible (matching
   `orchestrate.sh`/`unblock.sh`/`gauntlet.sh`'s own house style): what detects
   "this PR just merged or closed" for a repo the garden has been working on?
   Likely a new watcher tick (or an extension of an existing one — check
   `ci-watcher.sh` and `comment-watcher.sh` for the closest existing
   merge/close-detection surface) that fires once per PR, idempotently, and
   hands off to the receipt generator.
4. **Journal archive layout** — `journal/receipts/<repo>/<YYYY>/<MM>/<DD>/
   pr<N>.md` (or similar; propose the exact shape) — categorized by
   repository, date, and PR number as the maintainer asked. One row per
   receipt in some index/manifest is fine but not required if the directory
   structure alone makes it browsable.
5. **Idempotency and history**: a PR can only complete (merge or close) once,
   so this should be simpler than the recurring-job idempotency problems
   elsewhere in the garden — but design for the retry case (a receipt-posting
   attempt that fails/crashes) not double-posting a duplicate PR comment.

## Build slice: NOT this job

Design only here — decide the schema, the heuristic formula, the trigger
mechanism, and the archive layout, and write it up. A follow-up **build** job
(`pr-completion-receipts-build`, parked `blocked_on` this design's basename)
implements the automation, wires the trigger, and produces 10 example receipts
from real already-completed PRs in this garden's own history (merged and
closed-without-merge both represented — candidates already surfaced this
session include `endojs/endo-but-for-bots#1075`/`#300`/`#1109`, closed without
merge, plus any of the recently-merged PRs `pr-review-sequence.md`'s "Newly
landed" section names). Leave the build job clear instructions to follow, not
open design questions to resolve.

## Landing

Land per the garden's own conventions (no PR for the garden's own repo, unless
this design surfaces real open questions worth a maintainer decision — e.g.
the exact review-feedback heuristic formula seems like exactly that kind of
judgment call worth flagging explicitly rather than silently picking one).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-05T12:36:11Z
