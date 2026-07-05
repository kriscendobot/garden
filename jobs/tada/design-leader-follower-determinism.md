The work was already complete before the requeue: the interruption fell between the push and the completion signal being recorded. Verified now that the deliverable is live on `main2` (tip commit), the worktree is clean, and the inbox is empty. Nothing remained to do.

## Completion report: design-leader-follower-determinism

**Deliverable:** `designs/leader-follower-determinism.md`, landed directly on `main2` at commit `593a15418` (verified present as the current `origin/main2` tip). A supersession pointer was added to `designs/multibot-leader-follower.md`, which remains authoritative for which services are singletons versus per-host local-infra.

**What the design specifies:**

- **Failure inventory.** Seven concrete sources of the observed flapping: the bare-name `leader` marker, the instant-for-new but TTL-lazy-for-old re-point (a structural two-leader overlap on every handoff), the prose-only handoff ceremony, the fail-open predicate default, the never-expiring stale-cache fallback, the by-documentation-only liaison Monitor singleton, and the needless coupling of handoff to gardener draining.
- **Journal state shape.** The `leader` file becomes a structured record (state `stable` or `handoff`, a monotonic epoch, a per-epoch `bound_instance`), line-1 compatible with the legacy reader so rollout and rollback need no flag day. A separate slow-cadence `leader-heartbeat` file carries the leader's instance identity. All writes are CAS pushes to `origin/journal2`.
- **The state machine.** Two fleet states, five derived host roles (follower, becoming-leader, leader, stepping-down, duplicate), eight transitions. A handoff means zero leaders everywhere; the release to `stable` is written only by the outgoing leader's own deterministic sentinel after a positive quiesce: delete the predicate cache, wait for every leader-only unit to be inactive (systemd's `activating` state closes the condition-passed-but-not-started race), synchronously stop and restart the bulletin. The safety argument shows no two-leader instant with no cross-host clock assumptions; the only weakened path is the maintainer's explicit `--force`, bounded to one TTL and then detected.
- **Instance identity and split-brain detection.** The maintainer's build-time UUID suggestion is evaluated and refined to creation time: a UUID seeded by the `garden` launcher into gitignored `$GARDEN_ROOT/.garden-instance` (mirroring `.garden`), with a self-minting `common.sh` fallback for non-docker hosts. The CAS epoch bind is both detector and resolver: two instances sharing a `GARDEN` name race the bind, exactly one wins, the loser deterministically stays follower and posts a deduplicated `kind: error` maintainer report. A heartbeat cross-check catches writers that bypass the bind.
- **Hardened predicate.** Leader only on a fresh read of `stable`, named, and bound to this instance; handoff answers follower everywhere; a stale cache may never answer leader; the default flips to fail-closed with a bootstrap auto-designation preserving single-host bring-up.
- **Service participation and rollback.** Every leader-only unit, both in-process gates (bulletin, watchman broadcast), all three liaison Monitors, and the new every-host `garden-leader-sentinel` are enumerated; the maintainer-inbox Monitor becomes self-gating. Kill and rollback criteria are named, resting on the line-1 compatibility lever.

**Proposed staged build plan** (serial orchestration per `skills/orchestration/SKILL.md`, halt on child failure; each child sized to one handler wall):

1. `leader-instance-identity` (mint and seed `.garden-instance`)
2. `leader-record-v2-writer` (`set-main-host.sh` structured record, handoff/force/abort verbs)
3. `leader-predicate-v2` (verdict table, tuple cache, fail-closed; ships dark behind `GARDEN_LEADER_V2`)
4. `leader-sentinel-bind-heartbeat-detect` (bind, heartbeat, duplicate detectors; arms the flag)
5. `leader-sentinel-stepdown` (quiesce and release)
6. `leader-monitor-self-gating` (`leader-role.sh`, gated `maintainer-watch.sh`, liaison vocabulary rewrite)
7. `leader-docs-and-runbook` (CLAUDE.md, runbook, drift-guard wording)
8. `leader-handoff-rehearsal` (two-pool acceptance rehearsal, the gate for flipping the design Status to Implemented)

**Follow-ups:** the liaison should orchestrate the plan once the maintainer accepts the design; no handoff should be initiated with the new verbs until stage 4 has armed `GARDEN_LEADER_V2` fleet-wide.
