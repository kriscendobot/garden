---
created: 2026-11-04
updated: 2026-11-08
author: gardener
---

# Mechanic role

| Created | 2026-11-04 |
| Author | gardener |
| Status | Proposed |

## Purpose

The mechanic diagnoses and repairs one garden **host**. It handles mechanical
failures on leaders and followers: reachability, workers, heartbeat, drain,
rolling deploy, units, journal clones and locks, the deployed root repository,
and leader-only services. It does not repair a pull request, repository feature,
or job-board policy merely because a host symptom exposed one. It may land a
tested garden infrastructure fix when that fix directly repairs the host path.

A mechanic is dispatched by an actionable watchdog condition, a bounded
recurring check-up, or a maintainer request. Every dispatch names:

- `target_host`: the `GARDEN` identity being repaired;
- `trigger`: watchdog key, schedule, or maintainer request;
- `mode`: `controller` or `local`;
- the evidence that made the dispatch necessary.

`controller` is the default. The job is pinned to the current leader, which
reads journal evidence and reaches the target through the target's sysop. A
drained or offline target cannot claim its own repair. `local` is reserved for a
present, undrained target when direct unit and journal logs are necessary. If
the leader is the broken target, another present host may diagnose it and send
benign sysop ops, but leadership does not fail over automatically. Moving the
leader marker remains a maintainer-coordinated handoff.

The first corpus is oros, but none of the role or skill names are oros-specific.
The same playbook covers every leader, follower, and newly added host.

## Evidence behind the playbook

The procedures below come from observed failures. The [oros health log](../journal/projects/garden/oros-health-log.md)
and `journal2:jobs/tada/**/oros-health-{checkup,watch}-*.md` provide the recurring
snapshots. The focused reports cover [heartbeat, canary, and drain](../journal/jobs/tada/2026/10/02/fix-oros-heartbeat-canary-drain-20261001.md),
[probe latency](../journal/jobs/tada/2026/10/14/fix-oros-canary-probe-latency-20261014.md),
[review-write refusal](../journal/jobs/tada/2026/10/27/fix-oros-endojs-review-403-panel-routing-20261027.md),
[container portability](../journal/jobs/tada/2026/09/15/diagnose-oros-studio-policy-refusal-test-20260915.md),
[budget calibration](../journal/jobs/tada/2026/09/17/calibrate-oros-studio-budget-pool-20260917.md),
[hardware](../journal/jobs/tada/2026/10/11/oros-hardware-report-20261011.md),
and [offline derotation](../journal/jobs/tada/2026/09/28/auto-derotate-offline-host-worker-capacity.md).
The [sysop build](../journal/jobs/tada/2026/07/28/build-sysop-host-operations-daemon.md)
and [local-model extension](../journal/jobs/tada/2026/08/01/build-sysop-local-model-op.md)
establish the operation and attestation boundary.

Paired watchdog records show [canary](../journal/inbox/maintainer/read/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.2026-09-30T173812Z.md),
[derotation](../journal/inbox/maintainer/read/watchdog-worker-derotate-oros-studio-garden-ce242c49.2026-10-14T235019Z.md),
[clone-pack](../journal/inbox/maintainer/read/watchdog-namespace-clone-packs-oros-studio-garden-ce242c49.2026-10-12T124134Z.md),
[journal-lock](../journal/inbox/maintainer/read/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal.2026-10-15T144122Z.md),
[journal-worktree](../journal/inbox/maintainer/read/watchdog-journal-worktree-fffail-oros-studio-garden-ce242c49.md),
and [worker CLI](../journal/inbox/maintainer/read/watchdog-worker-agent-bin-monk-oros-studio-garden-ce242c49.2026-10-15T050150Z.md)
signatures and recoveries. Leader cases come from [root-repo-guard](root-repo-guard.md),
[deploy operations](../context/operations/deploy.md), and
[leader/follower operations](../context/operations/leader-follower.md): root
corruption, failed garbage collection, frozen timers, singleton duplication,
stale journal worktrees, and marker handoff.

The standing operator baseline is [host operations](../context/operations/host-operations.md),
[health](../context/operations/health.md), [deploy](../context/operations/deploy.md),
[leader/follower](../context/operations/leader-follower.md), and
[scaling](../context/operations/scaling.md). The role reuses
[restore](../skills/restore/SKILL.md),
[self-healing-wrapper](../skills/self-healing-wrapper/SKILL.md), and
[host-disposition-report](../skills/host-disposition-report/SKILL.md) rather than
copying their procedures.

