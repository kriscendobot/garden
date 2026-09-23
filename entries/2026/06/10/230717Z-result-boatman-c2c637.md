---
ts: 2026-06-10T23:07:17Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/10/230229Z-dispatch-liaison-762a09.md
---

Shape-2 re-ferry of the rebuilt shellcheck mirror (endojs/endo-but-for-bots#401, head `85ebc883a`) onto endojs/endo#3300 (branch `kriskowal-shellcheck-ci`). Force-pushed; new upstream head `32d76f46b`.

Host preconditions: `gh auth status` = kriskowal active; `gh api repos/endojs/endo .permissions` = push/admin true. `identity_switch_authorized: true`. origin/master verified `b2fa365ae` via `git ls-remote refs/heads/master` (matched local). Source FETCH_HEAD = `85ebc883a` as named.

Recompute: detached at `origin/master` (b2fa365ae); cherry-picked the 4 source commits and squashed to the clean 3-commit shape per the dispatch:
1. `fix(scripts): shellcheck cleanups across tracked .sh files` (from 42c39b0c6; reworded the trailing "lands in the same PR" line to "added in the same change").
2. `chore(shellcheck): add yarn shellcheck script and CI workflow` (squash of cda73098c + fe73a4740; the argv-limit/git-blob rationale folded into the script bullet, fork-side `#401` ref dropped).
3. `chore(shellcheck): adopt die idiom for early termination in touched .sh files` (from 85ebc883a; rewrote body to drop `#401` / "this PR" fork-bookkeeping, preserved the die() helper rationale and the per-file site list).

Conflict handling: none. The stale source base (`master-4a04d07`) was a clean ancestor of current master and the touched files were unchanged on master since, so all four cherry-picks applied cleanly with no manual resolution.

Attribution + trailers: all 3 commits author AND committer `Kris Kowal <kriskowal@kriskowal.com>`; `interpret-trailers --parse` EMPTY on every commit (no Co-Authored-By / Generated-with / Refs).

Net-diff invariant: `git diff origin/master..HEAD` is byte-for-byte identical to the source net diff `85ebc883a~4..85ebc883a` (diff-of-diffs empty), including the die-idiom changes to the 3 named .sh files (packages/nat/scripts/npm-audit-fix.sh, scripts/npm-audit-fix.sh, scripts/posttypedoc.sh). Touches only the shellcheck workflow/script/package.json + the .sh files; no yarn.lock change.

Push: `git push --force-with-lease=kriskowal-shellcheck-ci:3efeaf8b3 ...` succeeded (`+ 3efeaf8b3...32d76f46b`, lease held). Post-push: head `32d76f46b`, MERGEABLE, 3 commits, REVIEW_REQUIRED (no approval). Draft state unchanged: PR was already `isDraft: false` on arrival (the dispatch described it as DRAFT; it was not). I did not toggle draft either way (a force-push does not change it) and left title/body unchanged per the dispatch.

CI: all checks pending at report time, including the now-present `shellcheck` check (the freshened base picked up the new workflow). Did not wait.

Cross-link: edited garden-side comment id `4645026707` on endo-but-for-bots#401 in place to `Mirror of https://github.com/endojs/endo/pull/3300 (head 32d76f46b).` No upstream-side comment; no message-to-steward.

Self-improvement: nothing this time. The dispatch's draft-state expectation ("still DRAFT") mismatched the live PR (`isDraft: false`), but a force-push is draft-neutral and the dispatch also said leave title/body unchanged, so the mismatch was non-blocking and is recorded here rather than as a rule change.
