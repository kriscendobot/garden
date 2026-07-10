---
title: Host provisioning and systemd resource-slice quotas — a non-token agent budget
source: devoker/DESIGN.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 23cb6dd980e4216ca5631f56973134894bc4aa53
source_date: 2026-07-09
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [coding-agent-economics, agent-fleet-orchestration]
status: current
notes: |
  The `devoker make user` / `make host` provisioning tree, focused on the
  systemd resource-slice quota profiles (light/medium/heavy) — a DIFFERENT budget
  kind than the token/compute cost ledger: host CPU/memory/task slices per
  least-privilege agent account. Complements [[cost-ledger]] on the resource-budget
  axis.
---

## Abstract

A token/compute cost ledger ([[cost-ledger]]) bounds what an agent *spends at the model*; it says
nothing about what the agent's process *consumes on the host*. unum's `devoker make` verb tree carries
the second, orthogonal budget: **systemd resource-slice quotas** (CPU / memory / task-count) applied per
least-privilege "alter" account an invoker runs under. This is a **different budget kind** — host resource
slices, not tokens — and worth filing alongside the cost ledger as the *other* axis of bounding an
autonomous agent. `make user` provisions and quota-tunes the alter accounts; `make host` hardens the box
those alters live on.

## The resource-slice quota profiles

`make user add` (and the standalone `make user quota`, which re-tunes an existing alter's slice override in
isolation with no full re-add) writes a per-user systemd slice override (`user-<uid>.slice`) from a named
profile:

| Profile | CPUQuota | MemoryMax | TasksMax |
|---|---|---|---|
| `light`  | 200% | 2 G | 1024 |
| `medium` (default) | 400% | 4 G | 2048 |
| `heavy`  | 800% | 8 G | 4096 |

Individual knobs (`--cpu-quota`, `--memory-quota`, `--tasks-max`) override the profile; `--force` bypasses a
**host-resource overcommit check** that otherwise refuses a quota the box can't back. A bare `make user quota
alter --dry-run` (no flags → default profile) doubles as a "what would my defaults look like?" inspection. The
takeaway pattern: **an agent account gets a declared resource envelope, sized by tier, validated against host
capacity before it is applied** — the host-side analogue of a per-run spend cap.

## Plan-then-apply provisioning discipline

Every `make` verb is structured as a pure **`BuildPlan` (no I/O) → `Plan.String()` preview → confirm (unless
`-y`) → `Plan.Apply`** pipeline that threads a `Runner` seam across the steps (each shelled through `sudo`, per
the seam-injection discipline). The plan render is **diff-friendly**, so two dry-runs with different flags can be
`diff`ed. Step failures short-circuit with a `StepError` carrying a **cleanup hint** derived from the error type
(a passwd-lookup miss points at `make user add`; a later failure points at re-running the verb) — there is **no
auto-rollback** (deliberate: the recourse on a failed `systemctl start` is to inspect the unit, not delete the
alter). A read-only verb (`status`) asserts `Plan.IsReadOnly()` to guard against a future refactor silently
dropping a confirm, and mirrors `systemctl` exit codes so operator shells can branch on them.

`make user` verbs cover the full alter lifecycle: `add` / `remove` (inverse sequences), the systemctl-fronting
`start`/`stop`/`restart`/`enable`/`status`, `quota` (re-tune the slice), and `deploy` (land the operator's
identity — rewritten `.gitconfig` + merged `authorized_keys` + `$HOME` — into an existing alter). An `add`
probes for `systemctl` on PATH and, if absent (minimal/non-systemd staging containers), forces `--no-start
--no-enable` with a warning rather than failing.

## make host — hardening the box the alters live on

`make host` is the companion: where `make user` provisions accounts, `make host` **hardens the host**. It surveys
a registry of system "knobs" — each a self-contained `Check` (read-only "is this set?") + `Plan` (the same
step-list applied through the shared runner) — reports which are compliant, and offers each non-compliant knob a
previewed, idempotent fix. Knobs include `sshd` (restrict SSH to the allowed group, strip forwarding), `pam_wheel`
(require wheel for `su`), `hidepid` (`/proc` with `hidepid=2`), `limits` / `sysctl` hardening, `audit-execve`
(audit unprivileged execve), and alter-aware sweeps (`alterusers-group`, `alter-systemd-sweep`). Modes:
bare (confirm each), `--check` (survey-only, non-zero if non-compliant — for CI/cron), `--dry-run`, `--apply`.
Reboot-class knobs prompt for explicit assent before applying and are **skipped rather than silently rebooting**
in non-interactive mode without `-y`. Alter detection resolves through a world-readable `/etc/devoker/alters`
marker (no sudo, CI-safe), degrading to an "alter set unknown" verdict rather than *guessing* when it can't be
determined.

Source: [devoker/DESIGN.md](https://tangled.org/jcorbin.tngl.sh/unum) (`devoker make` sections) at commit `23cb6dd`.
