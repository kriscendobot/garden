## Press report — passable/immutable byte arrays (endojs/endo-but-for-bots, dispatch 2026-07-24T10:50Z, completed 2026-07-25 after 4 reaper requeues)

**State of the arc: unchanged since the last completed report (07-22 16:05Z). Both front PRs remain review-complete on our side, CI-green, and stalled solely on human re-review. No unblocked artifact; nothing was pushed this dispatch.**

**What I assessed (evidence):**
- **#503** (freezable-TypedArray emulation + byteArray brand check): OPEN, head `453f6ef0` unchanged, `reviewDecision: CHANGES_REQUESTED` (stale, from kriskowal's 06-25 review). CI: `gh pr view 503 --json statusCheckRollup` → **15/15 SUCCESS**. Zero issue comments, inline review comments, or reviews since 07-22 (`gh api .../comments?since=2026-07-22T17:00Z` → empty; `pulls/503/comments?since=…` → 0).
- **#475** (narrow byteArray to plain frozen Uint8Array — the design-#572 mega-front): OPEN, head `1b1dc75b` unchanged since the 07-17 rebase. CI: **17/17 SUCCESS**. Same quiet: 0 new comments/reviews since 07-22.
- **Redesign supremacy:** unchanged — #475 carries the frozen-Uint8Array-view byteArray shape; the Proxy-emulation spike **#602** remains DRAFT, untouched since 07-10.
- **Registry follow-up:** **#671** still OPEN (`CHANGES_REQUESTED`, last activity 07-18); `registry-immutable-byte-array-followup.md` confirmed present in `jobs/plan/`. Not started, per standing instruction — the unblock watcher owns its promotion.
- **Inbox:** empty. No live agent is pushing either front branch; the stall is human re-review, so there was no wheel to take.

**What changed this dispatch:** no project pushes (any churn would invalidate the pending re-review request). I sent the maintainer one message (`inbox/maintainer` `20260725T032549Z-31957b`): the fronts need only kriskowal/erights re-review, and a fleet-health note — this press has completed no report since 07-22; every 6h dispatch since then overran and was reaped (this one 4×), with three claims (105003/165003/225004) concurrently on the board, burning Fable budget to observe "no change" while the arc is human-blocked. Recommended pausing the schedule or widening cadence to 24h until re-review, and/or an xs2rust-style preflight circuit-breaker (garden commit `2898c87d`) for this press.

**Follow-ups:**
- Next dispatch: check for fresh reviewer feedback on #503/#475 first; watch #671 (arms the registry conversion automatically).
- Liaison/foreman: act on the cadence/circuit-breaker recommendation above — the overlap pattern flagged on 07-22 has worsened; sibling stale claims from 07-22/07-23 still sit in `jobs/doin/` awaiting the reaper.
