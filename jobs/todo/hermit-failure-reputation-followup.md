role: builder
# Refine the Ollama hermit gardener: on failure, check whether claude/codex would
# have succeeded, and demerit the (model, harness, context) reputation

Maintainer directive (2026-07-27): when an Ollama-backed hermit gardener FAILS a job,
follow up by checking whether CLAUDE or CODEX would have succeeded on the same job.
If a capable model succeeds where ollama failed, record a DEMERIT against the
reputation of the (model, harness, context) assigned to that job.

Implement in the garden repo (main2, DIRECT push, NO PR per CLAUDE.md):
- In the hermit/local failure path (scripts/jobs/handlers/ + the gardener loop),
  after a local/ollama (qwen3.6) job fails (handler rc!=0 / would-be-reaped), spawn a
  BOUNDED follow-up that re-attempts the same job's work on claude (and/or codex) to
  determine whether a capable model would have succeeded.
- On capable-succeeds-where-ollama-fails: record a demerit via the reputation system
  (scripts/jobs/reputation.sh) keyed on the tuple (model=local/qwen3.6, harness=hermit,
  context=the job's role/type), building the signal that local ollama is unfit for
  that job class. Feed it to future routing / the gnome-backend-autotune design
  (designs/gnome-backend-verified-autotune.md).
- Guard cost + loops: bounded, no infinite retry, respect the budget freeze, never
  double-run live work.
- Tests under scripts/jobs/test/; verify CI-equivalent locally; push to main2.
Note: hermits are currently disabled fleet-wide (hermits:0) pending investigation, so
this won't exercise until re-enabled — build it regardless; it is the measurement that
justifies re-enabling or retiring the local tier per job class.
