## Press report — passable/immutable byte arrays (endojs/endo-but-for-bots, dispatch 2026-07-22T16:05Z)

**State of the arc: unchanged since the 03:50Z dispatch — both front PRs are review-complete on our side, CI-green, and waiting on human re-review. No unblocked artifact to build; nothing was pushed this dispatch.**

**What I assessed (evidence):**

- **#503** (freezable-TypedArray emulation + byteArray brand check): OPEN, `reviewDecision: CHANGES_REQUESTED` (kriskowal's 06-25 review, both inline asks long since landed). erights' 07-20 "read delegate" question was answered same day with a description correction at head `453f6ef0`; no reviewer activity since (`gh api .../issues/503/comments?since=2026-07-20` shows only that exchange). CI: `gh pr view 503 --json statusCheckRollup` → **15/15 SUCCESS**. Re-review is pending from both kriskowal and erights (`reviewRequests` lists both).
- **#475** (narrow byteArray to plain frozen Uint8Array — the mega-front carrying the design-#572 view shape end to end): OPEN, head `1b1dc75b` (the 07-17 rebase onto the master reflection); zero new issue comments, review comments, or reviews since that rebase report. CI: **17/17 SUCCESS**. Re-review pending from kriskowal and erights.
- **Redesign supremacy:** unchanged — #475 carries the frozen-Uint8Array-view byteArray across pass-style/marshal/bytes/ascii/captp/daemon; the Proxy-emulation spike #602 remains DRAFT-for-comparison (untouched since 07-10).
- **Registry follow-up:** #671 is still OPEN (`CHANGES_REQUESTED`, last activity 07-18), so `registry-immutable-byte-array-followup` stays parked in `jobs/plan/` (confirmed present); the unblock watcher will promote it when #671 lands. Not started, per standing instruction.
- **Inbox:** empty. No live agent is working either front PR — the stall is on human re-review, so there is no wheel to take.

**What changed this dispatch:** nothing — any push, rebase, or comment would churn a diff reviewers were asked to re-review, with no feedback yet to act on.

**Follow-ups:**
- Next dispatch: check for fresh reviewer feedback on #503/#475 first (the only thing that can unblock the fronts), and watch #671, which arms the registry conversion automatically.
- Fleet observation for the liaison/foreman: the previous dispatch of this press (`endo-byte-array-press-20260722-095006`, claimed 09:50Z, reaped once, re-claimed 13:53Z on `endolin-garden-ece02cb4`) was still sitting in `jobs/doin/` when this 16:05Z dispatch ran — the 6-hour cadence is overlapping an overrunning/reaped prior run. The same duplicate-dispatch overlap pattern the xs2rust-press circuit-breaker (commit `2898c87d`) addresses may be worth applying to this press-driver.
