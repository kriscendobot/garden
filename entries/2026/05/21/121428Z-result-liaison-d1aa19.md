---
ts: 2026-05-21T12:14:28Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/120903Z-dispatch-liaison-d1aa19.md
  - entries/2026/05/21/121259Z-result-boatman-5dc7e7.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 334
    role: source
  - repo: endojs/endo
    pr: 2887
    role: target
---

Re-ferry of #334 closed.

- Upstream PR head: `09874b709` → `9efd4cac5b09bcdf400fc7eaa14af6fefaece86a` via force-push-with-lease (lease satisfied).
- **2 commits**, both author + committer `Kris Kowal <kriskowal@kriskowal.com>` (rewriting source's `kris@agoric.com` and `endolinbot` respectively), zero trailers:
  - `30add7ceb` fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes
  - `9efd4cac5` docs(compartment-mapper): consistent node: import prefix in README
- Path-restricted tree-identity check used (`PATHS=packages/compartment-mapper/README.md`; diff empty).
- **boneskull's APPROVED persists** (anchored on `09874b7`; branch is unprotected).
- The upstream now reflects the dropped `src/node-modules.js` blank-line hunk that the bot's reshape identified as moot (per the source PR body).
- Source-side cross-link on #334: [issuecomment-4508148105](https://github.com/endojs/endo-but-for-bots/pull/334#issuecomment-4508148105).
- Title and body untouched on #2887.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: nothing structural this turn. The recompute-from-master + path-restricted tree-identity check pattern continues to apply cleanly; the boatman performed without surfacing new lessons.
