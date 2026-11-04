---
created: 2026-11-04
updated: 2026-11-04
author: gardener
---

# Skill: host-repair

## Purpose

Diagnose and repair a mechanical failure on one garden leader or follower while
keeping execution inside the sysop's closed vocabulary and destructive intent
with the maintainer.
This skill covers reachability, workers, heartbeat, drain,
rolling deploy, units, journal clones and locks, the deployed root, and
leader-only services.
It does not own project code, pull requests, or job-board
policy merely because a host symptom exposed them.

## Inputs and state

Every dispatch supplies `target_host`, `trigger`, `mode` (`controller` or
`local`), and the triggering `evidence`.
Controller mode is the default and is
pinned to the leader; local mode is only for a present, undrained target whose
unit or journal logs are needed.
A drained or offline target never owns its own repair.
Leadership does not fail over automatically.

Reconstruct state from the newest durable records: the target's
`projects/garden/host-health/<host>.md`, `fleet/health/<host>`,
`budget/live/*/<host>`, host record, drain and `worker-derotate/<host>` markers,
deploy release and roll state, deployed SHA, watchdog notice, sysop log and ack,
and the deterministic [host disposition report](../host-disposition-report/SKILL.md).
A fresh heartbeat proves presence, not successful claims and completions.

## Procedure

### 1. Diagnose in a fixed order

Stop as soon as the evidence distinguishes healthy, degraded, offline, and
operator-held state.

1. Read the durable state above with timestamps.
   Compare deployed SHA with
   `origin/main2`, and identify the owner of every drain and roll marker.
2. Read the newest `sysop-log/<host>/` records and acknowledgments.
   Distinguish
   not sent, applied, refused, failed, and no arrival within two sysop ticks.
3. In local mode, inspect only failed `garden-*` units and the narrow relevant
   journal window.
   In controller mode, use committed self-heal captures and watchdog details.
   If neither exists, request a local mechanic.
   Report a
   `journalctl --user` permission failure; do not bypass it.
4. Check load, memory, swap, byte and inode headroom, reboot time,
   `journal-contention-probe.sh`, clone packs and garbage, `rc=124`, busy
   markers, and lock-holder liveness.
   Age alone does not make a lock stale.

Never run git in the deployed root or the live journal worktree.

### 2. Classify the failure

- **Offline:** stale heartbeat, no recent journal activity, and no record or ack
  for a sent benign operation.
  Stop remote mutation, preserve drain and
  derotation, and ask a person to wake Docker, the VM, or the machine.
- **Stale heartbeat on a present host:** live scaler/sysop plus CAS warnings or a
  slow scan.
  Refresh the exact budget pool first; clear only actual failed-unit
  accounting.
- **Offline derotation:** let automation restore the saved counts after heartbeat
  and sysop recovery.
  Never invent counts or adopt an operator zero.
- **Worker CLI missing:** compare the user-manager environment, reviewed binary
  candidates, and deployed version.
  A restart or deploy crosses the attestation
  wall; do not guess a PATH.
- **Drain or canary:** identify ownership, live deploy state, release/deployed
  SHA, gate timeout, busy marker, and clone latency.
  Preserve a failed-canary or
  ambiguous leader drain; never advance, clear rejection, or roll back.
- **Journal contention or clone bloat:** prefer the existing contention watcher,
  namespace-clone repair, geometric repack, and hot-clone paths.
  Missing objects
  or ref deletion require a person.
- **Stale/divergent journal worktree:** leave it untouched.
  The keeper may retry
  a clean non-ahead case; dirty, ahead, or divergent state needs deliberate
  reconciliation.
- **Root corruption:** let `garden-root-repo-guard` make lossless repairs.
  Root
  maintenance is attested and only for its confirmed stale-maintenance case.
- **Stranded leader deploy:** use `deploy-strand-recover.sh` only through its
  owning local recovery path.
  Preserve inherited operator drain and do not
  roll back automatically.
- **Singleton mismatch:** stop before changing the leader marker.
  A confirmed
  handoff takes outgoing liaison Monitors down, confirms that state, moves the
  marker, then raises incoming Monitors.