The same-day `unblock-oros-canary-drain-20261104` repair had not reported when
this design was written. Its dispatch is a useful example of controller mode,
but its eventual conclusion must be read from its settled tada report rather
than inferred here.

## Ownership map

| Boundary | Mechanism owner | Policy owner | Durable state | Lifecycle authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| watchdog or maintainer -> mechanic | producer or liaison posts a job | mechanic dispatch rules | job board and triggering notice | producer posts; gardener claims | target, trigger, evidence, mode |
| mechanic -> target | deterministic sysop executes its closed vocabulary | mechanic chooses a documented rung | `sysop-log/<host>/`, ack, host-local unit state | sysop accepts or refuses | one structured host op |
| mechanic -> maintainer | message bus carries an attestation request | maintainer decides destructive intent | mechanic inbox and maintainer allowlist | maintainer supplies or declines exact op | exact op, arguments, evidence, risk |
| mechanic -> next mechanic | host health record and tada report | mechanic report contract | `projects/garden/host-health/<host>.md` | mechanic appends through the journal lander | before/after evidence and remaining condition |

The journal owns persistent evidence; the sysop owns execution and replay; the
mechanic owns diagnosis; the maintainer owns destructive attestation, leadership
handoff, and rollback decisions. The owning deploy or handoff decides commit,
abort, and drain release. A resumed mechanic reconstructs from durable records.
`mechanic` is the outer policy role; `sysop` remains the inner deterministic
mechanism and is not made claimable.

## Diagnose in this order

Stop as soon as the evidence separates healthy, degraded, offline, and
operator-held states. Do not start by restarting units.

1. **Durable health record.** Read, with timestamps, the target's latest
   `projects/garden/host-health/<host>.md` entry (and the legacy oros log),
   `fleet/health/<host>`, each `budget/live/*/<host>` heartbeat, the host record,
   drain marker, `worker-derotate/<host>`, deploy release and roll status,
   deployed SHA versus `origin/main2`, relevant watchdog notice, and the
   deterministic [host disposition report](../skills/host-disposition-report/SKILL.md).
   A fresh heartbeat is presence, not proof that workers claim and complete.
2. **Sysop audit trail.** Read the newest `sysop-log/<host>/` records and acks.
   Distinguish no op sent, applied, refused, failed, and no arrival within two
   ticks. A stale log is not an outage when no op was sent.
3. **Unit and journal logs.** In local mode, inspect failed `garden-*` units and
   the narrow journal window. In controller mode, use committed self-heal
   captures and watchdog details. If neither exists, request local inspection.
   The known alternative when `journalctl --user` lacks access is the persistent
   journal under `/var/log/journal`; report permission failure rather than
   bypassing it.
4. **Load, disk, and locks.** Check load, memory, swap, byte and inode headroom,
   recent reboot, `journal-contention-probe.sh`, clone pack and garbage counts,
   `rc=124`, busy markers, and lock holder liveness. Age alone does not prove a
   stale lock. Never run git in the deployed root.

## Failure shapes and known responses

