---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-11-07T19:02:26Z
---
Originating dispatch: `endojs-endo-but-for-bots-pr1653-gauntlet-panel-1`; PR #1653; reviewed only `48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c...HEAD` in the supplied worktree.

**Verdict:** request-changes

**Findings:**
- **must-fix** — `designs/ordered-directory-formula.md:157-169,223-226,337-339` promises that a retry of an accepted idempotency key never applies twice, but it also makes the key only a retained-history "window" and leaves retention bounded and unspecified. A client retry after compaction or restart therefore has no defined result, and reapplying a move/insert duplicates the edit. Define durable replay semantics: retain keys long enough under a stated contract, reject an expired/reused key, and reject a key whose canonical body differs. Add expiry/restart/reuse tests, not only an immediate retry. [rule: roles/jurors/skeptic/AGENT.md § Operating norms]
- **should-fix** — `designs/ordered-directory-formula.md:162-167,300-301` claims transform convergence but specifies only same-gap inserts, deleted keys, and surviving moves. Ordinary editor races remain undefined: two renames to one name, concurrent replacement of one value, an insert versus rename collision, a deleted move anchor, and overlapping move groups. The proposed two-acceptance-order test cannot establish convergence without outcomes for these cases. Specify conflict or deterministic winner semantics and extend the matrix before offering `stale: 'transform'`. [rule: roles/jurors/skeptic/AGENT.md § Operating norms]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
