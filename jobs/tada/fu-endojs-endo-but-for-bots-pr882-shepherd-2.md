Investigation complete, fix landed.

## Findings

**The `garden-reaped: 4` was not shepherd overrun and not worker death — it was a silent classifier failure caused by a missing shell function.**

### Timeline (journal `journal2` history)

| Time (UTC) | Event | Held |
|---|---|---|
| 07-28 12:52:34 | posted to `todo` | |
| 12:52:39 → 16:53:05 | claim `endolin-garden2/g1` → **silent full-4h-TTL reap** | 4h00m |
| 16:54:04 → 17:03:06 | claim `endolin-garden2/g4` → reap-now hint at 16:57:59 (genuine transient) | 9m |
| 17:03:12 → 21:13:06 | claim `ps23-garden/g3` → **silent full-TTL reap** | 4h10m |
| 21:13:22 → 07-29 01:23:07 | claim `ps23-garden/g8` → **silent full-TTL reap** | 4h10m |
| 01:23:23 → 01:25:17 | claim `endolin-garden/g3` → **done in 114s** | |

Three of four cycles carried no `reap-now` hint and no `deadline-overrun` hint, and expired at exactly `GARDEN_CLAIM_TTL`.

### Mechanism

`scripts/jobs/gardener.sh:943` calls `is_explicit_cap_signature`, which `a0cd3eae13` (2026-07-21, the `journal_remote` foreign-origin guard) deleted from `common.sh` from a stale base, along with six other helpers. An undefined function under `if` is not an error in bash — it prints `command not found`, returns 127, and the branch simply reads **false**. So the min-plausible-overrun floor's exemption for an explicit session/usage-cap wording silently vanished, and every fast-dying capped handler was reclassified a *deterministic defect*.

That verdict lands on the real-failure branch, which — unlike the transient branch — escalates a lane-0 `kind:error` and leaves the claim in `doin` **with no reap-now hint**. Hence the full 4h strand per cycle.

Direct evidence from this host's own logs (`gnome-backend-autotune-build`, same shape, same night):

```
21:14:06 handler FAILED (rc=1) …
21:14:06 gardener.sh: line 943: is_explicit_cap_signature: command not found
21:14:06 … died in only 2s … treating as a DETERMINISTIC setup/spec defect,
         escalating as a real failure (transient=0)
```

Matching `kind:error` entries exist for pr882 at 12:53:10Z, 17:03:46Z, 21:13:33Z — one per silent cycle, none for the hinted cycle. Fleet-wide blast radius: **243** such entries across 07-28/29.

### Fix landed — `cd177a8255` on `main2`

`da2572a260` (07-28 15:51Z) already restored the seven helpers. My commit closes the *silence* that let the clobber run for a week: `gardener.sh` now probes with `declare -F` and, when the helper is absent, keeps `transient=1` and logs one line naming the missing function. Transient is the conservative direction — the exemption exists to keep a cap transient, so an exemption that can't be evaluated must not downgrade a job to a 4h strand plus a false defect escalation.

Added `SUBTEST 3` to `claude-session-limit-classifier-test.sh`: reproduces the clobber against the real `gardener.sh` (mirrored `scripts/jobs/` with the function excised) with the floor live.

**Verified by real runs:** classifier 29/29 with the fix; reverting *only* the `gardener.sh` guard reproduces the production log line and fails 3 of the 5 new assertions. Neighbours re-run green: elapsed-constancy 35/35, empty-output-classifier 14/14.

## Still open — needs a deploy, which I can't do

All seven clobbered helpers are **still missing from this host's deployed root**. `endolin-garden` is pinned at `f2184299` (07-28 15:52Z), 34 commits behind. So beyond the classifier, these are also still broken there: `bounded_fetch` (every clone-keeper and root-repo-guard fetch), `tada_failed` (a *declined* blocker silently **satisfies** its dependents in `orchestrate.sh`/`unblock.sh`), and the corrupt-clone self-heal. `ps23-garden` was still emitting these entries at 00:24Z today.

The deploy is stalled, not pending: `garden-upgrade-monitor` has signalled "Upgrade ready" every 5 min for ~10h, `root-repo-deploy-stalled-endolin-garden-ece02cb4` is raised, and `last-deploy.log` ends mid-wait at 18:20:45 ("waiting for 3 mid-job gardener(s) to finish") — consistent with the already-tracked slow-fleet-restart-on-deploy issue. Sent to the maintainer via `message-user.sh` (`20260729T014234Z-cdfa2f`).

One thing I did **not** change, and flag as a judgment call for you: the real-failure branch's *deliberate* omission of a reap-now hint. A 4h backoff is defensible for a genuinely broken job, but it's the amplifier that turned a misclassification into 12.5h of latency — worth revisiting separately rather than folding into this fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr882-shepherd-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (6546526 cached reads)
- Output: 46554 tokens
- Cost: $5.996305000000001
- Wall-clock: 800s

<!-- garden-usage-end -->
