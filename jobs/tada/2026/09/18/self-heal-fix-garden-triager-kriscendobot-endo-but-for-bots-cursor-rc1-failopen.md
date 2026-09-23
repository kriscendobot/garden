Done. Fix landed on main2.

## Completion report

**Job:** self-heal the triager hard-die when `cursor-get.sh` fails with plain rc=1.

**What I did:** In `scripts/jobs/triager.sh`, at both `cursor-get.sh` call sites (the activity cursor around `old_sha`, and the failcount cursor around `fail_state`), I dropped the `is_environmental_rc "$rc"` gate and the `die "cursor-get.sh failed ..."` fallback. Both sites now WARN-and-`exit 0` on **any** nonzero rc.

**Why:** The guards from `73c2432e89` only skipped the tick on rc 75 (environmental). But `sync_clone` (`common.sh:5887,5891`) also `die`s with plain rc=1 when a journal fetch fails and the stderr doesn't match the necessarily-incomplete offline-signature list — transport error text varies across git/curl/OpenSSH versions. That rc=1 escaped the environmental-only guard and hard-killed `garden-triager@kriscendobot-endo-but-for-bots` (observed 2026-09-18 16:25:40, outside the 04:50–05:16Z outage window the prior fix targeted). A cursor read is inherently best-effort — a stale/unreadable cursor just re-triages next tick with no data loss — so no nonzero rc should crash the unit.

**Changes:** One file, `scripts/jobs/triager.sh`; two guard blocks simplified, comments updated to record the rc=1 gap. `bash -n` clean; `is_environmental_rc` now appears only in an explanatory comment there.

**Commit/push:** committed and pushed to `main2` via rebase-CAS (repo-moved notice is benign; push succeeded).

**Follow-ups:** None required. A deeper fix (widening `_fetch_stderr_is_offline`'s signature list in `common.sh` so more real transport failures classify as environmental) remains possible but is orthogonal — the fail-open at these best-effort call sites is the correct guard regardless.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-triager-kriscendobot-endo-but-for-bots-cursor-rc1-failopen.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (328394 cached reads)
- Output: 4027 tokens
- Cost: $0.628118
- Wall-clock: 58s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
