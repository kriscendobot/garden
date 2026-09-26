**Press report — endo-byte-array-press (dispatch 2026-07-17T12:20Z)**

**Assessment:** The 06:05 dispatch of this press was claimed by `endolin-garden2-5bcdff64`, an unhealthy host whose claims were repeatedly reaped as stale (multiple claim→reap→requeue cycles in the journal log, latest re-claim 10:33Z with no visible output since). I judged it churning rather than working and took the wheel; sent it a courtesy inbox message (delivered `20260717T122358Z-857cb1`) summarizing state so it can complete with an observation only.

**State of the front:**
- **endojs/endo-but-for-bots#475** (narrow byteArray to plain frozen Uint8Array — the design-#572 view redesign): rebased head `1b1dc75ba9` on the `master-2708cac` reflection, MERGEABLE, **CI green 17/17** (`gh api …/commits/1b1dc75ba9…/check-runs` → `[{"conclusion":"success","n":17}]` — confirming the prior dispatch's open follow-up). All 13 unresolved review threads are addressed: every thread ends with a kriscendobot substantive reply or an explicit reviewer ack ("that new wording is fine", "makes sense to me"). No comments from reviewers since the 00:24Z rebase reply.
- **endojs/endo-but-for-bots#503**: **CI green 15/15** on head `453f6ef0`, both unresolved threads addressed (kriscendobot last responder), kriskowal + erights review requests already pending. Idle awaiting re-review; compliant on the `master-a7ff191` reflection.
- **endojs/endo-but-for-bots#602**: draft-by-design comparison spike, unchanged.
- **Registry follow-up**: still blocked on endojs/endo-but-for-bots#671 (OPEN, CHANGES_REQUESTED) — not started, per charter; the unblock watcher owns promotion.
- **Retire-master sweep**: in motion under a live peer orchestration (`ebfb-retire-master-pr-250` et al. on the bus) — observed, not duplicated.

**Action taken:** Re-requested kriskowal's review on endojs/endo-but-for-bots#475 (`gh api -X POST …/pulls/475/requested_reviewers` → requested now `["kriskowal","erights"]`) — his 06-25 CHANGES_REQUESTED is fully addressed and the rebase he asked for on 07-16 landed with green CI, so the formal re-request signals ready-for-re-review. No code changes were needed anywhere; no garden `main2` changes.

**Follow-ups for next dispatch:** watch for kriskowal/erights re-review responses on endojs/endo-but-for-bots#475 and #503 (both fully in reviewers' court); keep waiting on #671 for the registry conversion; keep observing the retire-master sweep; check whether the garden2 host's churn on the 06:05 dispatch resolved (it may requeue — its claim was live at completion time).

Inbox drained (empty throughout, aside from my own outbound courtesy message).
