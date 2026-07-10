---
role: scholar
---

# Ingest remainder: jcorbin's `unum` (tangled.org) — beyond the token-spend/orchestration core

Follow-on to `scholar-ingest-unum` (2026-07-10), which ingested the token-spend
through-line (concept [[cost-ledger]] via `costs.jsonl`/`invoke cost`), per-persona
model tiers ([[model-routing]]), the vigil-charge initiative budget ([[vigil-charge]]),
and a self-evocation architecture overview. Source index: `journal/library/sources/unum.md`
(repo @ commit `1834aba`, tangled.org — clone with `git clone https://tangled.org/jcorbin.tngl.sh/unum`).
EXCLUDE `ref/kris_garden/` (a vendored snapshot of the garden itself) and `ref/`
subtrees generally.

## What is left (transferable patterns, scholar's discretion on selection)

- **`LORE/`** (~70 distilled incident/lesson files) — the richest untouched vein.
  Mine for transferable coordination/durability lessons (e.g. `claim_ledger_atomicity`,
  `journal_ref_concurrent_writers_cas_pattern`, `killswitch_source_guard_on_auto_clear`,
  `context_exhaustion_recap_and_keep_claimed`, `session_resume_model_guard`,
  `durable_state_ordering_breadcrumb_before_killswitch`). Consolidate aggressively —
  a `LORE`-index topic plus a handful of concept pages, not 70 sections.
- **`devoker/DESIGN.md`** (46 KB) and the **refinery / staging / vigil** subsystem
  designs — the branch-merge pipeline, per-task worktree/podman staging, the
  realm/channel coordination model. Compare to the garden's weaver/conductor + worktree model.
- **`notify_server/`** — the durable notification proxy (persist-then-dispatch with
  retry). Compare to the garden's bulletin/notify path.
- **`devoker/internal/make/user/` systemd resource quota** (`--quota-profile
  light|medium|heavy`) — a DIFFERENT budget kind (host resource slices, not tokens);
  worth a short section under a resource-budget concept.
- **`STANDARDS/`** (bash/golang/monorepo/operations) and **`evoke/` persona/soul**
  config shape — house-style + persona-config patterns.

## Skills
- [job-board](../../skills/job-board/SKILL.md), [journalism](../../skills/journalism/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md), [library-lookup](../../skills/library-lookup/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
The remaining `unum` veins above are ingested (or explicitly declined with a one-line
reason) into `journal/library/`, indexes updated, integrity gate green, any structural
lesson routed to `liaison`. If it again overflows one cycle, post `scholar-ingest-unum-remainder-2`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  claimed_at: 2026-07-10T20:53:36Z
