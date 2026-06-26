<!-- garden-promoted-from-plan: gate=deferred priority=high at=2026-06-26T04:38:47Z -->

# GOAL: wire the driving loop + standing daemons to run the in-process pipeline

## Context
`packages/harness/loop.js` `runOnce` posts JOBS to a board for LLM subagents but
does not itself compute the OODA cycle. `packages/pipeline/ooda-cycle.js`
`runOodaCycle` is the in-process compute path (proven by `bin/finbot-ooda`). The
oracle-watcher role brief describes a standing shell daemon + systemd unit; the
steward/journalist autonomous loops are described but not wired.

## Build
- A harness integration so a driver tick can run `runOodaCycle` in-process for the
  dry-run compute path and record real per-stage entries (today loop.js only posts
  jobs). Keep the job-posting path; add the compute path as a config hook so the
  existing loop tests stay green (mind the harness->simulator dependency direction:
  the wiring that needs both lives in @finbot/pipeline or a bin, not in @finbot/harness).
- `scripts/` + templated systemd user units: the oracle-watcher standing daemon
  (shell-only poll, no LLM context) and a persistent `finbot --persistent` driver.
- The steward and journalist autonomous loops (per their role briefs).

## Safety bounds
Dry-run only; oracle polling read-only against pinned trusted endpoints only
(`CLAUDE.md` § Monitoring safety constraint). No agoric-sdk work. No live executor.

## Done
A persistent dry-run driver that runs the in-process OODA cycle on cadence and
journals it; oracle-watcher daemon + units; steward/journalist loops; tests green.
