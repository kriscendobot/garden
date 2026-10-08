Fix round 2 for endojs/endo-but-for-bots PR #258 is pushed and CI is green (16 of 16 checks pass).

**What the panel required:** the round-2 panel (33 seats) asked for changes from three seats: benchmarker, corner-prober and transplanter.

**What changed:** one follow-up commit, `14121e4b25`, on top of `59327bd058`, editing only `.github/workflows/ocapn-guile-interop.yml`. I pushed it with `safe-push-pr-head.sh` in advance mode, so no history was rewritten.
- **Corrupt or empty cache archive:** the extract step now checks the file is non-empty and runs `zstd -t` first. If either check fails it logs a warning and the job carries on as if the cache had missed, instead of failing. A `tar` failure after that check still fails the job on purpose, because a half-extracted `/var/guix/db` isn't safe to run against.
- **Snapshot failures:** the snapshot step no longer fails the job. A failed `guix shell`, `tar`, chown or move just logs a warning and skips the save.
  - The archive is written under a temporary name and renamed only on success.
  - The save step runs only when the snapshot step reports `ready=true`, so a partial archive can't be published.
  - Snapshots over 4 GB are not saved.
  - The save step has `continue-on-error`, so losing a race with a concurrent run doesn't fail the job.
- **Cache key:** it now includes `runner.os` and `runner.arch`. The restore, snapshot and save steps are skipped when `hashFiles` comes back empty. That case had already happened once: the July run saved its cache under the key `guix-store-1.5.0-`.
- **Measurement:** the extract and snapshot steps now log elapsed time and archive size. The comments now say the cache is mainly a resilience measure, not a speed-up.

**PR body:**
- I added a cold-vs-hit timing table built from existing runs: module resolution 14 s cold vs 4 s with a cache hit, Guile host start 49 s vs 23 s. A cache hit costs 2 s to restore the 242 MB archive and 2 s to extract it.
- I added a note that the first commit's message is out of date in two places.
- I cut three filler sections, as the pruner seat suggested.

**CI:** `ci-wait-merge.sh` returned 0. The Guile interop run (37758205167) took the cold path, built a 243 MB snapshot in 15 s and saved it under the new key `guix-store-Linux-X64-1.5.0-87d3bb5f…`.

**Not done:**
- Three lower-priority panel items remain open:
  - The "Wait for Guix daemon" step still only checks that the daemon is active and its socket exists; it doesn't make a real call to the daemon.
  - That step still sits after the snapshot and save steps rather than straight after the extract.
  - Whether `tar` can overwrite the installer's read-only store files on a cache hit is still untested. The next run on this key will take the hit path and show it.
- Cache hit rate and how the cache behaves during a substitute-server outage can only be observed after merge.
- I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1558386 cached reads)
- Output: 12987 tokens
- Cost: $1.1997212000000002
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
