Press dispatch complete — this was an assessment tick; both fronts are healthy and reviewer-blocked, so there was no wheel to take. Report follows.

Byte-array press dispatch report (2026-07-20)

Assessment: both front PRs are fully addressed on the bot side, all-green, and waiting on maintainer re-review. No live agent conflict, no stall, no unblocked artifact to build this dispatch — I recorded the observation below and took no code action.

- **#475** (view-only `byteArray`, the implementation of record for design #572): head `1b1dc75ba9` sits on upstream reflection `master-2708cac`, all 17 CI checks green (run 29559159942, verified via `gh pr checks 475`). The two outstanding review threads (kriskowal's Node/XS benchmark requests on `ascii` encode/decode) were fully answered on 07-16 with measured results and the winning native-transcoder implementation landed in `d6149e723`. The stale CHANGES_REQUESTED decision is from the June 23 review; the ball is with kriskowal.
- **#503** (dual-shape brand + emulation): head `453f6ef0d`, all 15 checks green. Both inline review threads addressed. The 07-18 disposition question — close as superseded by #475, or narrow to an emulation-only slice — is still unanswered by kriskowal (2 days, over a weekend, reviewers actively engaging; a nudge would be premature noise). erights' 07-20 04:04 question about the erroneous "read delegate" phrasing was answered by a triager job within 3 minutes; I verified the PR description no longer contains the bad phrasing (the remaining "shadowing index" mention is the legitimate brand-check rejection list).
- **Redesign status:** the byteArray-view redesign has *not* yet fully replaced the immutable-ArrayBuffer approach — #503 still carries the bare-immutable-`ArrayBuffer` shape that #572 Decision 2 rejects. That is exactly what the pending disposition question resolves; per the 07-18 commitment, #503 stays untouched until kriskowal calls it.
- **#602** (emulation spike): correctly dormant as a comparison draft. **#671** (registry blocker): still open, CHANGES_REQUESTED; the registry follow-up remains parked for the unblock watcher — not started, per job instructions.
- **#572**: quiet since 07-01; no new design guidance.

Follow-ups: none posted. Next dispatch should first check whether kriskowal has answered the #503 disposition question or re-reviewed #475 — either event unblocks the next artifact (executing the disposition, or driving #475 through the finish line).
