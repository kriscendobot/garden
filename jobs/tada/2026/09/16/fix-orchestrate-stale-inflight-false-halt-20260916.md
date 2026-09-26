Just a deadline nudge — work is already complete and pushed. Writing the completion report.

---

## Completion report

**Job:** `fix-orchestrate-stale-inflight-false-halt-20260916` — the orchestrate watcher declared children FAILED on stale in-flight readings, halting whole serial campaigns and parking approved work for weeks.

### Root cause (how a 463s job is reported as a 2505s stall)

`child_failure_detail` in `scripts/jobs/orchestrate.sh` computed the "stalled in flight" age from `child_claimed_at` and, **failing that, fell back to `child_promoted_at`** — the `<!-- garden-promoted-from-plan … at=<ts> -->` marker. That marker is written **once at promotion** and **survives every requeue** (`reaper.sh`'s `clean_body` strips the claim block and cycle markers, never the promotion marker). So a child promoted early in an 80-minute campaign and momentarily back in `todo` (a normal reap-and-resume, queued awaiting re-claim) had **no `claimed_at`**, fell back to the promotion timestamp, and read as *"stalled in flight for &lt;campaign-age&gt;s"*. The `2505s` was the age since promotion, not any attempt's runtime; the named host `endolin-garden2-5bcdff64` came from the orchestration record's remembered `child-<c>-host` fallback, not a live claim. Meanwhile the child re-claimed and completed its real 463s attempt (`c32821fa15`) — but the watcher had already halted without re-checking `tada/`. That is the "wrong clock" the job description suspected.

### What changed (`scripts/jobs/orchestrate.sh`, `post-orchestration.sh`, `skills/orchestration/SKILL.md`, tests)

1. **Wrong-clock fix.** In-flight stall is now computed **only for a CLAIMED (`doin`) child, from its current claim's `claimed_at`**. The promotion-clock fallback is removed (and dead `child_promoted_at` deleted). A queued/unclaimed child is `active`, governed by the requeue-count limit and the reaper — never "stalled in flight" from campaign age.
2. **Tada is the authority.** New `child_completed_on_resync` re-syncs and re-reads `jobs/tada/` before `child_state` returns `failed` for any **inferred** verdict (in-flight stall *and* requeue-streak). A completion observed on re-sync returns `done`. (`gone` was already re-sync-guarded.)
3. **Self-correction of halts (both instances resolve themselves).** A serial halt now records `halt-failed-child:` machine-readably. New `resume_recovered_halts` pass: when a halt's blamed child is later observed complete in `tada/` (a false stall, or an overrun that recovered on requeue — instance 2's shape), it **re-posts the still-parked remainder** as `<base>-resume` via `--resume-from` (extended to accept `halted`/`halted-superseded` terminals and tolerate already-progressed children) and flips the record to `halted-resumed`. Fires only when the *blamed* child succeeded; a genuinely-doomed child leaves the halt standing. Idempotent.
4. **Regression tests** (subtests 25 TADA-AUTHORITY, 26 FALSE-STALL, 27 RESUME) pin all three, including requirement #4 (a child completing within budget never halts its parent). **68/68 pass.**

Committed as `c804235719` and pushed to `main2` (origin/main2 now at that commit).

### Follow-ups
- The two *existing* stale records (`credit-controls-20260916`, `minion-town-clipometer-esbuild-orchestration`) predate this fix and carry no `halt-failed-child:` field, so the automatic resume won't retroactively fire on them. Their remaining children can be resumed by hand with `post-orchestration.sh --resume-from <base> <base>-resume <remainder…>` (now supported), or the maintainer can promote the parked children directly. Going forward, new halts self-correct.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-stale-inflight-false-halt-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (12073310 cached reads)
- Output: 89418 tokens
- Cost: $10.273933999999997
- Wall-clock: 2123s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