- **Credential refusal:** route the affected work away and ask the maintainer to
  repair permission.
  Restarts do not repair authorization.

### 3. Climb the operation ladder one rung at a time

Record the precondition, send one operation with `send-host-op.sh`, wait for its
sysop record and terminal ack, then re-read the failing signal.
The following
map is the complete sysop vocabulary and the mechanic's authority boundary.

<!-- mechanic-operation-map:start -->
```text
reset-failed|unattested
refresh-budget-snapshot|unattested
restore|unattested
drain|unattested
set-workers|unattested
unit|maintainer-attestation
deploy|maintainer-attestation
local-model|maintainer-attestation
maintain|maintainer-attestation
```
<!-- mechanic-operation-map:end -->

Apply the map with these narrower conditions:

1. Observe only when diagnosis is enough.
2. `reset-failed` only when a `garden-*` unit is actually failed.
3. `refresh-budget-snapshot` only for the exact stale pool on a present host.
4. `restore` only for a demonstrated provider, quota, or network outage; use the
   [restore skill](../restore/SKILL.md) for its judgment-bearing half.
5. `drain` may contain or quiesce, but `drain off` must satisfy the ownership
   rules below.
6. `set-workers` is forbidden on a leader.
   On a follower it requires the exact
   maintainer-supplied count; never infer a count or change a pool ceiling.

The final four operations are a hard attestation wall.
The mechanic cannot create `authorized_by`.
Request the exact target, operation, arguments,
evidence, effect, and stop condition; relay only an explicit maintainer
attestation and wait for the terminal ack. `unit` names one installed
`garden-*` unit and action justified by its log. `deploy` uses only the hardened
deploy path with candidate and quiescence evidence. `local-model` uses only the
host's reviewed resolved default with disk evidence. `maintain` is only for a
confirmed stale gc lock or root-maintenance condition.

### 4. Preserve drain ownership

- A live deploy, roll, leadership handoff, or operator owns its drain; only that
  workflow lifts it.
- A failed canary stays drained until it passes or the maintainer explicitly
  chooses the old SHA.
- `deploy-strand-recover.sh` lifts only a drain the dead deploy engaged and
  preserves an inherited operator drain.
- A mechanic may lift a roll-owned drain only after proving no deploy is live,
  the marker is roll-owned, and the canary passes or the old SHA is explicitly
  safe.
  Then confirm claims, completions, and advancing fleet health.
- Never lift a maintainer/operator drain without that owner's direction.
  Preserve
  every ambiguous leader drain.

### 5. Handle recurring dispatches

A local check-up is bounded to 15 minutes, writes one host-health record, and
exits early when a roll release or drain would make it obstruct the deploy.
Its
controller companion first confirms that the local run completed, then uses this
same diagnosis order and ladder; it carries no independent repair policy.
If
controller evidence cannot establish cause, dispatch a local mechanic or request
a person at the machine rather than extending the sysop with remote shell.

## Output shape

Append through `land-journal-edit.sh`, newest first, and repeat the same compact
record in the completion report:

```markdown
## <UTC timestamp> - <job base>

- Verdict: healthy | degraded | unhealthy | operator-held | unreachable
- Target / role / mode: <GARDEN> / leader|follower / controller|local
- Trigger: <watchdog key, schedule, or maintainer request>
- Evidence: <health record times, sysop msgids/outcomes, narrow log citations>
- Cause: <established cause, or unknown with what is missing>
- Actions: <operations with acks and code commits, or none>
- Final state: <heartbeat, units, deployed SHA, drain, workers claiming/completing>
- Maintainer: <exact requested decision or "none">
- Next mechanic: <remaining condition, owner, and first evidence to check>
```

Record every attempted operation, including refusals and missing acks.
Name the
failing signal and its after-state.

## Notes

- No ferry, credential move, identity switch, arbitrary sysop shell, guessed
  `authorized_by`, ref deletion, or history deletion.
- No leader-marker change outside an explicit confirmed handoff.
- No automatic rollback or clearing a rejected candidate to force the same SHA.
- A safe held state with one exact external action is a complete mechanic outcome;
  an unexplained mutation is not.
