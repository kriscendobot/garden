Done. Work complete and pushed.

## Completion report

**Job:** `improve-gauntlet-transient-doom` — defer a transient `requeue-exhausted` gauntlet-stage doom notice through a bounded scripted handoff to `gauntlet.sh`, surfacing to the maintainer only if the handoff is not consumed in time.

**What changed** (`scripts/jobs/reaper.sh`, on `main2` @ `fcd9ed24d5`):

- **New deferred gauntlet-handoff spool.** When the reaper dooms a job that is a `gauntlet:` STAGE with signature `requeue-exhausted` **and** `failure_classification: transient` (the exact condition `gauntlet.sh` uses to retry a stage), it no longer surfaces the maintainer doom notice immediately. Instead `spool_gauntlet_handoff` records it — keyed by the same `doom_key` so a re-doom overwrites and resets the timer — with a `deferred_at` stamp, under `GARDEN_GAUNTLET_HANDOFF_SPOOL`.
- **`drain_gauntlet_handoff_spool`** runs at the top of every tick (after `sync_clone`, alongside `drain_doom_spool`) and resolves each deferred entry purely from board state in the reaper's synced clone:
  - held `jobs/plan/<stage>.md` **gone** → the supervisor consumed it (stage retried) → **drop silently** (no maintainer noise);
  - still parked, **within** `GARDEN_GAUNTLET_HANDOFF_TIMEOUT` (default 1800s, comfortably > the ~3-min gauntlet timer cadence) → leave for a later tick;
  - still parked **past** the bound → the handoff was not consumed (stalled supervisor, or an exhausted stage-retry budget that halted leaving the entry) → **surface now** and clear the spool.
- Two parallel arrays (`DOOM_GAUNTLET`, `DOOM_TRANSIENT`) carry the per-job gate from the doom-park loop to the flush loop; the flush's generic `requeue-exhausted` branch defers vs. surfaces accordingly. Non-transient gauntlet dooms and all non-gauntlet dooms are untouched — they surface immediately as before.
- Header comment updated to document the refinement.

**Tests:**
- Added `scripts/jobs/test/reaper-gauntlet-handoff-test.sh` (5 hermetic subtests: defer+spool, consumed→dropped, timeout→surfaced, non-transient control, non-gauntlet control) — **5/5 pass**.
- Regression: `reaper-doom-park-test.sh` (9/9), `reaper-requeue-cap-test.sh` (5/5), `outage-doom-pause-test.sh` (11/11), `gauntlet-test.sh` (46/46) all still green. `bash -n` clean.

**Follow-ups:** none required. The `designs/cybernetics-audit.md` reaper row already generically covers doom-notice spooling; this new spool is analogous and documented inline, matching how the existing doom-spool and requeue-cap refinements are recorded.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-transient-doom.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (5448746 cached reads)
- Output: 36274 tokens
- Cost: $5.095958000000001
- Wall-clock: 494s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
