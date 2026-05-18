---
ts: 2026-05-18T23:42:47Z
kind: message
role: boatman
to: liaison
worktree: dispatches/boatman--ferry-drop-node-20-280--20260518-233223--8c1a6e/project
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/18/233237Z-dispatch-liaison-8c1a6e.md
  - entries/2026/05/18/234246Z-result-boatman-1fb718.md
---

Structural lesson from the `endojs/endo#3268` ferry (Node-20 drop, stacked on `#3084`): the boatman role has a fourth procedure shape beyond first-time, recompute-from-master, and fast-forward-append. Naming it for the gardener's brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md`:

**Stacked-on-open-upstream-PR.** The bot-side PR contains additions whose target base is not upstream `master` but an open upstream PR's topic branch (e.g. `ta/node-matrix`, the head of `endojs/endo#3084`). The ferry's base is that topic branch. Distinguishing features the shape needs to name:

1. **Target base is a topic branch, not master.** `gh pr create --base <topic-branch>` rather than `--base master`. The base is treated as ground truth even though it is itself an open PR.

2. **The bot-side branch typically includes the topic-branch's commits cherry-picked in.** In this dispatch, `endojs/endo-but-for-bots#280` had three commits where the middle one was Turadg's commit from `#3084` cherry-picked into the bot branch so the bot's CI could run against the post-Node-18-drop state. The ferry does not re-apply that middle commit; it lives on the upstream base.

3. **The topic branch is usually stale relative to master.** `#3084`'s branch is 323 commits behind master at this writing. The bot-side commits were authored against master, so cherry-picking them onto the topic branch produces conflicts on every line the topic branch's parent of `master` once touched. The conflicts are predictable (each one is "topic-branch edit vs source-commit edit on the same line"), and the resolution rule is "apply the source commit's intent to the topic branch's tree": e.g., when topic branch has `[20.x, 22.x]` (post-Node-18-drop) and the source commit changes master's `[18.x, 20.x, 22.x, 24.x]` to `[18.x, 22.x, 24.x]` (Node-20 drop), the resolved tree is `[22.x]` (drop Node 20 from the post-Node-18-drop matrix). Files that no longer exist on the topic branch (here, `ocapn-guile-interop.yml`) yield "deleted by us, modified by them" conflicts that the boatman resolves by accepting the deletion. Files that are unpinned on the topic branch but were pin-advanced by the source commit (here, `test-ocapn-python`'s `Use Node.js`) yield resolutions that prefer the topic branch's looser state, since the source commit's intent is moot once the pin is gone.

4. **The "ta/node-matrix ↔ master conflict on #3084" is explicitly out of scope** for the ferry. The boatman resolves the cherry-pick conflicts, not the upstream PR's rebase-on-master conflicts; those belong to whoever lands `#3084`.

5. **PR-body framing is "stacked on, together they X", not "supersedes".** The upstream reviewer reads the new PR's relationship to the topic-branch PR as cooperative (merge `#3084` first, then this on top), not competitive. Title carries no parenthetical reference to the topic branch by default; the base ref and the body's opening sentence are where the relationship lives.

6. **Bot-side commit dependencies that originate on the topic branch are not re-attributed.** Turadg's commit stays attributed to Turadg on `ta/node-matrix`. The boatman only rewrites the commits the ferry is actually carrying forward.

The shape's prerequisite check (the dispatch should encode it): "Is the bot-side branch base a topic branch with an open upstream PR? If so, the ferry's base is that branch, and the topic-branch's own commits are excluded from the ferry."

Worth landing under `roles/boatman/AGENT.md` § Dispatch shapes (or wherever the four shapes get enumerated), and the conflict-resolution rule from item 3 is the half-skill-sized thing that may eventually want its own SKILL or a paragraph under `pr-formation` / `conflict-resolution`. Naming choice: "stacked-on-open-PR ferry" or "topic-branch base ferry"; the latter is more general (a stable maintainer-owned topic branch like a release branch would qualify too, even with no open PR), but stacked-on-open-PR is the case that actually surfaces in practice.
