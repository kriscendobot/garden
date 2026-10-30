Fix round 6 for kriscendobot/minion.town#231: I fixed the breaker's two bugs and the pruner's prose cuts, and CI is green on the new head `969dd0b1`. I did not apply the decomplector's one must-fix item (drop or shrink the session); I explain why below.

**What changed on the PR (one commit, pushed with `safe-push-pr-head.sh`):**
- **Sign-out with an out-of-date revoker (breaker 1):** the server now returns 404 when the revoker a tab sends at sign-out no longer matches any live session group. Before, it returned 204, so the tab went on to log out while another tab's newer sessions stayed live. On a 404 the client now mints once to get the current revoker and retries.
- **Sockets that never open a session (breaker 2):**
  - A connected socket that hasn't opened a session within 30 seconds is closed.
  - Each user may hold at most 8 such sockets; the next one is refused with 403.
  - At most 256 connections may wait on login checks at once; past that the server answers 503.
- **Pruner cuts:**
  - Removed three duplicated paragraphs from the PR body. The production-evidence prose is gone; the evidence ledger still records it.
  - Removed one duplicate "inert until attach" sentence and four test comments that only repeated the assertion below them.
  - Removed the test-coverage sentence in `shell-session.js`, and replaced the locator-closure list there with a pointer to design § 8.
  - I kept the one-line doc comment on `attachShellSessionPlane` and the transport table.
- New tests cover the 404 cases, the client retry, the per-user socket cap and the 30-second deadline. The changeset describes the 404 and the socket bounds.

**Tests:**
- The three shell-session test files pass (60 tests), along with typecheck and build.
- In the full suite, the only failure was `test/git-remote/capability.test.ts`. It is unrelated to this change and is the known local false-fail.
- `ci-wait-merge.sh` returned rc 0: all 7 checks passed.

**Not applied:**
- **Decomplector 1 (must-fix):** it asked to defer the session until a later step needs real authority, or cut it down. This PR implements step 0a of the open design PR #230, which defines exactly this per-tab session with per-tab and sign-out-wide revoke. Dropping or shrinking it changes that design, so I left it for #230. The panel-7 review may raise it again.
- **Decomplector 2 and 3:** these are also questions about design #230 (why a second connection path instead of a limited facet on the existing guest path, and the complexity of the group revoker).
- **Breaker 3:** tabs past the 32-session limit evict each other in a loop. It was marked comment-only and the client's backoff bounds it, so I left it.

I posted a comment on the PR answering each item (issuecomment-6518992085).

Two of my attempts to wait on CI in the background were stopped at the 10-minute limit. I then polled in the foreground and confirmed green with the canonical waiter. Nothing is left running.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3000564 cached reads)
- Output: 18765 tokens
- Cost: $1.7657567999999997
- Wall-clock: 1559s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
