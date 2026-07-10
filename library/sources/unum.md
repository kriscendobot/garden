---
source: (repository root)
source_repo: jcorbin.tngl.sh/unum
source_url: https://tangled.org/jcorbin.tngl.sh/unum
source_commit: 1834abac9b27e517d0ffd2bf20625e33e9a05028
source_date: 2026-07-09
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
section_count: 15
status: current
notes: |
  Sibling-implementation ingest of jcorbin's **unum** monorepo, hosted on
  **tangled.org** (an atproto-hosted git forge, NOT GitHub). The repo is a
  cloneable git remote (`git clone https://tangled.org/jcorbin.tngl.sh/unum`,
  which redirects to a `knot1.tangled.sh` DID-keyed host), so provenance is
  pinned by ordinary per-file commit shas via `git log` on the clone — the same
  idempotency anchor a GitHub repo source uses. Each section records its
  file-specific sha. Tangled does not (as of this ingest) expose a stable
  per-file blob-permalink URL scheme the way GitHub's `/blob/<sha>/<path>` does,
  so section footers cite the repo URL plus the file path and short sha rather
  than a deep blob link; the sha is the durable anchor. Maintainer-directed
  one-off ingest (job `scholar-ingest-unum`), read for **transferable patterns
  with a token-spend-tracking through-line**, not for import. This cycle covers
  the token-spend and orchestration core; a follow-on
  `scholar-ingest-unum-remainder` job carries the rest (LORE lessons, refinery /
  staging / notify_server subsystems, the make/user systemd resource quota).
---

## Abstract

**unum** is jcorbin's task-queue automation monorepo for AI coding agents —
"evoke agents to work on tasks, one at a time, as managed systemd services." It
is an **independent convergent design** with the garden and with OpenAI's
Symphony (see topic [`agent-fleet-orchestration`](../topics/agent-fleet-orchestration.md)):
a fleet of AI coding-agent invocations is driven off a file-backed task board
(`TODO/` pending, `TOQU/` open operator questions, `TADA/` completed archive,
`PLAN/`/`LORE/`/`STANDARDS/` docs), run as systemd one-shot services, and steered
by an operator over a Telegram bot. The system develops itself (self-evocation).
Its core Go binary `devoker` splits into an **invoker** (claims a task, runs the
agent, archives to `TADA/`), **televoke** (the Telegram control plane, hosting
`steward`/`liaison`/`foreman` personas), **vigil** (a proactive health monitor
that kicks an idle invoker with pending work), and **refinery** (a branch-merge
pipeline). A retired Bash prototype (`pivoker/`) is kept for reference.

For the library, unum's highest-value contribution is a **fully-built per-run
token-and-compute cost ledger** (`evoke/costs.jsonl` + `invoke cost`), the piece
the garden's own fleet-spend machinery (`scripts/jobs/usage-meter.sh`, a
fleet-wide weekly *quota gate*) does not yet have: per-run records attributed by
session / trigger / channel / task / model, aggregated on demand and surfaced in
three places. This is the concept [[cost-ledger]] and the primary reason for the
ingest. Secondary transferable patterns: per-persona model tiers ([[model-routing]]),
and the **vigil-charge initiative budget** ([[vigil-charge]]) — a health-gated
rate limit on *proactive* agent invocations that spends a "charge" accumulated
only over verified-quiet health rounds.

**Remainder ingest (2026-07-10, job `scholar-ingest-unum-remainder`).** A second
cycle carried the rest of the transferable veins beyond the token-spend/orchestration
core. The richest is the **LORE corpus** — ~67 distilled incident lessons, consolidated
aggressively into a corpus-shape section plus four thematic sibling sections (claim
lifecycle, journal/git-ref durability, crash-safe lifecycle guards, engineering
discipline for a self-editing harness) rather than mirrored one-to-one — much of it a
direct analogue of the garden's own git-push-CAS job board, stale-claim reaper, and
`land-journal-edit`/`journal-entry` producer-clone discipline. Also ingested: unum's own
dimension-by-dimension **garden-vs-devoker fleet comparison** (an outside sibling reading
this garden's architecture back to it), the **devoker four-layer architecture** plus the
vigil/refinery engine, the **systemd resource-slice quota** profiles (a *non-token* agent
budget — [[resource-slice-budget]] — complementing the cost ledger), the standalone
**notify-server** durable proxy (persist-then-dispatch plus Routedown), and the
**operations standards** for a self-editing monorepo. Declined this cycle (low
cross-cutting value / unum-specific): the command-by-command `devoker/DESIGN.md` surface,
the `evoke/` persona/soul config shapes, and the `STANDARDS/{golang,bash,monorepo}.md`
idiom files. No further `-2` follow-on posted — the transferable veins are covered.

Note (`ref/kris_garden/`): unum vendors a snapshot of *this* garden under
`ref/` for comparison. That subtree is the garden's own material and is excluded
from this ingest; only unum's own code and docs are curated here.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [Self-evocation orchestrator architecture](../sections/unum--overview.md) | agent-fleet-orchestration | current |
| [The per-run token/compute cost ledger (costs.jsonl)](../sections/unum--token-cost-ledger.md) | coding-agent-economics | current |
| [Cost attribution, aggregation, and surfacing](../sections/unum--cost-attribution-and-aggregation.md) | coding-agent-economics | current |
| [Per-persona model tiers](../sections/unum--per-persona-model-tiers.md) | coding-agent-economics | current |
| [The vigil-charge initiative budget](../sections/unum--vigil-charge-initiative-budget.md) | agent-fleet-orchestration | current |
| [The LORE corpus — a distilled-incident lesson library](../sections/unum--lore-corpus-shape.md) | agent-fleet-orchestration, repository-governance | current |
| [Claim-lifecycle hazards — atomicity, liveness proof, landed≠done](../sections/unum--lore-claim-lifecycle.md) | agent-fleet-durability, agent-fleet-orchestration | current |
| [Git-ref journal durability — RMW-CAS, primitive selection, cutover](../sections/unum--lore-journal-durability.md) | agent-fleet-durability, persistence | current |
| [Crash-safe automated-lifecycle guards](../sections/unum--lore-crash-safe-guards.md) | agent-fleet-durability | current |
| [Engineering discipline for a self-editing harness](../sections/unum--lore-engineering-discipline.md) | repository-governance, testing | current |
| [Garden systemd lanes vs devoker invokers — a comparison](../sections/unum--garden-vs-devoker-fleet.md) | agent-fleet-orchestration | current |
| [Devoker's four-layer architecture and vigil/refinery engine](../sections/unum--devoker-four-layer-architecture.md) | agent-fleet-orchestration, process-monitoring | current |
| [Host provisioning and systemd resource-slice quotas](../sections/unum--make-user-host-resource-quota.md) | coding-agent-economics, agent-fleet-orchestration | current |
| [notify-server — a durable notification proxy (Routedown)](../sections/unum--notify-server-routedown.md) | agent-fleet-orchestration | current |
| [Operations standards for a self-editing monorepo](../sections/unum--operations-standards.md) | repository-governance, agent-conventions | current |
