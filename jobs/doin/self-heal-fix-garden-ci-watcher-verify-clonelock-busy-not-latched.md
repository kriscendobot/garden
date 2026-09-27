---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh: ci-watcher.sh's `verify_fetch` (ci-watcher.sh:198) calls `ensure_clone_or_latch_outage "$VERIFY" ci-watcher-verify`, where `$VERIFY` (`$GARDEN_STATE/ci-watcher/verify`) is a SINGLE clone+lock shared by every `garden-ci-watcher@<repo>` instance on the host (~14 template instances here). Live evidence from this incident: `.garden-state/ci-watcher/verify.reclone.2139988.1` was an in-progress `git clone` (reclone_clone's atomic-rename temp dir) while at least 8 sibling instances (finbot, endo, moddable, test262, vattr97, minion.town, ymax-stdio-mcp, ocapn) FATALed within the same minute with the identical `clone_lock` signature: "cannot acquire clone lock … after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy...)" — 0 reclaim attempts confirms the holder was alive and legitimately busy (mid-clone), not crashed/stale.

Root cause: `clone_lock`'s give-up (common.sh:4142, via `die`) always `exit 1`s loud on a busy-but-live holder. `ensure_clone_or_latch_outage` (common.sh:4671) exists precisely to reclassify a transient clone/fetch failure as `GARDEN_OFFLINE_RC` (quiet skip-this-tick) instead of a loud FATAL, but its transient-signature check `journal_bounded_fetch_is_ambiguous_outage` (common.sh:4647) only matches `rc==1` diagnostics containing `journal fetch in .* failed after [0-9]+ attempt|clone of .* failed` — it does NOT match clone_lock's "cannot acquire clone lock … busy" message. So a live-holder lock-contention timeout (which is definitionally transient and self-resolving once the in-flight clone/holder finishes) falls through to the loud re-raise path instead of latching the outage cooldown, causing every sibling ci-watcher instance sharing the same VERIFY clone to independently FATAL and trigger its own mentor self-heal diagnosis for what is really one shared reclone event.

Fix: extend `journal_bounded_fetch_is_ambiguous_outage` (or add a sibling check consulted by `ensure_clone_or_latch_outage`) to also match clone_lock's busy-holder die signature (`cannot acquire clone lock .* busy`) as a transient/ambiguous-outage class, so `ensure_clone_or_latch_outage` latches the shared cooldown and exits `GARDEN_OFFLINE_RC` quietly on this path too, letting sibling ci-watcher instances skip the tick and retry next cadence instead of cascading into a multi-instance FATAL storm. Keep the loud path for `journal_diagnostic_is_definite_failure` cases (unchanged) so a genuinely crashed/stale holder still surfaces.

<!-- garden-transient-elapsed: kind=signature through=0 values=13 -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-27T01:59:53Z
