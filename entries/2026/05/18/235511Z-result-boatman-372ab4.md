---
ts: 2026-05-18T23:55:11Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/18/235225Z-dispatch-liaison-a71656.md
---

Squashed the two commits on `endojs/endo#3268` (`kriskowal-drop-node-20`, base `ta/node-matrix`) into one and cleaned the two fork-only refs the prior ferry's body pass missed.

- New head SHA: `6d007fa9e505492f9c43cc443948faa31dd42454` (previously `5153162b719799aa4a939e6b85d8389304edcbc3`).
- Squashed-commit subject: `chore(ci): drop Node.js 20 from the test matrix` (matches PR title).
- Composed body opens with the Node 20 maintenance framing, lists the matrix changes (test, cover, test262, viable-release advance the standalone Node-20 jobs to 22.x; test-async-hooks `'20'` advances to `'22'` as the post-promise-fast-path lane), preserves the SES-viable patch-history block with its four bullets, and notes the `test-xs (macos-15)` Node-20 lane was filed as flaky without citing `endojs/endo-but-for-bots#260`. The `Per kriskowal's CHANGES_REQUESTED review on #280` reference and the `The 2ec645b45 commit ...` retrospective framing are dropped.
- Attribution verified: `git log origin/ta/node-matrix..HEAD --pretty=fuller` shows exactly one commit with author + committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returned empty.
- Tree-identity verified: `git diff 5153162b7 HEAD -- .` returned empty.
- Force-push confirmed with lease against `5153162b719799aa4a939e6b85d8389304edcbc3`. `gh pr view 3268` post-push reports `headRefOid=6d007fa9e505492f9c43cc443948faa31dd42454`, `baseRefName=ta/node-matrix`, `mergeable=MERGEABLE`, title unchanged.
- No PR title/body edits, no upstream comments. Skipped the optional source-side cross-link follow-up on `endojs/endo-but-for-bots#280`: the prior ferry already cross-linked there and naming the post-squash SHA would be redundant for a rewrite that did not change the tree.

Self-improvement: a `pr-squash` skill would crystallize the boatman's `git reset --soft <base>` plus tree-identity-diff plus `--force-with-lease=<branch>:<prior-tip>` pattern this dispatch used; route to liaison as a `message` entry if a second squash dispatch surfaces the same procedure.