| Shape | Evidence signature | Known response |
| --- | --- | --- |
| Host offline | heartbeat older than the offline threshold, no recent journal activity, and a sent benign op has neither sysop record nor ack | Stop remote mutation. Preserve derotation and drain state; ask for a person to wake Docker, the VM, or the machine. Resume only after heartbeat and sysop both recover. |
| Heartbeat stale, host present | scaler timer active; journal CAS warnings or slow scan; sysop still acks | `refresh-budget-snapshot` first. Use `reset-failed` only for failed units. The 2026-10-01 fix measures before a fresh push and reuses the reading on CAS retry. |
| Offline derotation | two offline observations, `worker-derotate/<host>`, leveling caps at `0 0` | Let derotation automation restore the exact saved values after heartbeat and sysop recovery. Do not invent counts or adopt an operator zero. |
| Worker CLI missing | `FATAL: <agent> not on PATH` and `worker-agent-bin-*`; workers park before claiming | Compare the user-manager environment with the known binary candidates and deployed version. Recovery closes the notice and un-parks workers. A unit restart or deploy needs attestation; do not rewrite PATH by guess. |
| Stale or active drain | drain marker owner and reason; deploy process and `in-progress`; roll status; sysop drain op order | Apply the drain rules below. An old timestamp alone is insufficient. |
| Canary stuck or failed | release SHA differs from deployed SHA; `roll-drained`, `deferred`, or failed validation; gate `rc=124`; long busy marker; cold clone latency | Separate candidate failure from host load, gate timeout, quiescence, or probe transport. Preserve a failed-canary drain. Never advance the leader or roll back automatically. |
| Journal contention or clone bloat | lock give-ups, slow-fetch watchdogs, pack threshold, `gc.log`, repeated `rc=124`, virtiofs reset/checkout latency | Prefer the existing contention watcher, namespace clone repair, geometric repack, and hot-clone paths. A confirmed stale root gc lock or root maintenance requires attested `maintain`. Missing objects or ref deletion stop for a human. |
| Journal worktree stale or divergent | `journal-worktree-fffail`, clean non-ahead tree that did not fast-forward, or local-ahead/dirty status | Leave it untouched. The keeper may retry a clean case. Dirty, ahead, or divergent state needs deliberate reconciliation; never reset or rebase it from the mechanic job. |
| Root repository corruption | root guard reports wrong origin, attached or non-main2 HEAD, missing objects, garbage packs, or low inodes | Let `garden-root-repo-guard` perform its lossless repairs. Never run git there. Use attested `maintain` only for the guard's confirmed stale-maintenance case; never drop refs or history. |
| Stuck leader deploy | `deploy/in-progress` or `frozen-timers` with no live deploy; rejected-candidate marker; leader remains drained | Use `deploy-strand-recover.sh` only through the owning local recovery path. A new deploy is attested. Preserve an inherited operator drain. No automatic rollback. |
| Singleton duplicate or missing | leader marker disagrees with the host, a leader-only service runs on two hosts, or all future activations skip on the named leader | Stop before changing the marker. Follow the confirmed handoff: outgoing liaison Monitors down, confirmation, marker move, incoming Monitors up. Unit changes require attestation. |
| Host-specific credential refusal | exact GitHub review-write refusal and a live owner exclusion marker, while other host work succeeds | Route affected stages away from the host. Ask the maintainer to repair token permission. Repeated restarts do not repair authorization. |

## Operation ladder

For each rung: record the precondition, send one op, wait for its sysop record
and ack, then re-read the failing signal.

1. **Observe only.** Identify the state owner. A no-op diagnosis may be complete.
2. **`reset-failed`.** Use only when one or more `garden-*` units are actually
   failed. It clears systemd failure accounting, not the cause.
3. **`refresh-budget-snapshot`.** Use with the exact pool when the host is
   present but its budget heartbeat is stale.
4. **`restore`.** Use for a demonstrated provider, quota, or network outage. On a
   follower it skips leader-only reaper and deadmail work. Doom triage remains a
   liaison decision.
5. **`drain on` or `drain off`.** Contain or quiesce; lift only under the rules below.
6. **`set-workers`.** Never use on the leader. On a follower, use it only when
   the maintainer supplied the exact count. Use drain for temporary quiet. Never
   change a pool ceiling or infer a count.

The next rungs are a hard attestation wall:

- `unit`: exact action and installed `garden-*` unit, justified by its log.
- `deploy`: the hardened deploy path only, justified by candidate and quiescence
  evidence. A release token or drain is not authorization.
- `local-model`: the host's reviewed resolved default only, with disk evidence.
- `maintain`: only a confirmed stale gc lock or root maintenance condition.

The mechanic cannot create `authorized_by`. If a destructive rung is needed, it
sends the maintainer the exact target, op, arguments, evidence, effect, and stop
condition. It relays only an explicit attestation and waits for the terminal ack.

## Drain rules

Drain ownership comes from its marker and surrounding state, not from age.

- A live `deploy-garden.sh`, rolling deploy, leadership handoff, or operator owns
  its drain. Only that workflow lifts it.
- A failed canary stays drained until it passes or the maintainer explicitly
  chooses to run the old SHA. The mechanic does not clear the halt, advance the
  leader, or roll back.
- A dead deploy is recovered by `deploy-strand-recover.sh`. It lifts only a drain
  the dead deploy engaged and preserves an inherited operator drain.
- A mechanic may lift a **roll-induced** drain only after proving no deploy is
  live, the marker is roll-owned, and the canary passes or the old SHA is
  explicitly safe. It then confirms claim/completion and advancing fleet health.
- A maintainer or operator drain is never lifted without that owner's explicit
  direction. On the leader, any ambiguous drain is preserved.

## Recurring jobs

Keep the two oros schedules for continuity but replace their long prompts with
thin mechanic dispatches:

- `oros-health-checkup-*`: `role: mechanic`, `mode: local`,
  `target_host: oros-studio-garden-ce242c49`, still pinned to oros. It performs a
  15-minute inspection, appends one standard host-health record, and exits early
  when a roll release or drain would make the check-up obstruct the deploy.
