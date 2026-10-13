---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Record the maintainer's answers in design PR kriscendobot/minion.town#167

PR: https://github.com/kriscendobot/minion.town/pull/167 (`designs/root-canary-principal.md`). Do not run a gauntlet; this is a doc-only update of the draft. Keep it to one commit.

kriskowal answered the open questions with inline review comments on 2026-10-13 (review on the PR; read them with `gh api repos/kriscendobot/minion.town/pulls/167/comments`). Apply them:

1. Q1: full root over MCP is **accepted**: "This deployment is disposable." Use kriscendobot's production root (the design default); no dedicated canary account, no attenuated grant first.
2. Q2: the sign-in is **interactive**. Any canary job is expected to queue until the maintainer logs it in; the liaison raises it in a muster message. Add the two alternatives he floated to § 4 as future directions, not decisions: (a) our own OAuth provider on minion.town keyed on guest formula identifiers, in a way Claude accepts; (b) a stdio MCP without OAuth, provided enough code is shared that confidence in one carries to the other. He still wants a smoke test of the live MCP either way.
3. Q3: the mint script runs on `endolin-garden1`.
4. Q4: only `endolin-garden1` may assume `minion-root-canary-reader`; `endolin-garden2` is retired. His comment did not address narrowing the fleet's AWS administrator access: leave that as the one still-open part of Q4.
5. Q5: 90-day refresh token **confirmed**.
6. Q6: no sub-cap ("Let's not complicate this."); the pool stays shared per `iss+sub`.
7. Q7: deferred: "Ask again later with a more rigorous explanation." Keep it as a follow-up, to be re-asked with a fuller rationale.
8. Q8: not pursued: he is "not terribly interested in identity based access control in general"; minion.town mints inference capabilities that see the world narrowly through their endowments, and he does not see how root subjects fit. Record that, and do not file the follow-up design.

Then remove the Status line's "should not be built until the open questions are answered" gate and replace the answered questions with a short "Decisions (2026-10-13)" section, citing the review. Fix the copy-edit findings from the last panel if they are one-line: premise A8 wording ("the verifier does not read it"), the "to no other surface's allowlist" phrasing, and the ownership-map row split (storage vs canary lifecycle). Push to the PR head and leave the PR a draft. Post one PR comment summarizing the change.
