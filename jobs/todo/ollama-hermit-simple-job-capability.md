role: builder
# Investigate whether Ollama (local hermit) can complete a SIMPLE job; fix obvious blunders

Maintainer directive (2026-07-27): determine whether the Ollama-backed hermit gardener
(local; currently qwen3.6 = qwen3:0.6b) can complete a SIMPLE job at all, and fix any
obvious blunders in the hermit setup/harness that make even trivial jobs fail.
- Construct a minimal, well-scoped "simple job" (e.g. a one-line doc edit, a trivial
  deterministic transform) and run it through the ACTUAL hermit dispatch path
  (scripts/jobs/handlers/cleric-codex.sh local provider / the hermit harness) — not
  just a raw `ollama` curl.
- Report: does it succeed end-to-end? If not, WHERE does it fail — model too small,
  prompt/format, harness bug, PATH/shim, model-tag mismatch (qwen3.6 vs qwen3:0.6b),
  or tooling/context assumptions a 0.6B model can't meet?
- FIX obvious blunders (wrong tag/alias, malformed prompt, missing shim, harness bug)
  in the garden repo (main2, DIRECT push, no PR). Do NOT paper over a fundamental
  capability gap: if a 0.6B model simply cannot do garden work, say so plainly WITH
  EVIDENCE (this feeds hermit-failure-reputation-followup + gnome-backend-autotune).
- Hermits are disabled fleet-wide (hermits:0); exercise the harness path directly
  (you may start ollama locally in your worktree) WITHOUT re-enabling fleet hermits.
Deliverable: a clear verdict (simple job: succeeds/fails + why) + any blunder fixes on main2.