- `oros-health-watch-*`: `role: mechanic`, `mode: controller`, same target, pinned
  to the leader and staggered after the check-up. It checks whether the local run
  completed, then follows the same diagnose order and operation ladder. It does
  not carry its own repair policy.

The scheduler executes the controller watch deterministically before considering
an LLM dispatch. It reads the prior paired check-up completion plus the bounded
fleet-health, roll, latest sysop, and host records, then replaces
`projects/garden/controller-health/<host>.md` with one compact disposition. A
healthy prior pair, or a prior pair that is still pending, closes the controller
cycle without a worker. Only settled evidence that needs diagnosis or an
attested repair falls through to a mechanic job, with the deterministic
disposition prepended as evidence.

Each schedule body contains only the four dispatch fields, recurrence budget, and
a link to `roles/mechanic/AGENT.md`. Existing history stays. New records go to
`journal2:projects/garden/host-health/oros-studio-garden-ce242c49.md`, whose first
entry links back to `oros-health-log.md`.

Other hosts use two modes only when local inspection adds evidence. Watchdog and
maintainer repairs are normally one controller job, deduplicated by target and
condition key while open.

## Report and learning record

The completion report and the newest-first host-health entry share this compact
shape:

```markdown
## <UTC timestamp> - <job base>

- Verdict: healthy | degraded | unhealthy | operator-held | unreachable
- Target / role / mode: <GARDEN> / leader|follower / controller|local
- Trigger: <watchdog key, schedule, or maintainer request>
- Evidence: <health record times, sysop msgids/outcomes, narrow log citations>
- Cause: <established cause, or unknown with what is missing>
- Actions: <ops with acks and code commits, or none>
- Final state: <heartbeat, units, deployed SHA, drain, workers claiming/completing>
- Maintainer: <exact requested decision or "none">
- Next mechanic: <remaining condition, owner, and first evidence to check>
```

Record every attempted op, including refusals and missing acks. A fresh heartbeat
alone is not healthy. Include the failing signal and its after-state. Land the
health record with `land-journal-edit.sh`, never through the live worktree.

## Hard limits

- No ferry, credential move, identity switch, or `identity_switch_authorized`.
- No worker-count change or pool-ceiling change on the leader. No follower count
  change without an exact maintainer-supplied value.
- No automatic rollback and no clearing a rejected-candidate marker to force the
  same SHA. Diagnose, hold, fix forward, or ask.
- No direct git command in the deployed root or live journal worktree. No ref or
  history deletion.
- No leader-marker change without the explicit, confirmed handoff procedure.
- No arbitrary shell through the sysop, no invented operation, and no guessed
  `authorized_by`.

## First-draft role outline

The builder should keep the role short and put the procedure in a new
`skills/host-repair/SKILL.md`:

```markdown
---
created: 2026-11-04
updated: 2026-11-04
author: gardener
---

# Role: mechanic

Purpose: diagnose and repair one garden host without crossing the sysop or
maintainer authority boundaries.

## Skills

- [host-repair](../../skills/host-repair/SKILL.md)
- [host-disposition-report](../../skills/host-disposition-report/SKILL.md)
- [restore](../../skills/restore/SKILL.md)
- [self-healing-wrapper](../../skills/self-healing-wrapper/SKILL.md)

## Operating norms

- Confirm target, leader/follower role, trigger, and controller/local mode.
- Diagnose in the skill's fixed evidence order; mutate one op rung at a time.
- Stop at the attestation wall and ask for the exact destructive op.
- Preserve drain ownership and all hard limits.
- Append the standard host-health record and report before/after evidence.

## Definition of done

The failing signal cleared and the target resumed its intended posture, or the
host is safely held with one exact maintainer or person-at-machine action named.
```

## Build cut

The first builder should:

1. add `roles/mechanic/AGENT.md` and `skills/host-repair/SKILL.md` from this
   design, register the role at mentor tier, and update the role inventory;
2. rewrite the two oros schedule bodies as the thin mechanic dispatches above,
   without changing their cadence, target, or standing 90 percent quota policy;
3. seed `projects/garden/host-health/oros-studio-garden-ce242c49.md` with a link to
   the legacy log and the report template;
4. add deterministic checks that the mechanic role is postable, its skill names
   every sysop op and attestation boundary exactly, and the two schedule prompts
   no longer contain independent repair policy.

No new sysop operation is required for this first build. If controller evidence
cannot establish a cause, the mechanic dispatches a local mechanic or asks for a
person at the machine instead of smuggling remote shell into the sysop.
