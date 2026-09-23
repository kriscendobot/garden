---
ts: 2026-05-15T01:41:19Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/013511Z-dispatch-liaison-9224ee.md
  - entries/2026/05/15/013950Z-result-boatman-b39a13.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: source
  - repo: endojs/endo
    pr: 3263
    role: target
---

First-time ferry of `endojs/endo-but-for-bots#244` opened as `endojs/endo#3263` (DRAFT).

- Upstream PR: https://github.com/endojs/endo/pull/3263, draft confirmed.
- Branch: `kriskowal-eslint-numeric-separators-style` on base `master` (`0ec70c6dd` at fetch time).
- Four commits in order, all author + committer `Kris Kowal <kris@cixar.com>`, zero bot trailers:
  - `6f19761da` chore(eslint-plugin): require underscore-delimited groups in numeric literals
  - `180e184b2` chore: Update yarn.lock
  - `7faa80774` chore: migrate numeric literals to underscore-delimited grouping
  - `b583f9259` chore: prettier --write on autofix-touched files
- 44-file autofix cherry-pick auto-merged cleanly against the 28-commit upstream gap; no manual conflict resolution.
- Title carried verbatim from source (`chore(eslint-plugin): require underscore-delimited groups in numeric literals`); already upstream-native. Body rewritten per `pr-formation`: endo template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior over diff, the bot-internal `This PR mirrors #243 onto master.` line dropped, the two pre-existing ESLint warnings on `evasive-transform/src/index.js` and `ses/src/compartment.js` and the seven Prettier line-length warnings retained as out-of-scope reviewer context, with the prettier-warning note updated to reflect that commit 4 reflowed those files. Bot-internal `(fix lint job on #244)` subject suffix on commit 4 stripped during the `--reset-author` amend.
- Source-side cross-link on #244: [issuecomment-4456140724](https://github.com/endojs/endo-but-for-bots/pull/244#issuecomment-4456140724), posted under kriskowal.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the boatman's `cherry-pick + amend --reset-author --no-edit per commit` pattern is now twice-applied (this dispatch and the prior #253 re-ferry), with both runs needing to rewrite at least one bot-internal commit-subject reference during the amend (#253's commit-subject footers from kriscendobot's CI, this one's `(fix lint job on #244)`). The boatman role file already anticipates a `skills/pr-handoff/SKILL.md`; with this dispatch the pattern has its second concrete data point and the boatman's structural-lesson threshold is met. **Liaison follow-up**: queue a gardener dispatch in a future session to land `skills/pr-handoff/SKILL.md` (cherry-pick + amend pattern, attribution rewrite, the conflict-handling guidance, the "recompute from master vs cherry-pick on prior tip" branch from `entries/2026/05/14/061345Z-result-boatman-bf7290.md`, and the "post under whichever identity is authenticated" cross-link discipline from `entries/2026/05/15/000521Z-result-liaison-02ccd8.md`). Not in this session, but ready for the next gardener engagement.
