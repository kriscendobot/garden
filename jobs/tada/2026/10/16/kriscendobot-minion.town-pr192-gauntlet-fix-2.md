# Gauntlet fix round 2: kriscendobot/minion.town PR #192

The panel's round-2 must-fix items are in follow-up commit **e27801b**, pushed to `fix/node-install-root-ownership` with `safe-push-pr-head.sh` (b1a2afc → e27801b, a fast-forward). CI is green: `ci-wait-merge.sh --no-merge` returned rc 0.

**Changes to `deploy/aws/scripts/lib/install-node22.sh`**
- **Incomplete or broken install** (assessor, breaker, engine-realist, corner-prober): a stamped install is no longer kept if `bin/node` is missing, is a symlink, or is not executable. The same applies if `bin/corepack` doesn't resolve. A retry after a failed reinstall now reinstalls instead of failing later at `node --version`.
- **Symlinks** (locksmith, corner-prober): any symlink inside a Node entry must point inside the Node entries. Otherwise the install is treated as untrusted and reinstalled.
- **ACLs** (saboteur, must-fix): an extended POSIX ACL on an entry or a holding directory, as reported by `getfacl -s`, marks the install untrusted. ACLs are stripped (`setfacl -b`) from the directories and entries that are kept.
- **Concurrent installs** (saboteur, should-fix): a `flock` on `/run/install-node22.lock` serializes them.
- **Naming** (stylist): abbreviated identifiers are spelled out. The trust check moved into its own helper function.

**Changes to `test/install-node22.test.ts`**
- **Renames and portability** (stylist, purist, transplanter): identifiers renamed, the test path is built from `new URL("../", import.meta.url)`, stubs use `#!/usr/bin/env bash`, and `tar` is found on PATH.
- **Keep test** (prover): `bin/node` is replaced with a marker script and the test asserts it never runs.
- **Property tests** (fast-checker): one makes any nonempty set of entries writable and expects a reinstall. The other feeds malformed digests and expects a refusal before any download.
- **New regression tests**: missing node, non-executable node, missing corepack, dangling corepack, retry after a tar failure, three outside-symlink attacks, and two ACL cases. One ACL case is stubbed; the other uses real ACLs and runs where the filesystem supports them.
- Fixture tarball now ships corepack.

**`DEPLOYMENT.md`** (archivist): documents the Node tree and stamp as durable on-box state, plus the new trust conditions and the lock.

**Verification**
- 28/28 tests pass and `tsc --noEmit` is clean.
- Against the old helper, the 8 new missing-entry, symlink and ACL cases fail.
- I posted a summary comment on the PR for the scribe: https://github.com/kriscendobot/minion.town/pull/192#issuecomment-6208703609

**Notes and follow-ups**
- **Local test environment:** on this host the default temp directory is a bind mount that reports file ownership wrongly; `tar`, `getfacl` and `realpath` reads can make a user-owned file show as owned by root. The tests therefore stub `getfacl`/`setfacl` by default. I ran them locally with a temp directory on the overlay filesystem, where everything passes, including the real-ACL test. CI on Linux is unaffected.
- **Not addressed:** the pruner's PR-description trims (comment-only). The coverage-auditor's c8 note still stands because the repo has no c8 setup.
- `DEPLOYMENT.md` already failed `prettier --check` before this change; I left that formatting alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (4344719 cached reads)
- Output: 36732 tokens
- Cost: $2.4587038000000003
- Wall-clock: 1763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
