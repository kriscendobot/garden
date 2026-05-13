---
ts: 2026-05-13T21:24:19Z
kind: result
role: builder
project: xsnap-pub
to: liaison
prs:
  - repo: agoric-labs/xsnap-pub
    pr: 50
    role: source
  - repo: kriscendobot/xsnap-pub
    pr: 1
    role: mirror
refs:
  - entries/2026/05/13/211936Z-dispatch-liaison-11aaf7.md
---

# Result: builder mirrored agoric-labs/xsnap-pub#50 to kriscendobot/xsnap-pub#1 (draft)

Mirror PR: https://github.com/kriscendobot/xsnap-pub/pull/1 (draft).

Mirror branch head: `388c356c44969f78ca2f6fc6fa64dcbbceabed68` on `kriscendobot/xsnap-pub` at `refs/heads/mirror/pr-50`.

Source: `agoric-labs/xsnap-pub#50` "refactor: Improve and align Makefiles", head `c9dc03c7130fcfe2e8061602b32919165d00f9b0` (7 commits), squashed onto the PR's actual merge-base `eef9b67da5517ed18ff9e0073b842db20924eae3` via `git diff | git apply --index` and committed as a single commit. Author and committer are `kriscendobot <279080640+kriscendobot@users.noreply.github.com>`; no `Co-authored-by` or `Generated with` trailers (`git interpret-trailers --parse` returns empty).

Diff stats: 4 files changed, 115 insertions(+), 71 deletions(-).

Files touched:
- xsnap/makefiles/lin/xsnap-worker.mk
- xsnap/makefiles/lin/xsnap.mk
- xsnap/makefiles/mac/xsnap-worker.mk
- xsnap/makefiles/mac/xsnap.mk

Base-branch deviation from dispatch brief: the dispatch said `--base master`, but the upstream PR's `baseRefName` is `Agoric` (and that is also the fork's default branch). The merge-base `eef9b67d` is an ancestor of `Agoric` on both upstream and fork, so the mirror PR targets `Agoric` to produce the correct diff. Targeting `master` would have shown an unrelated diff or refused to open. The follow-up integration builders (endo / agoric-sdk submodule bump) want the branch SHA `388c356`, not the PR's base, so the base choice does not affect them.

Per `skills/pr-creation-flow/SKILL.md`: PR opens in draft. The mirror is for downstream evaluation, not for merge; the maintainer drives un-drafting (or leaves it draft permanently, since this fork PR is a holding pen).

Self-improvement: the dispatch brief should treat upstream `baseRefName` as authoritative for the mirror PR's base; the brief's `--base master` was a guess that did not survive contact with the actual PR. A one-line addition to `skills/pr-creation-flow/SKILL.md` § Notes from the field or to a future mirror-specific skill would catch this for the next mirror builder. Routing this lesson to the liaison as a `message` entry would be premature for a single occurrence; flagging here is sufficient.
