---
orchestration-failed: true
---
**CI is RED.** `ci-wait-merge.sh` returned rc=3 because one of 36 checks failed: `cover (22.x, ubuntu-latest)`. That job's only failing test is `bwrap › bwrap timeout and repeated cancellation reap process groups` (`process group 5849 survived bounded cleanup`, `packages/sandbox/test/bwrap.test.js:1099`). This matches the known ubuntu-26.04 sandbox breakage that hits every PR. The PR doesn't touch `packages/sandbox`, and the 24.x cover job passed. I couldn't rerun the job: this host's bot token gets 403 on `gh run rerun`.

## What I did

I worked from the latest panel review, 5723552735 (head `a5e66392`). There was no pre-pass block. Most of the must-fix items came from two problems, so I made the PR smaller rather than adding more casts:

- **`Directory.makeFile` couldn't be honored.** It promised a platform `File`, but `EndoMountFile`'s snapshot has an asynchronous `sha256()`. Eight jurors flagged this. I removed `makeFile` from the portable `Directory` guard and type, and kept it on `EndoMount` only. I reverted the `unknown` casts in the agent-tools, agentry and daemon git test files to their base versions. Two new type tests check that `EndoMount` is assignable to `Directory` and to `WritableGitWorktree` without casts, and they fail if `makeFile` is put back on `Directory`.
- **The `subView` name is still undecided.** On endojs/endo-but-for-bots#464 the maintainer asked for it to be called `mount`. I removed `subView` from the portable `Directory` and `SnapshotTree` and from the daemon `EndoReadableTree`. It stays where it already shipped (`EndoMount` and the extended `Directory`). This also made the warden and corner-prober findings about the snapshot `subView` moot.
- **Saboteur:** `makeFile` now re-checks that the mount is still live after asking the content source for its methods, before creating any directory or file. A new test holds that check open, revokes the mount, and confirms nothing is written; it fails without the fix.
- **Prover:** a new conformance test checks the guarded `mount.snapshot()` has every `SnapshotTreeInterface` method and that `followNameChanges` ends with no records. Both tests fail if `followNameChanges` is removed from the guard.
- **Corner-prober:** new `makeFile` tests cover an existing target with no content (returns a live file), empty-string truncation, empty and multi-chunk blobs, and a blob that fails partway through leaving the existing file intact.
- **Surfacer:** documented `EndoReadableTree.followNameChanges` in `help.md` and regenerated `help-text-data.js`. Also regenerated the agent-tools code-mode declarations.
- **Design doc (archivist, integrator):** later `streamRead` mentions are marked historical, the open question and appendix tables now match the code, and Phase 1 is described as additive behavior. Moving `subView` into the portable contracts is recorded as separate work that waits on the name decision.
- **Changeset (changeset-auditor, releaser):** rewritten as an upgrade note, one sentence per line. `@endo/exo-git` is now major, because the snapshot its worktrees return gains a required method. `@endo/agent-tools` is now minor.
- **Declined:** fast-checker's request to add `fast-check` as a new devDependency. That rule is only proposed, and the new example-based tests cover the same boundaries.

I pushed four commits with `safe-push-pr-head.sh`: `3b9923b6`, `c529b93f`, `12beca5e`, `71b6970c`. The head is now `71b6970c5cc`.

**Local checks:** all 380 `@endo/platform` tests pass, as do the daemon mount suites and the 28 agent-tools `code-mode-types` tests. `tsc` passes for platform, daemon (including `test:types`), exo-git, agent-tools and agentry. On this host 9 daemon `git` / `git-remote` tests fail because their fake-git fixtures can't run here; the changes to those test files only remove type casts.

## Follow-ups

- **Successor job `endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-pr-body`**, pinned to `host=endolin-garden-ece02cb4`. This host's token can't edit endojs PRs, so that job will update the PR description and ledger and post the summary comment the scribe asked for.
- **Maintainer message sent:** keep `subView`, or rename it to `mount`? Adding it to the portable contracts waits on that answer.
- **The red cover job needs a rerun** from a host whose token can rerun Actions jobs, or the bwrap / ubuntu-26.04 issue needs fixing first.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 164 tokens (10583068 cached reads)
- Output: 41591 tokens
- Cost: $4.3497216
- Wall-clock: 5784s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
