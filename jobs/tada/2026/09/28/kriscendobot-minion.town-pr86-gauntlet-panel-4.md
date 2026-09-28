**Panel round 4 on kriscendobot/minion.town#86: must-fix**

- **Run:** I checked out the PR head `a77607d` (branch `git-remote-capability-increment-1`) in an isolated worktree and ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 86 main-b32291d`. It exited 0 with disposition `must-fix`. All 33 seats returned a verdict.
- **Verdict posted:** review 5345784251, posted as a COMMENT review because GitHub won't let the bot request changes on its own PR (same as rounds 1–3). The review body has the summary and the one request-changes seat. The other 32 seats are in two follow-up comments (issuecomment-5880506431 and -5880506709), split because the full write-up (~81 KB) is over GitHub's size limit for one post.
- **Only must-fix (stylist):** new abbreviated names need spelling out.
  - `MIME_BY_EXT`/`ext` in `src/endo/git-remote/projection.ts` → `MIME_BY_EXTENSION`/`extension`.
  - `aliceRW` in `test/git-remote/git-remote-protocol.test.ts` → `aliceReadWrite`.
  - The `_RE` suffix note is comment-only.
- **Worth the fixer's attention (comment-only seats):**
  - typist: the `request.query.service as string | undefined` cast in `git-http.ts:212` is unsound; use a `typeof` guard instead.
  - assessor: `mint` leaves `indexedModifiedTime` stale, so the next call rebuilds the index for nothing.
  - integrator: the design doc and `DEPLOYMENT.md` describe a push as updating the served content atomically; the seat flagged that wording.
- **Scribe:** approve. Every earlier request to record something and every required completion summary is closed.
- No fixes, un-draft or loop were done in this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (726771 cached reads)
- Output: 4538 tokens
- Cost: $0.7351942000000001
- Wall-clock: 609s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
