I've landed the fix on main2 as commit `4be1ea24ac2`. New journal clones now come from the host's own root repo instead of GitHub, a stale clone gets re-seeded locally when its capped fetch fails, and `follow-up.sh` keeps its seen position on the journal so a leadership change can't replay the old backlog. The new tests pass; I didn't run the large `run-test.sh` suite.

**Journal clones (`scripts/jobs/common.sh`)**
- **New clones:** `reclone_clone` now sets up the clone and does a shallow `file://` fetch (depth 50) of `refs/remotes/origin/journal2` from `$GARDEN_ROOT/.git`. That is the same recipe the liaison used by hand, and no network is touched. It only reads the root's remote-tracking ref, never the journal worktree's local branch, which can hold unpushed commits. If no seed is possible it falls back to the old network clone.
- **Only matching clones are seeded:** a clone is seeded only if its origin is the same repo as the root's origin. Without that check, an existing test (`budget-snapshot-outage-reclone-test`) pulled the real production journal into a test clone. That test passes again.
- **Shallow clones get filled in:** some readers walk journal history (`auction.sh`, `reputation.sh`, `assert-followup-posted.sh`), and a depth-50 clone would give them wrong answers. So after a clone's first successful sync, `sync_clone` completes its history from the root, locally. If that fails, the clone stays usable and shallow until a later tick.
- **Stale clones:** when the capped fetch fails, `sync_clone` advances the clone's ref from the root and retries the network once, so the retry only carries the few minutes the root lags GitHub. It never rewinds a clone that is ahead of the root. On a clone that is already up to date, a real outage still exits offline (rc=75) after one cheap local check.
- **`tmp_pack_*` leftovers:** these are swept on every fetch attempt. Files older than any bounded transfer are always removed, and a timed-out attempt removes its own right away. The journal worktree shares the root repo, and the sweep never touches that repo's pack directory.
- **Old `kriskowal/garden` URL:** new clones get the canonical `kriscendobot/garden` URL instead, with one WARN per episode. I did not change any host's root origin URL; that still needs to be done on hosts where it names the old repo.

**`follow-up.sh` seen-marker**
- Every time the marker advances, it now also writes a journal cursor (`cursors/follow-up/seen`) recording the host, the time, and the journal commit whose reports are all seen.
- If the local marker is more than 30 minutes old, the tick checks that cursor first. If another host wrote it more recently, every report in that commit is marked seen. If there is no cursor, or its commit can't be read on this host, the stale marker is treated as a cold start. A journal outage skips the tick and leaves the marker stale, so it is checked again next tick.
- A missing marker is still a plain cold start, as before.

**Tests**
- New `scripts/jobs/test/journal-clone-seed-from-root-test.sh` (11 checks) and `scripts/jobs/test/follow-up-seen-cursor-test.sh` (6 checks): all pass.
- Existing `sync-clone-reset-retry-test`, `clone-keeper-test` and `budget-snapshot-outage-reclone-test` pass.

**Follow-ups**
- Hosts only pick this up when they deploy. The seen cursor first appears when the current leader's follow-up next marks something seen. Until then, a host promoted with a stale marker will cold-start, which skips rather than replays.
- If a cursor write fails, it logs a WARN rather than failing the tick. A leadership change before the next successful write could then replay reports seen since the last one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-journal-clone-seed-from-local-root-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5142376 cached reads)
- Output: 52711 tokens
- Cost: $3.3282551999999996
- Wall-clock: 922s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
