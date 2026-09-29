---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# ensure-pr.sh's phase/evidence gate prefers a stale local base ref over origin/<base>

Self-improvement finding from `endojs/endo-but-for-bots#1370` (job
`endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929`):
in an isolated project checkout, the phase/evidence gate compared against the
local `llm` ref (stale at `3aa902d0037`) instead of `origin/llm` (current,
`1706e63247f`). The stale comparison pulled unrelated source changes into a
design-only PR's diff and wrongly demanded an implementation ledger. Working
around it by re-running the same gate with an explicit `--base origin/llm`
produced the correct `phase-evidence-verdict=clear reason=design-only-diff`.

## Task

Find the phase/evidence gate's base-ref resolution
(`scripts/jobs/gardening/phase-evidence-gate.sh` and/or wherever
`ensure-pr.sh` calls it) and fix it to resolve the intended remote base
(`origin/<base>`) rather than preferring an arbitrary local branch ref that
may be stale in a per-job worktree. Add a regression test that reproduces
the stale-local-vs-fresh-origin divergence (a worktree whose local branch
ref is behind `origin/<base>`) and asserts the gate compares against the
fresher `origin/<base>`.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T21:00:19Z
