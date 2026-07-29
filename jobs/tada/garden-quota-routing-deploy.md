`orchestration-failed: true`

# garden-quota-routing-deploy — BLOCKED, nothing deployed

Marked `orchestration-failed: true` so `garden-quota-routing-rollout` (serial, `on-child-failure=halt`) halts and surfaces to the maintainer rather than recording a fleet-wide deploy that did not happen. **No host was deployed, drained, or reconfigured. Zero mutations.**

## Preconditions — all verified green
- Child `garden-quota-routing-race` **succeeded**: landed `main2` = `3e5959f9d45b60c02bc3c5d8094ba335dbdc16cb` (auction 63/0, scaler 15/0, suite 368/0). Its `tada/` report only became visible after I fetched fresh — the root's `journal/` worktree was ~8 min stale.
- The revision **does** carry the routing policy: `quota_routing_mode`, `host_has_qualified_non_claude_worker`, plus the scaler and `set-workers` gates.
- Verified against the **new** code on this host: routing mode = `race`; probes **cleric (Codex) = pass, mystic (Kimi K3) = pass, fireworker (Fireworks) = pass**, hermit (local) = fail. So `gardeners: 0` here would be accepted by the new guard.

So the "do not deploy if…" conditions did **not** trigger. The blockers are positional, not qualitative.

## Why this seat cannot execute it
1. **Cross-host — issuer gate.** I run on `endolin-garden-ece02cb4`, a **follower**. `config/sysop-issuers` does not exist on `journal2`, so the issuer set defaults to the leader alone. This host's own sysop log confirms it: `loaded 1 issuer(s) … (empty → defaulted to leader 'endolin-garden2-5bcdff64')`. Every host op I originate would be refused — so `endolin-garden2`, `ps23`, and `ps23-garden-f65473ae` are unreachable from here. I did **not** add myself to the issuer set: that is self-authorizing a trust gate, and this job authorizes deployment, not issuer widening.
2. **Self-host deploy — deadlock by construction.** `deploy-garden.sh` defers when a gardener has been mid-job past `GARDEN_DEPLOY_LONG_JOB_THRESHOLD` (300s). I *am* that gardener.
3. **Self-host zeroing — self-destructive and out of order.** `gardeners: 0` here stops `garden-gardener@*` mid-job, and with the old code still deployed it would zero Claude while the race routing is not yet live, stranding the host. Deploy must precede zeroing.

## Delivered instead
Full blocker + ready-to-run sequence messaged to the maintainer (`20260729T032924Z-4042d7`), to be run from the leader `endolin-garden2-5bcdff64` (the sole issuer, where the liaison sits): `deploy-garden.sh` locally, `send-host-op.sh … op=deploy to_sha=<sha> authorized_by=kriskowal` to the other three, then `op=set-workers kind=gardener count=0` on the two endolin hosts only, ps23 hosts' Claude untouched.

## Three findings the maintainer should decide on before that runs
- **Fireworks capacity is not actually configured** on either endolin host — `hosts/endolin-garden-ece02cb4` has no `fireworkers` line, `hosts/endolin-garden2-5bcdff64` has `fireworkers: 0` — yet the fireworker probe passes here. "Retain Fireworks-backed capacity" cannot hold literally without declaring `fireworkers: N`.
- **Capacity drop:** zeroing this host trades 8 Claude gardeners for clerics:1 + mystics:1. Worth raising non-Claude counts in the same pass.
- **The sysop has never executed an op in this fleet** (`sysop-log/` absent on `journal2`), so the first host op is also that path's first live exercise.

This host is 53 commits behind (`f2184299f4`); no failed units; worktree clean.

**Follow-up:** re-post this job to run **on the leader**, or add a documented mechanism for a follower-claimed job to route fleet ops through the leader — otherwise any gardener claiming a fleet-deploy job hits this same wall and the job requeues indefinitely.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-quota-routing-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1347295 cached reads)
- Output: 30455 tokens
- Cost: $2.2642705
- Wall-clock: 434s

<!-- garden-usage-end -->
