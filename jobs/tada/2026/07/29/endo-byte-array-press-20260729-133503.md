## Press report — passable/immutable byte arrays (endojs/endo-but-for-bots, dispatch 20260729-133503, claimed 2026-07-29T16:04Z)

**State of the arc: first real motion after sixteen quiescent cycles. The registry blocker #671 MERGED early today and the unblock watcher auto-promoted the registry conversion job as designed; that job is now queued but starved by the 2-worker quota throttle. Both front PRs remain human-blocked, unchanged.**

**Evidence checked (commands and outputs cited):**

- **endojs/endo-but-for-bots#671** (EndoRegistry capability): **MERGED** at 2026-07-29T02:33:47Z by kriscendobot into `llm` (`gh pr view 671 --json mergedBy,mergedAt` → `{"mergedBy":"kriscendobot","mergedAt":"2026-07-29T02:33:47Z"}`).
- **Registry follow-up auto-arming worked:** `registry-immutable-byte-array-followup.md` was promoted from `plan/` to `todo/` at 02:36:06Z (promotion stamp in the job file). Per the job spec I did **not** execute it — it is the pool's builder job now. However, journal history (`gh api repos/kriscendobot/garden/commits?sha=journal2&path=...`) shows it was claimed at ~02:38Z (made progress — "productive-cycle: handler advanced a worktree HEAD" at 02:43Z), killed ("transient handler kill"), reclaimed at 02:53Z by endolin-garden2/gardener-6, and that claim was swept in a **7-stale-claim mass reap of endolin-garden2 at 07:03:11Z**. It has sat unclaimed in `todo/` since (~9h), with both throttled gardener slots busy on panel jobs.
- **#475** (narrow byteArray to plain frozen Uint8Array — the design-#572 finish-line shape): OPEN, MERGEABLE, CHANGES_REQUESTED, head `1b1dc75b` unchanged, `updatedAt` still 2026-07-17; **0** comments since 01:00Z (`gh api .../issues/475/comments?since=...` → 0). Unresolved threads remain the two outdated, already-answered benchmark asks. Still purely a reviewer-side stall.
- **#503** (freezable-TypedArray emulation): OPEN, MERGEABLE, CHANGES_REQUESTED, head `453f6ef0` unchanged, 15/15 checks SUCCESS, **0** new comments. The 07-18 disposition question (close-as-superseded-by-#475 vs narrow) remains unanswered; deliberately untouched.
- **Redesign supremacy:** unchanged — #475 remains the view-based implementation of record; spike #602 still DRAFT (2026-07-10); design #572 → 0 new comments. Both front branches remain MERGEABLE despite `llm` advancing ~2,400 commits (`gh api .../compare/llm...<branch>`).
- **Liveness:** no byte-array job in `doin/`; my inbox empty at start and finish.

**What I did this dispatch:** recorded the arc's motion and sent the maintainer one concise note (delivered `20260729T160818Z-4d424a`): #671 landed, the conversion job is armed but throttle-starved, and a pool bump or priority nudge would unstick it today; #475/#503 still await re-review/disposition. No pushes to any PR (would invalidate pending re-review state); no execution of the registry follow-up (a future pool claimant owns it — duplicating it here would race them).

**Follow-ups:**
- Next dispatch: check whether `registry-immutable-byte-array-followup` got claimed and survived (two prior claims died to transient handler kills — if a third dies, that's a poison-track pattern worth escalating, not just observing).
- Then the standing checks: maintainer answer on the #503 disposition, re-review on #475.
- Housekeeping observation: a sibling dispatch `endo-byte-array-press-20260729-072002` still sits unclaimed in `todo/` and will duplicate this pass when claimed; the press-schedule directive-dedup should absorb it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-byte-array-press-20260729-133503.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (637263 cached reads)
- Output: 13795 tokens
- Cost: $2.2467470000000005
- Wall-clock: 264s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
