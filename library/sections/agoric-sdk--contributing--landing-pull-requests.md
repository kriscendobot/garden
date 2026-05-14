---
title: Landing pull requests
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: Stricter than typical: every commit following the leftmost parent from main/master must pass CI (not just the merge commit). Has an interesting carve-out where a sequence of non-buildable commits is preserved if the merge commit passes CI and the bad commits aren't reachable from a left-hand-rule traversal.
---

> Abstract: agoric-sdk's PR-landing agreement. Conventional Commits for every commit. Every commit reached by following leftmost parents from main/master must pass CI tests (not just the merge commit). Follow-up commits are encouraged during incremental review but should not survive to land on main/master. Rebases are necessary to confirm continued CI passing as main moves. "Squash and merge" is the default. The xsnap-introduction history is the canonical example of preserving a multi-commit narrative through a merge commit; left-hand-rule traversal of parents keeps `git bisect` working even when intermediate commits don't build.

## Landing pull requests

The agreement so far is for every change to have a [conventional commit message][CC] and for every commit following the leftmost parent from main/master to pass tests in CI.

```
* Must pass
* Must pass
* Merge commit must pass
|\
| * Fixed the broken code
| * Adopted some broken code from somewhere
|/
* Must pass
* Must pass
```

We also have agreement, once code review has begun, that we should as often as practical append commits with follow-up changes so subsequent reviews can be incremental, but that these follow-up commits should not survive to land on main/master.
This does not preclude rebases, which are necessary to confirm that the PR continues to pass tests as the main/master branch moves under it.

We favor "Squash and merge" (which requires the PR title to be a conventional commit) since it requires the least careful attention, especially when there are appended follow-up changes, but it's not the only tool in the toolbox.

For example, we preserved the narrative of the `xsnap` introduction as a sequence of commits (1. Moddable contributions, 2. our C changes, 3. our JS wrapper) with a merge commit for the PR ("Create a merge commit"). Step 1 wasn't buildable and step 2 had no tests, but the merge commit passes CI and all the others non-working commits are not reachable by a left-hand-rule traversal of the parents, so `git bisect` will still work if we need it.

We've also squashed follow-up commits manually (through an interactive rebase) after a PR had been approved and tests were passing, then landed the stack with "Rebase and merge" or "Create merge commit".

For details on authoring, merging, and reviewing PRs, see [Pull Requests Guidelines](https://github.com/Agoric/agoric-sdk/wiki/GitHub-Pull-Requests).

[CC]: https://www.conventionalcommits.org/en/v1.0.0/

Source: [CONTRIBUTING.md](https://github.com/Agoric/agoric-sdk/blob/de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22/CONTRIBUTING.md) at commit `de2c4cbc`.
