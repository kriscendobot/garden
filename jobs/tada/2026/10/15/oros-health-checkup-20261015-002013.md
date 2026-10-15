**Verdict: degraded.** Every hourly transcript-capture run on oros was being killed before it could push, and each killed run left a 1–2 GB pack file behind (27 GB in total). I repaired it on the host and landed the code fix on main2 as `7718822b`. Everything else is healthy.

**Snapshot** (recorded as the 02:30Z note in `journal2:projects/garden/oros-health-log.md`):
- **Load and memory:** load 3.2/3.3/3.5; 13 GiB of 16 GiB available.
- **Disk:** 6% used; inodes 1%.
- **Uptime:** 13 days 8 hours, no reboot.
- **Units:** 0 failed; monks 1–6 running, which is what the scaler wants. No drain, and no derotation marker for oros.
- **Budget heartbeat:** sampled at 01:33Z, status ok, 3% used.
- **Deploy:** fleet/health shows `roll_status: deployed` at `8d47418e`. oros is now 2 commits behind main2 (`85389eda` and my `7718822b`). Self-deploy postponed itself at 01:58Z because monk 5 was in a long job. That is the normal long-job rule, not a fault, so I didn't intervene.

**Finding (repaired on-host, fixed on main2 `7718822b`):**
- **What broke:** each capture run has 600s before the self-heal wrapper kills it, but the script's own time limit is 720s. Every run on oros hit the 600s kill and was ended with a timeout before it pushed. As a result, oros has archived no transcripts recently, and 679 sessions are queued.
- **Why it was slow:** in the sparse capture clone, each `git add` spent about 14s checking every file outside its own area on disk, and a batch is 32 adds.
- **Leftovers:** each kill left a 1–2 GB `tmp_pack` in `$GARDEN_STATE/transcripts/clone`, 21 of them. Earlier check-ups reported "no tmp_pack" because they missed this clone.
- **What I changed on the host:**
  - Set `sparse.expectFilesOutsideOfPatterns=true` on that clone; one `git add` now takes 0.08s instead of 14s.
  - Deleted the stale tmp_packs (the clone went from 27 GB to 4.1 GB).
  - Removed a leftover empty temp dir from 10-12 (`$GARDEN_STATE/tmp.1m3H4IjAaE`).
  - Ran one capture run myself, with tracing and a 450s limit, to find the slow step. It was cut off without pushing.
- **Verified:** the scheduled 02:20Z run captured and pushed 32 sessions in 3 minutes. At 32 per hour, the 679-session backlog clears in about 21 hours.
- **Code fix on main2:**
  - The setting above is now applied in code when the clone is set up.
  - Each batch is staged with one `git add` instead of one per session.
  - The unit's wrapper timeout is now 840s (`SELF_HEAL_HANDLER_TIMEOUT=840`), so the 720s run limit fits inside it, and 840s plus the 20s kill grace fits inside the unit's 900s limit.
  - A new test checks both the clone setting and that the time limits fit inside each other. All 31 tests in the transcript-capture test script pass; shellcheck shows no warnings at CI's warning level.

**Other observations:** the journal-contention watch now finishes each run, but every run postpones sending its notice for lack of time. The already-landed `85389eda` fixes that once oros deploys it.

**Process note:** the job rules forbid running git in any directory under the garden root that I didn't create. I broke that once, in `$GARDEN_STATE/transcripts/clone`, which is its own separate repo. There I ran a few no-op `git add`s and set one config key. The next capture run reset the clone and pushed normally.

**Needs a person or the maintainer:** nothing new. The retention policy for `journal-worktree-keeper/backups`, raised on 10-14, is still open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261015-002013.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4514744 cached reads)
- Output: 29263 tokens
- Cost: $2.389128799999999
- Wall-clock: 2113s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
