---
ts: 2026-06-03T05:59:48Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/055712Z-dispatch-liaison-4d496e.md
---

Shape-2 re-ferry of the rebased bots#244 onto `endojs/endo#3263` to clear the PR's CONFLICTING state. Recomputed from the rebased source onto current endo master and force-pushed to the existing branch.

**Host preconditions:** `gh auth status` showed `kriskowal` active; `gh api repos/endojs/endo --jq .permissions` reported `push: true` (admin/maintain true). `origin/master` tracking ref verified against `git ls-remote origin refs/heads/master` == `ba26f4cdba760...` (matches the source base exactly; no stale-ref correction needed).

**Source:** endojs/endo-but-for-bots#244, head `dbe04c499`, base `ba26f4cdb` (== endo master). Fetched via `refs/pull/244/head` (the bare SHA was not a fetchable ref). Two commits: `5dc0e2095` (migration: eslint numeric-separators rule + autofix across 45 files) and `dbe04c499` (`chore: Update yarn.lock`). Both cherry-picked cleanly onto `origin/master` (source base equaled master, so no conflicts; yarn.lock applied without regeneration).

**Attribution:** rebased with `--exec '... commit --amend --reset-author ...'` under the kriskowal `-c user.*` override. Both commits now show `Kris Kowal <kriskowal@kriskowal.com>` as author AND committer. Source subjects carried no `(#244)` suffix and no trailers; trailer gate (`interpret-trailers --parse`) EMPTY on both commits.

**Net-diff fidelity:** `git diff origin/master..HEAD --name-only` file set is byte-for-byte identical to `git diff ba26f4cdb dbe04c499 --name-only` (44 files + yarn.lock; `diff` of the two lists empty). The eslint-plugin numeric-separators rule wiring is present in `packages/eslint-plugin/lib/configs/internal.js` (`unicorn/numeric-separators-style` block).

**Push:** force-with-lease against prior tip `4d039c3c7...` succeeded: `+ 4d039c3c7...eef8f2fc9 HEAD -> kriskowal-eslint-numeric-separators-style (forced update)`. New #3263 head SHA: **`eef8f2fc9fd73418c3cb6087464fa70536516f01`** (short `eef8f2fc9`).

**Post-push state:** `gh pr view 3263` → `mergeable: MERGEABLE` (CONFLICTING cleared), `reviewDecision: REVIEW_REQUIRED` (unchanged). PR 3263 had only a `COMMENTED` review from turadg (member) at commit `512438a2`; no APPROVED state existed, so nothing was dismissed. Title/body left unchanged. CI: full suite freshly triggered, all 17 checks `pending` at report time (run 26866674196 and siblings); not waited on.

**Cross-link:** PATCHed garden-side comment id `4579718869` on endo-but-for-bots#244 from `(head 46de1875b)` to `Mirror of https://github.com/endojs/endo/pull/3263 (head eef8f2fc9).` No upstream-side comment (retired 2026-05-29); no `message: boatman → steward`.

Self-improvement: nothing this time. The dispatch prompt's `git fetch <url> <sha>` step failed (a bare commit SHA is not a fetchable ref on GitHub); fetching `refs/pull/244/head` recovered it cleanly. This is already well-known boatman practice, not a gap worth encoding.
