Job complete. Here is my report.

---

## Completion report: `garden-foreman-independent-brake`

**Landed on `main2`** as commit `c7d730c365` (no PR, per garden convention). First-attempt CAS push.

### What I built

A foreman-only brake that stops **only** the foreman pump, decoupled from the all-or-nothing fleet drain. The required truth table holds:

| fleet drain | foreman brake | gardeners claim? | foreman pumps? |
|---|---|---|---|
| on | either | no | no |
| off | on | **yes** | no |
| off | off | yes | yes |

- **`common.sh`** — `foreman_braked(<clone>)` = `fleet_draining OR brake-flag-present`, plus the `GARDEN_FOREMAN_BRAKE_PATH` constant (default `config/foreman-brake`).
- **`foreman.sh`** — the guard now calls `foreman_braked "$DIR"` in place of `fleet_draining`. This is the **only** call site that changed; the ~25 other `fleet_draining` sites (claim-job, gardeners, watchers, orchestrate/unblock) are untouched, so the brake never touches a gardener's claim. Moved the guard to *after* `sync_clone` so the brake is read from the clone the foreman already syncs.
- **`brake-foreman.sh`** — operator CLI (`on|off|status`), mirroring `drain-fleet.sh`'s shape (prose reason in the marker) and CAS-racing the flag onto `journal2` like `set-main-host.sh`.

### The storage decision — journal-backed (matching the maintainer's lean)

Chosen **journal-backed** (`config/foreman-brake` on `journal2`), not a host-local marker. The foreman is a leader-only singleton: a host-local brake would be **left behind when the `leader` marker moves**, and the new leader's foreman would start pumping immediately. A journal flag is fleet policy in fleet state — it follows the leader across a handoff, is reachable from any host **without a new sysop op**, and is auditable in git. Cost is one stat on a clone the foreman synced anyway.

**Fail-safe direction: toward braked.** Existence is the signal (like the drain marker), so a corrupt/garbage flag still brakes. And the brake is read only *after* `sync_clone`, which exits the tick on an unreadable/offline journal — so the pump never fires on a journal it couldn't read. An unreadable brake never silently *un*brakes. Documented in-code, in CLAUDE.md, and in the design note. **No new sysop op needed** (stated explicitly in the design note and CLI header).

### Tests — `scripts/jobs/test/foreman-brake-test.sh` (20 passed, 0 failed)

Pins all four truth-table rows with the **real** `foreman.sh` (pump detected via the stub handler's cost-gate) **and** the **real** `claim-job.sh` (proving a gardener still claims under the brake — the whole point). Also: set→clear resume, the corrupt-flag fail-safe (integration + pure-predicate), and a structural check that the brake read stays *after* `sync_clone`. (One harness bug fixed along the way: `grep -q` under `set -o pipefail` SIGPIPEs the upstream writer — switched to capture-then-grep.)

### No regressions

- `run-test.sh` core suite: **368 passed, 0 failed**
- `foreman-maintainer-notice-dedup-test` 6/0, `foreman-edge-kick-test` 7/0, `fleet-brake-test` 14/0
- CI-equivalent: `bash -n` clean across all scripts; grep-gate tests 7 suites pass; CLAUDE.md inventory-drift, double-space, maintainer-inbox checks all rc=0; shellcheck clean (only the codebase-standard `GARDEN_TAG` SC2034 false positive, same as `drain-fleet.sh`).

### Docs

- **CLAUDE.md § Job system** — new "The foreman brake" subsection with the truth table and the journal-backed/fail-safe rationale.
- **`designs/omega-task-rank-and-foreman-retirement.md`** — recorded under Stage 1 as the landed mechanical precursor (changes no promotion logic, rank, or target).

### Deploy / reconcile impact

- **Takes effect on a normal `deploy-garden.sh`** (it advances the root checkout with the new `foreman.sh`/`common.sh` and adds `brake-foreman.sh`). Until deployed, the running foreman uses the old `fleet_draining` guard; a flag written pre-deploy is harmlessly ignored by the old code.
- **No units reconcile** — no new/changed systemd unit, timer, or template; `brake-foreman.sh` is an operator CLI, not a service. `install-units.sh` / `gardener-scaler.sh` need not run.
- **The leader host needs nothing beyond the normal deploy.** The brake follows the `leader` marker (journal state), so no per-host arming or marker migration. Absence of the flag = not braked (correct default; no seeding).
- After deploy, to use it: `scripts/jobs/brake-foreman.sh on [reason]` from **any** host (CAS-pushes to `journal2`); effect on the next foreman tick (~5 min), no restart. `off` resumes.

### Follow-ups (none blocking)

This is the mechanical precursor only. The generative-pump retirement and rank-ordered promoter (Stages 1–5 of the omega design) remain future work and are behavior changes an agent may not originate.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-foreman-independent-brake.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (9132979 cached reads)
- Output: 60570 tokens
- Cost: $7.761696499999999
- Wall-clock: 1048s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
