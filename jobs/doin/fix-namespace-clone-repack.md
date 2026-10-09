---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: per-namespace journal clones (.garden-state/<ns>/journal) are never repacked; pack and tmp_pack buildup wedges the host

Repo: kriscendobot/garden, branch main2 (direct push, no PR).

## What happened (host oros-studio-garden-ce242c49, measured 2026-10-08)
| clone | packs | tmp_pack_* | .git size |
|---|---|---|---|
| leader/journal | 6,239 | 14,832 | 2.9 GB |
| sysop/journal | 2,192 | 222 | 11 GB |
| repo-watcher/journal | 1,043 | 141 | 9.0 GB |
| unblock/journal | 180 | 17 | 1.5 GB |
| fork-watch/journal | 78 | 0 | 293 MB |

Interrupted or timed-out fetches leave `tmp_pack_*` files behind, and nothing ever runs gc or repack on these clones. On the leader clone, `git show origin/journal2:leader` took 57 s at 1% CPU. About 100 leader-gated units run `is-main-host.sh`, which does that read, as their ExecCondition. The result: ~100 units stuck in `activating`, load 20–45, every journal fetch past the 45 s bound, the heartbeat stalling, sysop ticks timing out, and deploy candidate-gate suites timing out (rc=124). It looked like a network outage, but a root-repo fetch took 2 s throughout.

The manual fix was to delete tmp_* files older than 1 day, then run `nice ionice -c3 git repack -a -d` per clone. Results: 6,239 packs → 26, 2.9 GB → 349 MB, the leader read 57 s → 0.075 s, fetches 1.5–3.3 s, load about 4. About 23 GB was freed across the five clones. fsck was clean on all of them.

## Wanted
1. A periodic, jittered maintenance pass over every $GARDEN_STATE/*/journal clone, in the clone keeper or root-repo-guard. It should prune tmp_* older than a few hours and repack when the pack count exceeds a threshold (say 50). Run it at low CPU and I/O priority and serialize it against that clone's lock.
2. Make `is-main-host.sh` cheap and robust. For example, read the leader marker from a small cached file refreshed by a single timer, instead of a git read per ExecCondition.
3. Raise an alert (watchdog-notice) when any namespace clone exceeds the threshold.

Related: the existing memory/notes on the 45 s clone livelock (reclone_clone without --depth 1).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T00:27:35Z
