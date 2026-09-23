---
ts: 2026-05-15T02:14:48Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/020925Z-dispatch-liaison-af033c.md
  - entries/2026/05/15/021317Z-result-boatman-394d39.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry of `endojs/endo-but-for-bots#109` over `endojs/endo#3256` closed.

- Upstream PR #3256 force-pushed from `acddddba16` (the prior single squash) to `b5c3168655` (two-commit shape).
- Two commits in order, both author + committer `Kris Kowal <kris@cixar.com>`, zero bot trailers:
  - `e6b1a611d` feat(syrup-frame): add @endo/syrup-frame package
  - `b5c316865` feat(ocapn): add opt-in syrups framing to TCP-testing netlayer
- Cherry-pick auto-merged cleanly against the 28-commit upstream gap; the anticipated conflict risk on `packages/ocapn/*` from the interim #3257 [bytes] migration did not materialize.
- Title kept as-is (`feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`); the body was not touched. The user did not ask for a title or description update this round.
- **kumavis APPROVED persisted across the force-push**: `reviewDecision: "APPROVED"` after the push. `endojs/endo:master` is not branch-protected, so no auto-dismiss-on-force-push; the approval record stays in the PR's review array even though the commit OID it references is no longer reachable from the head. Liaison-side verification confirms the state.
- Source-side cross-link on #109: [issuecomment-4456292671](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4456292671), posted under kriskowal.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the dispatch correctly anticipated conflict risk on `packages/ocapn/*` from the interim bytes migration; in practice the cherry-pick auto-merged. The boatman's note (a future `skills/pr-handoff/SKILL.md` can favor cherry-pick-first/worry-later over pre-emptive merge analysis) is consistent with the prior #253 re-ferry's clean auto-merge across a 26-commit gap. Two consecutive re-ferries showing this pattern now; combined with the other procedural notes accreting on the boatman role, the skill extraction is overdue. Reaffirming the prior session's queued gardener follow-up — not landing inline this turn but ready for the next gardener engagement.
