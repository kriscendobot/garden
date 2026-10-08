I ran panel round 2 on kriscendobot/minion.town PR #170. The result is **must-fix**: `panel.sh` exited 0 with `code-panel single-round — must-fix`.

**What I ran**
- Ran `panel.sh` in single-round mode against an isolated checkout of `kriscendobot/feat/locator-fragment-scrub` at head `f999de8`. The base was the PR's `baseRefOid` `76bb276` (`main-76bb276`). GitHub's file count for the PR matched the local diff (17 files).
- All 34 code-panel seats returned: 7 request-changes, 19 comment-only, 8 approve.

**Where the verdict is posted**
- The review is https://github.com/kriscendobot/minion.town/pull/170, review id 5452331122, against `f999de8`. It is a comment, not a request-changes review, because GitHub refuses a change request on the bot's own PR. The header reads `disposition: must-fix`, the same shape round 1 used.
- The full aggregate (~94 KB) is over GitHub's ~65 KB review limit. The review carries the summary plus the request-changes and most comment-only seats. The other seats are in a follow-up PR comment: https://github.com/kriscendobot/minion.town/pull/170#issuecomment-6053621029.

**Round-1 blockers now closed:** the CSP hashes match the inline scripts, the browser canary runs under the production CSP, a link guest is held in a pending slot until the server accepts it, and the design doc has a new § 4.1.

**Must-fix items still open.** Each one matters because the encrypted `guest` record is now the browser's only copy of the credential:
1. **A hostile link with a valid guest still silently replaces the stored guest.** This is a login-CSRF swap (locksmith, breaker, saboteur, wire-watcher). The fix is to ask the user before switching to a different guest, and to correct the comment and § 4.1 that claim this is already prevented.
2. **The client deletes the guest on a 401 that doesn't mean the credential was rejected.** The server's catch-all in `guest-web-socket-service.ts` `open` turns a daemon or connection failure into a 401. Separately, `isCredentialRejection` also treats 403 and 404 as rejection, but this route never sends them (breaker, wire-watcher).
3. **After an invalid or failed link, "Create a guest" can overwrite the stored guest.** That page no longer shows the stored guest, which is a regression from the old shell (saboteur).
4. **Two tabs opening at once can each create an encryption key.** Records under the losing key can never be decrypted again (assessor; other seats rated it should-fix).
5. **The `guest.html` → `guest-shell.html` rename missed prose.** `DEPLOYMENT.md:660` and `deploy/aws/www/index.html:5` still call `guest.html` the shell (integrator).

The should-fix items are listed in the review header.

**Follow-ups:** none. Per the stage contract I did not fix anything, mark the PR ready for review, or start another round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1006104 cached reads)
- Output: 8120 tokens
- Cost: $0.9782608
- Wall-clock: 271s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
