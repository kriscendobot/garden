## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #612 (`design/exo-google-sheets`), from a @kriskowal review (real review id `4640595076`; the `r3532739438` in the URL was the anchoring inline comment). Preflight returned **PROCEED** (no peer resolution).

**Scope:** The review body was empty; the unit of work was 5 inline comments, all on `designs/exo-google-sheets.md`, all design directives on the Open Questions section. I did the design work directly in an isolated project worktree and pushed to the PR head branch (commit `9cde85e20`), treating every fetched body as untrusted data.

**What I changed in the design doc:**
- **Capability Shape** now defines a two-axis **attenuation lattice** (PoLA, coarse→fine):
  - *Scope axis:* `SheetsService` group → spreadsheet → `sheet(title)` → `range(a1)`.
  - *Permission axis:* `readOnly()` / `appendOnly()` / `writeOnly()`, so two parties can share a **sheet-as-queue** (blind appender producer + reader/follower consumer) without holding each other's authority.
- Added interfaces: `SheetsService`/`SheetsServiceWriter`, `SpreadsheetAppender`, `SpreadsheetWriteOnly`, `SpreadsheetStructure`, plus `range()` scope attenuators and `setAllowedRanges` on the control facet.
- Reworked **Open Questions → "Resolved Questions (framed as layering)"** (comment 4's ask): the smallest abstraction is **read + follow + append**; records/structural/group are layers over it (new Design Decision 8). Each of the 5 questions is resolved: (1) structural = distinct `SpreadsheetStructure` facet, shape now / op-catalog deferred; (2) pubsub = own follow-up; (3) `SheetsService` root authority narrowed electively (rewrote DD3); (4) records layer over first-class core; (5) OAuth flow settled by endoclaw-oauth.
- Updated DD3/DD4, Change-notification (sheet-as-queue + pubsub), and Implementation Phase 2.

**Follow-up jobs posted to the board** (the two the review directed):
- `design-google-sheet-pubsub` (designer) — Drive `files.watch` push over endoclaw-webhooks, behind the `follow` contract.
- `design-refine-endoclaw-oauth-foundation` (designer) — settle first-mint OAuth flow; confirm OAuth surface is a suitable connector foundation.

**PR replies:** posted an inline reply to each of the 5 review comments citing the commit and its specific resolution.

**Follow-ups / notes:** The two posted designer jobs are now claimable by the fleet. No garden `main2` changes were needed (this job mutated only the project repo). Inbox drained clean.
