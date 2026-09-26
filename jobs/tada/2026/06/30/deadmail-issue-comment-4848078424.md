## Completion report

**Job:** `deadmail-issue-comment-4848078424` — dead-letter pickup for `issue-kriskowal-garden-9`, carrying forward kriskowal's new comment on kriskowal/garden#9.

**Intent of the dead-lettered message:** the maintainer asked the issue doer to *"post a job to attempt to reproduce the production failure with the portfolio contract upgrade in the inquisitor, then verify the fix with changes to Agoric Internal Hex,"* and to keep reporting progress on the issue thread.

**What I did:**
1. **Posted the job** `inquisitor-ymax0-hex-repro` to the board (carrying the ISSUE NOTE verbatim). It specifies the reproduce-then-verify round against the already-captured, verified mainnet swing-store (`agoric-26146641`, `integrity_check ok`, at the gitignored per-host cache) through `inquisitor.mjs` on a `kriscendobot/agoric-sdk` worktree: **control** = stock v320 `bundle-ymax0` aborts with the XS value-stack overflow at the `hex.js` `flatMap`; **patched** = the `flatMap`→loop `@agoric/internal/src/hex.js` installs and completes at stock `stackCount = 4096`. Scope locked to bot forks, no upstream interaction. The job was **claimed immediately** — it is already in `jobs/doin/`, so the inquisitor work is in flight.
2. **Replied on issue #9** (https://github.com/kriskowal/garden/issues/9#issuecomment-4848126586) as kriscendobot: confirmed the job is posted and claimed, laid out the control/patched plan and the swing-store it runs against, committed to iterative progress reports, and offered the taller-`stackCount` snapshot-compatibility cross-check as a fold-in or a separate round. Did not close the issue (the submitter does that).

**Follow-ups / flags:**
- **Plan-job overlap:** a pre-staged `jobs/plan/verify-ymax0-hex-fix-inquisitor.md` (gated `go-ahead`, posted 2026-06-30T01:59Z) covers the same control + hex-fix items **plus a third item not in the maintainer's current ask** — confirming a taller-`stackCount` worker loads real pre-upgrade snapshots without a signature/version break and that v320 upgrades on a fresh machine. My in-flight `inquisitor-ymax0-hex-repro` subsumes its items 1–2. The plan job remains parked (invisible to the pool, harmless), but **the liaison/foreman should not double-promote it** — if its item 3 is wanted, promote it narrowed to the stackCount-compatibility cross-check only. I left this reconciliation to the liaison rather than editing journal2 plan state from a main2 worktree (out of lane, and the journal-reset hazard).
- The in-flight job will post the actual reproduction/verification evidence on issue #9; this job only kicked it off per the explicit "post a job" ask.

No main2 commits were needed (the work was a board post and a GitHub comment); scratch files are torn down with the worktree.

Self-improvement: nothing this time. (A small candidate — "check `jobs/plan/` for a pre-staged match before posting a new job" — is already implied by post-job idempotency and the plan-promotion contract; not worth a skill edit.)
