---
ts: 2026-05-14T02:15:30Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004700Z-dispatch-liaison-c5d710.md
  - entries/2026/05/14/010000Z-message-boatman-176fd1.md
  - entries/2026/05/14/021500Z-result-boatman-7c5e8a.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

#75 ferry, second pass: PR `endojs/endo#3232` updated by force-push. New head `4d3c96994`. The branch's prior tip `b61c928e` is preserved as an ancestor (in-flight gibson042 review-thread anchors stay valid); 7 cleanly-attributed commits land on top.

**Recovery from stream-idle timeout**: the boatman's Agent invocation hit a stream-idle timeout after ~39 minutes and 55 tool calls, mid-engagement. The boatman had completed the rewrite-and-push (verified via the project worktree's reflog and via `gh pr view 3232`) but had not yet posted the explanatory comment on #3232, the forward-link on #75, or written its `result` journal entry. The liaison completed those three follow-ups directly:

- Explanatory comment on #3232: https://github.com/endojs/endo/pull/3232#issuecomment-4446896418 (one transient `connection reset by peer` from gh's GraphQL endpoint on the first attempt; succeeded on retry).
- Forward-link comment on #75: https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4446890236.
- Boatman's `result` entry written by the liaison from filesystem and upstream evidence: `entries/2026/05/14/021500Z-result-boatman-7c5e8a.md`.

**Verification before dispatch**: the liaison verified strictly-forward-progress before authorizing the force-push (per user direction). Confirmed:

- `feat(chacha12)!: refactor to {next, getState, clone, fillRandomBytes}` adds the new surface as a foundation for a future pure-rand-v8 adapter.
- Pure-rand / fast-check work properly extracted to private test package `packages/chacha12-fast-check-test/`. Pure-rand-v8 adapter itself deferred per user direction.
- All `chacha12` surface from `b61c928e` preserved; one new export added (`makeChaCha12FromState`).
- New tests cover the new surface (oracle keystream fixtures + surface tests in `chacha12.test.js`).
- Two deleted "test files" (`packages/{random,chacha12}/test/index.test.js`) were `test.skip('placeholder')` TODOs at `b61c928e` — no real coverage lost.
- One stale README link in `packages/random/README.md` to a non-existent `../random-fast-check/README.md` was already broken at `b61c928e` (pre-existing, not in scope for this dispatch).

**Worktree triple for `boatman--ferry-random-chacha12-75--20260514-005221--13bf86`** to be torn down next; index entry to be flipped to `status: collected`. Done after this entry pushes.

Self-improvement: liaison side picked up two procedural notes worth holding for the eventual `skills/pr-handoff/SKILL.md` write-up:
1. **Recovery-from-stream-timeout pattern.** When a long-running boatman dispatch times out mid-stream, the orchestrator should: check upstream state via `gh pr view`, check the project worktree's reflog, decide whether the substantive work landed, and complete any soft-touch follow-ups (PR comments, journal entries) directly rather than re-dispatching. Saves a fresh full dispatch for work that is mostly already done.
2. **Verification-before-force-push for an in-flight upstream PR with active review** is the right gate. The user's "make sure it is strictly forward progress" framing combined with the boatman's earlier blocking discovery produced a clean outcome: rewrite preserves the prior review-thread anchor, the seven new commits show reviewers exactly what changed, and the explanatory PR comment makes the rebase explicit rather than surprising.
