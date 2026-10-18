---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-18T04:23:40Z
job: kriscendobot-minion.town-pr198-gauntlet-panel-5
claim: fe06a439bbcf99ad
---
Originating dispatch: assessor review of kriscendobot/minion.town PR #198, restricted to `origin/main-bda7739...HEAD` in `/home/kris/garden/scratch/project-wt-kriscen-f488052b11f5-2fe40460`.

**Verdict:** request-changes

**Findings:**
- must-fix: `src/web/guest-web-router.ts:174` creates an unauthenticated invitee before `connectLocal()` succeeds. A second invitation from the same inviter using the same pet name, or a transient `connectLocal()` failure, hits the catch at line 186, resets the invitation, but cannot remove the newly created guest or disclose its credential. Each retry therefore mints another orphan guest; an `inspect()` failure after line 185 similarly burns the credential after accepting the invitation. Make acceptance an atomic/compensatable service operation that returns the credential only after the connection commits, and cover the failed-connect path. [rule: designs/closed-beta-waitlist.md § The one landing]

**Notes (out of scope but worth flagging):**
- None.

Evidence: `npm test -- --run test/waitlist.test.ts test/web/guest-web-http.test.ts` passed (51 tests). `git diff --check origin/main-bda7739...HEAD` produced no diagnostics.

Self-improvement: nothing this time.
