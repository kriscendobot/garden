from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T05:44:14Z
doom_base: upgrade-fleet-to-main2-uniform-20260918
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T05:44:14Z
last_seen: 2026-09-18T05:44:14Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/upgrade-fleet-to-main2-uniform-20260918; it stays HELD until a human promotes it
(promote-plan.sh upgrade-fleet-to-main2-uniform-20260918) or removes it, so nothing is lost.
Original job base: upgrade-fleet-to-main2-uniform-20260918

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: orchestrator
handler-timeout: 10800
---
Drive every garden host onto the latest `main2`, verifying after each one that its
drain closed and work actually resumed — looping on the deploy until the fleet is
uniformly current. MAINTAINER DIRECTIVE (kriskowal, in-session 2026-09-18).

## Why this is ONE looping orchestrator job, not a parked child set

The standing multi-part pattern is parked children plus `post-orchestration.sh`.
That is the wrong tool here: the set of lagging hosts and the number of passes are
BOTH unknown in advance, and `main2` keeps moving while you work. A fixed child
list cannot express "repeat until uniform." So drive the loop yourself, and use
`post-job.sh` for any remediation you need to delegate.

## State at posting time (2026-09-18, re-derive it — do not trust this)

    main2 tip                        11082b7924 "docs(pause): sync IronHorse pause prose to LIFTED"
    endolin-garden-ece02cb4 (leader) 425cf9877a  behind 1  deployed  0 failures
    endolin-garden2-5bcdff64         11082b7924  behind 0  deployed  0 failures
    oros-studio-garden-ce242c49      425cf9877a  behind 1  deployed  0 failures

Read each host's lag from `fleet/health/<host>` on `journal2` against
`origin/main2`; that is the authoritative view from any host.

## The loop

Each pass:
1. PIN A TARGET. Resolve `origin/main2` HEAD once and treat THAT sha as the pass's
   target. `main2` advances continuously (the fleet lands commits all day), so
   "latest" is a moving goalpost — chasing it live never terminates. Converge to the
   pinned target, then re-evaluate.
2. ENUMERATE laggards against the pinned target.
3. DEPLOY each laggard (ordering below).
4. VERIFY each one positively (below).
5. Re-derive lag. If the fleet is uniform at the pinned target, or every remaining
   gap is only commits that landed DURING this pass, you are done — say so and stop.
   Do not spin chasing new commits.

STOP CONDITIONS — do not grind:
- Uniform at the pinned target → done.
- The same host fails the same way twice → stop looping on it, and report.
- 5 passes without convergence → stop and escalate to the maintainer inbox with
  exactly what is stuck and why.

## Ordering — respect the rolling deploy, do not race it

An autonomous leader-orchestrated rolling deploy already exists
(`designs/follower-self-deploy.md`): followers roll FIRST as canaries, the leader
validates each, and the leader advances ITSELF LAST, never on a failed canary.
Preserve that order — followers first, leader last — and prefer letting the
autonomous roll do the work where it is already moving. Intervene where it is
STUCK. If you observe the roll actively progressing a host, watch rather than
duplicate; two deploy drivers on one host is a way to wedge it.

## HOW to deploy a host — this is the part that traps people

A host-pinned job (`requires: host=<GARDEN>`) CANNOT deploy a drained or stuck
host: a drained host CLAIMS NOTHING, so the job sits unclaimed forever. The
condition you are trying to fix is the one preventing the fix. This was observed
directly on 2026-09-17 (`calibrate-oros-studio-budget-pool-20260917` sat unclaimed
934s and tripped the unclaimable-host watchdog).

So:
- Host you are ON: run `scripts/jobs/deploy-garden.sh` directly.
- ANY OTHER host: use the sysop, which ticks even under drain and is the designed
  tool for an unattended host:
      scripts/jobs/send-host-op.sh <GARDEN> op=deploy authorized_by=kriskowal
  `deploy` is a DESTRUCTIVE-tier op and REQUIRES that attestation; kriskowal is on
  `maintainers/allowlist` and authorized this in-session on 2026-09-18. Do not
  invent an attestation for anything this job does not cover.
  You may pass `to_sha=<40-hex>`, but ONLY the current `origin/main2` HEAD — the op
  REFUSES a stale `to_sha`. Omit it if you are unsure.
- `deploy` is SELF-RESTARTING: the sysop acks "deploy started" BEFORE invoking
  `deploy-garden.sh`, because the deploy restarts the fleet including the sysop
  itself. So an ack means STARTED, NOT FINISHED. Confirm completion from
  `fleet/health/<host>`'s `deployed_sha`, never from the ack.

## VERIFY — positively, which is the substance of this job

For each host, after its deploy:
1. `deployed_sha` in `fleet/health/<host>` equals the target.
2. `unit_failures: 0`.
3. THE DRAIN CLOSED. `deploy-garden.sh` lifts its own drain on the success and
   self-abort paths, but a drain it did NOT engage — an operator `stand down`, or a
   hard kill before its lift — survives the deploy. A stale draining marker makes
   every gardener exit cleanly: zero failed units and zero gardeners running. So
   check `roll_status` is not a drained state.
4. WORK ACTUALLY RESUMED. An empty `--state=failed` list is NOT proof, and neither
   is a clean health record. Confirm the host is CLAIMING: look for fresh
   `claim(...)` entries by that host in the journal log after its deploy. That is
   the only positive evidence.

If the drain did not close, read its PROVENANCE before touching it. Since
`845b1895e2` the marker carries `source:`, and `drain_is_roll_induced` distinguishes
a roll drain from an operator pause, FAILING SAFE toward operator when the source is
absent or unknown. Clear a ROLL-INDUCED drain (`send-host-op.sh <GARDEN> op=drain
state=off`). NEVER clear an operator drain on your own judgment — report it and ask.
Note a marker written before that commit has no `source:` and therefore reads as an
operator drain forever; if you find one, say so plainly rather than overriding it.

## Report

Per host: starting sha, target sha, how it was deployed, final sha, drain state,
and the positive evidence that it resumed claiming. Then the fleet's final
uniformity. Name anything you deliberately did not touch and why.
