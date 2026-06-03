---
ts: 2026-06-03T05:48:21Z
kind: dispatch
role: liaison
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Dispatched weaver (dispatch-root `dispatches/weaver--f24468`) to **rebase + resolve conflicts** on the bot-side mirror endo-but-for-bots#244 (numeric-separators eslint migration) — stage 1 of making its upstream mirror endojs/endo#3263 mergeable. Stage 2 (boatman re-ferry to #3263) follows.

State: both #3263 and bots#244 are CONFLICTING. bots#244 head `e10ba6ba6`, base master, merge-base with current master `814dfa1fd`; current master `ba26f4cdb`. Real conflict set (files changed on BOTH master and the PR): `package.json` (root), `packages/eslint-plugin/lib/configs/internal.js` (the PR's core rule addition), `packages/eslint-plugin/package.json`, `packages/evasive-transform/src/index.js` (autofix-touched), `yarn.lock`. Not a mechanical-only conflict.

Weaver brief: rebase bots#244 onto current bots master per frozen-base-branch (new frozen base at current master, update PR base). Resolve per conflict-resolution (NO --ours/--theirs): merge the numeric-separators rule into internal.js alongside master's config changes; merge dep changes in both package.jsons; re-apply numeric separators to master's version of evasive-transform/index.js; regenerate yarn.lock (separate `chore: Update yarn.lock` commit). After rebase, run `yarn lint` to confirm the numeric-separators rule passes across current master; if master introduced NEW violating literals, `yarn lint --fix` to extend the migration to cover them (that is the correct behavior for rebasing an autofix-migration PR) and fold into the migration commit. Force-with-lease push; create the new frozen base; `gh pr edit 244 --base <new-frozen-base>`. Bot identity. If any conflict needs a judgment call beyond mechanical re-autofix/merge, surface it. Report the new head, the resolution summary per file, and the lint result so the liaison can brief the boatman re-ferry.
