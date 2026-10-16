Fix round 1 for kriscendobot/minion.town#192 is done: I pushed the fixes for the panel's must-fix items as commit `b1a2afc`, and CI is green (`ci-wait-merge.sh` returned rc 0).

**What changed in `deploy/aws/scripts/lib/install-node22.sh`** (the shared helper the three deploy scripts call):
- **Untrusted installs are reinstalled, not re-owned** (locksmith 1–2, breaker 1, wire-watcher 1). An existing install is kept only if a root-owned stamp at `share/doc/node/install-sha256` records the pinned digest, and no Node entry, `/usr/local`, or directory holding an entry is non-root-owned or group/other-writable. Otherwise the Node entries are deleted and reinstalled from the checksummed tarball. The helper no longer runs `node --version` as root to decide, and a v22 that isn't the pinned build now gets replaced.
- **Safer download:** it goes into a `mktemp -d` directory that is removed on every path, instead of the fixed `/tmp/node.tar.xz` (locksmith 3, breaker 3, wire-watcher 2, corner-prober 4).
- **Input checks:** the digest must be 64 lowercase hex characters before it's used (wire-watcher 3), and the helper refuses to proceed if any of the `/usr/local` directories it manages is a symlink (breaker 4).
- **No more aborts on missing paths:** every `chown`/`chmod` is skipped when its path doesn't exist, so a prefix holding only `node` no longer stops the deploy (breaker 2, corner-prober 1).
- **Permissions:** directories are locked before the reinstall and again after it. `chmod -R go-w` now covers all Node entries, and a symlinked entry gets `chown -h` instead of having its target changed (locksmith 4, wire-watcher 4, corner-prober 2).

**Tests (`test/install-node22.test.ts`, 19 pass):**
- The `chown` stub now fails on a missing path, like the real command.
- New cases cover reinstalling (without running the old `node` and with planted files removed) when:
  - `node` is writable;
  - a deep file under npm is writable;
  - `bin` is writable;
  - the stamp is missing;
  - the owner isn't root;
  - the pinned digest changed.
- Also new: a prefix holding only `node`, a symlinked directory, empty/uppercase/short/wrong digests, and a failed download leaving no temp files behind.
- One test inlines `$INSTALL_NODE22` through an unquoted heredoc and confirms the text comes out unchanged and passes `bash -n` (corner-prober 6: the variables survive inlining).

**Docs and PR body (pruner):** I cut the comments that just restated the code, fixed the test header's reference to a nonexistent `FIXTURE_VERSION` constant, and folded the duplicated `DEPLOYMENT.md` bullet into one. The PR body is down from 360 to 269 words and keeps its garden-job marker.

**Checks:**
- vitest passed on `install-node22`, `deploy-*` and `claude-cli-deployment` (44 tests).
- `tsc --noEmit`, `shellcheck -s bash` on the helper, and `bash -n` on the three deploy scripts are clean.
- CI run `test (typecheck + vitest)` on `b1a2afc` succeeded.

**Things to know:**
- The first deploy after this merges will reinstall Node on each box once, because no stamp exists yet. That is the intended repair.
- On this host, run the tests with `TMPDIR=/var/tmp`. Under the default `TMPDIR` (on the shared virtiofs mount) two tests fail because that filesystem briefly reports freshly made directories as owned by uid 0. They pass on a normal filesystem, and CI is green.
- My first background `ci-wait-merge` was killed at the 10-minute tool limit. I polled the Actions API in the foreground until the run finished, then re-ran `ci-wait-merge` to get its rc 0.
- Left unchanged on purpose: the duplicated usage note in `common.sh` (pruner 3, borderline), which matches how the sibling helpers there are written, and the concurrent-deploy race (corner-prober 7, comment-only). Prettier already flagged `DEPLOYMENT.md` on the base branch, so I didn't reformat it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3823679 cached reads)
- Output: 32178 tokens
- Cost: $2.2115438000000003
- Wall-clock: 1851s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
