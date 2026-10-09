## Completion report: `fix-namespace-clone-repack`

All three asks are fixed and pushed to `main2` as `1c65522fb79`. The main-host test suite passes (54/0), and the maintenance script was checked against throwaway clones in a scratch `GARDEN_STATE`.

**1. Periodic maintenance of the per-namespace clones**
- New script `scripts/jobs/namespace-clone-maintenance.sh` runs over every `$GARDEN_STATE/*/journal` clone.
- New `garden-namespace-clone-maintenance` timer and service run it every 2 hours at :37 on every host, with no leader gate. The script adds up to 300 s of random jitter, and the unit runs at Nice=19 with idle I/O priority.
- I gave it its own unit rather than adding it to the state-clone-keeper or root-repo-guard, so a long first repack can't use up the keeper's 1800 s budget. `install-units.sh` enables any new `garden-*.timer` automatically.
- For each clone, under that clone's lock (a busy clone is skipped this pass and caught next time):
  - delete `objects/pack/tmp_*` and `objects/incoming-*` files older than 180 minutes, so a fetch in progress isn't touched;
  - if the clone has more than 50 packs, run `nice ionice -c3 git repack -a -d`, capped at 30 minutes.
- On the scratch test: 8 packs became 1, the 2-day-old tmp file was deleted, the fresh one was kept, and fsck was clean.

**2. Cheap, robust `is-main-host.sh`**
- The leader was already cached for 30 s, but whenever that cache expired, every one of the ~100 leader-gated units did its own fetch and git read. That is how a 57 s read became load 20–45.
- Now `leader_host` in `common.sh` lets exactly one caller refresh once the cache is stale. Every other caller gets the cached value straight away.
- I did not add the separate refresh timer the job suggested: the existing cache plus this one-at-a-time refresh gets the same effect with fewer moving parts.
- With item 1 keeping the leader clone small, the one refresh stays fast too.

**3. Alerting**
- If any clone is still over the 50-pack threshold after a pass, the script raises a watchdog-notice under the key `namespace-clone-packs-<GARDEN>`; repeats while it stays open are deduplicated.
- It sends `--recovered` only after an alert it actually opened, so healthy passes post nothing. Tested: alert, deduplicated re-alert, one recovery, then silence.

**Other changes**
- `scripts/jobs/test/main-host-test.sh` now also checks that the new unit is not leader-gated.

**Follow-ups**
- Hosts pick this up at their next rolling deploy. Until then, the manual fix from the job is still the remedy on a host showing these symptoms.
- The scan covers only top-level `*/journal` clones, as the job asked. Per-identity clones like `inbox/<id>/journal` are left to the state-clone-keeper, which deletes leaked ones but does not repack the ones still in use.
- The memory note about the 45 s reclone livelock was not touched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-namespace-clone-repack.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1085785 cached reads)
- Output: 11302 tokens
- Cost: $0.9824370000000001
- Wall-clock: 117s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
