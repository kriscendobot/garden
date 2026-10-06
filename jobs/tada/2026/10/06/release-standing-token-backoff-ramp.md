The ramp is not deployed on any host yet. I handed it to the standing rolling deploy and an approved sysop deploy, and both accepted the work. I did not see any host reach the new commit, so I have no post-deploy `budget-level` result.

**Build commit:** the build report (`jobs/tada/2026/10/06/build-standing-token-backoff-ramp.md`) names `05b29b3e8fa29919ae5024586f91c84e34fc9a08`. That commit is on `origin/main2` and was still its tip at 20:06Z. CI run 37521759764 passed on it.

**Journal changes:** the build report and the design's rollout section assigned these to this job.
- `e47e817f78`: `config/token-backoff-initial` is now `0.50`.
- `387e3df29d`: the old `config/token-backoff-fraction` pin of `1.00` is deleted.
- No `schedules/token-backoff-ramp-*` files were left to remove.
- **Side effect until a host deploys:** hosts still on the old code (`de4f2ee`) now admit at their old default of 0.85 instead of 1.00. After a host deploys, the new code admits less again: about 0.51–0.76 per pool, according to the build's estimate.

**Hand-off to the deploy machinery** (all recorded in the journal):
1. **Release token:** journal commit `78195628a0` (20:05:07Z) points the canary host `endolin-garden-ece02cb4` at `05b29b3e8fa2`. The leader (`endolin-garden2-5bcdff64`, this host) wrote it after its 600s settle wait.
2. **Sysop deploy:** I sent `op=deploy to_sha=05b29b3e8fa29919ae5024586f91c84e34fc9a08 authorized_by=kriskowal` to `endolin-garden-ece02cb4` as message `20261006T200554Z-d58e57`. It logged `accepted-and-applied` / "deploy started" (log commit `eb0955b078`) and acked with `msgs/host/endolin-garden2-5bcdff64/20261006T200610Z-5e0cba`.
3. **Leader:** the leader updates itself last, after the canary passes. Its deploy also has to wait for this busy job to exit before the fleet can go quiet, so I couldn't watch it from inside this session.
4. **Offline host:** `oros-studio-garden-ce242c49` has been offline for about 4.6 days and is still on `e036bb8`. The rollout skips it, and the leader will catch it up when it returns. I didn't queue a sysop op for it because the pinned `to_sha` would likely be refused as stale by then.

**Where each host stood at about 20:15Z:**

| Host | Deployed commit |
| --- | --- |
| `endolin-garden2-5bcdff64` (leader) | `de4f2ee` |
| `endolin-garden-ece02cb4` (canary) | `de4f2ee` |
| `oros-studio-garden-ce242c49` (offline) | `e036bb8` |

**Follow-ups:**
- **The canary has not taken any update since about 18:20Z.** The leader has released it to five successive targets since 18:20Z, and it has not moved. Its health file was last written at 18:04Z, deferring behind a long monk job for an older target (`bc3fbff`). Because that record isn't refreshed, the leader logs the host as "STUCK" instead of "deferred". That may stop the 30-minute quiesce drain from ever firing. The maintainer already has the coalesced notice `watchdog-rolling-deploy-canary-stuck-endolin-garden-ece02cb4` (11 occurrences). Someone should check `journalctl --user -u garden-self-deploy` on that host.
- **After the fleet deploys,** run one `budget-level` tick and confirm every Anthropic pool's reasons show `backoff=…(ramp)`.
- **Not checked:** whether any rendered unit on the other hosts sets `GARDEN_TOKEN_BACKOFF_FRACTION`, which would pin that host and bypass the ramp.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/release-standing-token-backoff-ramp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1950756 cached reads)
- Output: 11105 tokens
- Cost: $1.2497712000000003
- Wall-clock: 916s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
