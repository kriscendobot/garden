All landed on `main2`. Here is my completion report.

---

## Completion report: orchestration-job pattern

Built the maintainer's requested pattern (kriskowal 2026-07-01): for a multi-part job, always make **one orchestration job** that moves planned sub-jobs off `plan/` into `todo/` in sequence (default) or parallel, and **watches** the children so a follow-up is never forgotten. Landed on `main2` (commit `95d646f62`, 14 files, +1126).

### What I built

**Mechanism (children identification + ordering).** An orchestration is a record `jobs/orch/<base>.md` (new board category alongside `plan/`/`index/`, never claimed/reaped) whose frontmatter names `children:` (in run order), `order: serial|parallel`, and `on-child-failure: halt|continue`. Children are parked in `plan/` with a **new `orchestrated` gate** carrying `orchestrated_by: <orch-base>` — invisible to the foreman (promotes only `deferred`) and to `unblock.sh` (promotes only `blocked`), so *only* the orchestrate watcher promotes them (no mover races it).

**Built ON the deterministic substrate (the preferred choice per the job).** The watcher `orchestrate.sh` is a leader-only timer oneshot, **no `claude -p`**, modeled exactly on `unblock.sh` — the same "promote when the board reaches a state" idiom, reusing `promote-plan.sh` and tada-detection. It adds the three things a pure `blocked_on` edge cannot express: **parallel fan-out**, a **progress/completion record**, and a **failure policy** (unblock promotes the next child when the blocker merely *reaches* tada, with no notion of failure). I documented the relationship and kept `--blocked`/unblock as the lighter tool for a plain linear two-step dep.

**Watch + failure handling.** Each tick advances every orchestration one step against board state: child is `done` (tada), `active` (todo/doin), `parked` (plan), or `failed` (vanished without a tada — the reaper poisoned it — or a report marked `orchestration-failed`). Serial promotes one at a time and waits while active; parallel promotes all at once. A child failure triggers the policy — **halt** stops a serial run, sweeps not-yet-run downstream children, and **surfaces to the maintainer inbox**; **continue** proceeds. Never a silent stall. On completion it writes `tada/<orch-base>` with an `orchestration-status:` marker and removes the record. Leader-only so a failure note posts exactly once (promotion itself is CAS-deduped/host-safe).

**Files:** `scripts/jobs/{post-orchestration.sh, orchestrate.sh}` (new), `post-plan.sh` + `common.sh` (`--orchestrated` gate, `JOBS_ORCH`, `orch_*` helpers), `scripts/systemd/garden-orchestrate.{service,timer}` (new, is-main-host gated), `roles/orchestrator/AGENT.md` + `skills/orchestration/SKILL.md` (new), `designs/orchestration-jobs.md` (new).

**Encoded the standing pattern** in CLAUDE.md (job-system § Orchestrating a multi-part job + leader-only singleton set + roles/skills inventory), `roles/liaison/AGENT.md` (§ Multi-part work), and `roles/gardener/AGENT.md`.

### Tests
`scripts/jobs/test/orchestrate-test.sh` (hermetic, throwaway journal, no systemd) — **14/14 pass**: serial promotes one child at a time and advances only after each reaches tada; parallel promotes all at once; a child failure halts a serial run (next child NOT promoted, downstream swept, surfaced to maintainer) under `halt` and proceeds under `continue`. `enable-services-test` stays green with the new unit integrated (derived==enabled, 22 units).

### Follow-ups
- The bulletin does not yet render active orchestrations in the maintainer dashboard (completion writes a visible `tada/` entry + a maintainer note on halt/failure; log lines carry per-tick progress). A `Plan queue`-style "Orchestrations" section is a small future add.
- `post-orchestration.sh` requires children pre-parked (a never-posted child reads as `failed`, indistinguishable from vanished) — enforced by default validation; `--no-validate` exists for concurrent-post cases.
