---
role: journalist
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Document the garden's control surfaces: the levers and their real semantics

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR.
Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

## What is missing

`README § 2. Control surfaces` documents the **planes of access** — "five
planes, one job board", organised by where the maintainer is standing (liaison
CLI, GitHub issues, …). `context/control-surface-gallery.md` narrates ~40 worked
examples. `context/operations/` holds procedures.

None of them documents the **semantics of the levers themselves**: what a lever
does *not* do, what it silently fails to reach, and which pairs of levers
interact. A maintainer steering the fleet in August 2026 hit a series of these
the hard way. Each is a real, reproducible property of the code — not an
anecdote — and none is written down.

Audit each claim below **against the code** before documenting it; correct me
where I am wrong and say so in your report. Then put each in the right home per
the existing contract: reference → `README`, worked example → the gallery,
procedure → `context/operations/`, rationale → `designs/`.

## The gaps, with their evidence

**1. `gate: go-ahead` is never auto-promoted.** The foreman batch-promotes only
`gate: deferred` (`foreman.sh` ~line 33, 227). A `go-ahead` job is *authorized*
but never *scheduled* — it waits for an explicit `promote-plan.sh` that nothing
issues on its own. Consequence: `deploy-siwe-thunk-minion-town` sat parked from
2026-07-07 to 2026-08-05 while the maintainer believed minion.town was blocked
on AWS credentials. It was not; nobody had promoted it. `grep -c go-ahead
context/operations/*.md` returns **zero across every operations page**. This is
the single most expensive undocumented behaviour found; lead with it.

**2. "Drained" means "will not claim", not "will not produce".** `fleet_draining`
gates ~25 call sites, but **`scheduler.sh`, `repo-watcher.sh`, and
`self-heal-run.sh` carry no drain guard**. A drained host can still mint work.
Verify the current set yourself (`grep -rn fleet_draining scripts/jobs/*.sh`) —
do not copy my list without checking.

**3. Leader-only services are dark on a drained leader — including the ones you
may still want.** `garden-orchestrate.service` carries
`ExecCondition=is-main-host.sh` **and** `orchestrate.sh:66` is
`fleet_draining && exit 0`. Draining the leader to silence the foreman also
silences the orchestrate watcher, the scheduler, and the watchers. The
`garden-budget-attribution` chain (5 children) had to be promoted **by hand,
child by child**, for exactly this reason. A **foreman-specific brake** is
landing concurrently (job `garden-foreman-independent-brake`) to decouple this —
check whether it has landed and document the resulting semantics; if it has not,
document the coupling as current and note the pending change.

**4. `set-workers.sh` refuses cross-host writes by design** ("the optional host
must be this host"). Changing another host's worker counts requires the **sysop**
(`send-host-op.sh <GARDEN> op=set-workers kind=… count=…`). This is the
unattended-follower path and it works — but it is not discoverable from the
script's own usage line.

**5. The sysop issuer gate REPLACES its default when non-empty.**
`config/sysop-issuers` defaults to *the leader alone* when absent or empty
(`sysop.sh` `load_issuers`). Writing a single host into that file **silently
strips the leader's own ability to issue ops**. Anyone editing it must list
every intended issuer including the leader. This is a live foot-gun.

**6. Two sysop tiers.** `set-workers`, `drain`, `reset-failed`, `restore` are
non-destructive. `unit`, `deploy`, `local-model` additionally require maintainer
attestation — `authorized_by: <login>` on `maintainers/allowlist` — which **no
agent may originate**. Document that an agent asking for a redeploy of another
host is not the same artifact as an attestation, and what the maintainer must
send.

**7. An aborted deploy can strand the drain marker.** On 2026-08-02 a deploy
engaged its own drain, hit the 600 s `GARDEN_DEPLOY_DRAIN_TIMEOUT` against a
10800 s job, and aborted **without lifting the marker**. The fleet then sat
silently drained — gardeners exiting cleanly every tick, one unit already dead —
with no deploy process alive. Detection: marker present **and** no
`deploy-garden` process. Recovery: `drain-fleet.sh off` then
`gardener-scaler.sh`. Document the check; an operator who does not know it reads
a stalled fleet as an outage.

**8. The deploy drain timeout cannot outlast build budgets.**
`GARDEN_DEPLOY_DRAIN_TIMEOUT` is 600 s; build jobs legitimately declare 7200 s
or 10800 s `handler-timeout:`. A deploy also DEFERs when any worker has been
mid-job longer than `GARDEN_DEPLOY_LONG_JOB_THRESHOLD` (300 s), which on a busy
pool is almost always. **The working procedure is to pre-drain by hand, wait for
quiescence, then deploy** — `deploy-garden.sh` skips its defer check when the
fleet is already draining (`if ! fleet_draining`) and proceeds immediately. That
is the only reliable way to land a deploy on a busy fleet and it is written
nowhere.

**9. `set-workers gardeners=0` is refused.** Guards require retaining one
gardener or a probe-qualified non-Claude worker class; the error names
`drain-fleet.sh` as the correct tool. Document drain-vs-zero: a drain is a
moratorium on *claiming*, a zero count is a statement about *capacity*.

**10. Pausing a schedule is a `git mv` to `paused-schedules/`.** The scheduler
enumerates `schedules/` only. There are currently 29 paused. Restoring is the
reverse move. Document the mechanism and the restore path.

## How to do it

- **Audit before you write.** Every claim above is falsifiable against the code.
  Anything you cannot confirm, drop or correct — and say which in your report.
- **Respect the existing contract.** The gallery holds no procedure; operations
  holds no rationale. Do not duplicate content across all four homes — link.
- **Prefer a table of levers** in the reference: lever → what it does → what it
  does **not** reach → the interacting lever to check. The "does not reach"
  column is the part that does not exist today and is where all the pain was.
- **Do not invent policy.** You are documenting behaviour, not proposing
  changes. If a behaviour looks like a defect (e.g. #5's silent leader-strip),
  document it as it is and note it; file nothing.

## Definition of done

Documentation landed on `main2`; each of the ten claims either documented with
its code reference or explicitly refuted in the `tada/` report; the
foreman-brake status (landed or pending) reflected; no duplication across homes;
and a report naming which claims you had to correct and any further
control-surface gap you found while auditing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-05T15:00:48Z
