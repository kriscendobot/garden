I applied the round-10 must-fix items to kriscendobot/minion.town#192 and pushed them as one follow-up commit, `768b651` on `fix/node-install-root-ownership`. CI is green: `test` and both Claude harness jobs (amd64, arm64) passed, and `ci-wait-merge.sh --no-merge` returned rc 0.

Four seats requested changes: decomplector, breaker, wire-watcher and pruner. What I changed for each:

**Decomplector (the one must-fix: the `/usr/local` repair duplicates the `/opt/node` move)**
- The SSM prelude `lib/system-path.sh` now only sets the system `PATH`. I removed the sudoers `Defaults:root secure_path` drop-in, the reclaim that ran on every call, and its marker file. That also settles wire-watcher's point about a forged marker, since there is no marker any more.
- The reclaim is now an explicit, rerunnable operator step: `deploy/aws/scripts/reclaim-usr-local.sh`, with its function in `lib/reclaim-usr-local.sh`. You run it once per box, including the `ci.minion.town` runner via `INSTANCE_ID`.
- Its header and `DEPLOYMENT.md` state wire-watcher's residual risk: the reclaim makes whatever it finds in `/usr/local` root-owned without checking it. They list the deploys to rerun afterwards.
- I dropped `_link_legacy_node` from `install-node22.sh`. The repository copy of `endo-ocapn-daemon.service` already runs `/opt/node/current/bin/node`. Until someone installs that copy on the box, the old unit keeps running the legacy `/usr/local/bin/node`; `DEPLOYMENT.md` says so.

**Breaker and wire-watcher (oauth2-proxy)**
- `deploy-oauth2-proxy.sh` now pins release v7.15.5, the tarball sha256 and the binary sha256. Before, it always took the latest release and checked nothing.
- I took both digests from the v7.15.5 assets and computed them myself; they match the release's published sha256sum files.
- It no longer downloads on every deploy. It replaces `/usr/local/bin/oauth2-proxy` only when the installed file's digest differs, and never runs the old file before that check.
- It checks the tarball digest before extracting (now with `--no-same-owner`) and the binary digest before installing. The tag and both digests are format-checked before any AWS call, and new tests cover malformed values.

**Breaker (smoke test PATH)**
- The `claude` binary is native, and the app spawns it with `PATH=/usr/bin:/bin` (`CHILD_PATH` in `src/endo/claude/cli-provider.ts`). The three smoke runs in `deploy-app.sh` now use that same PATH, and a new test holds them equal to `CHILD_PATH`.

**Pruner**
- I cut the `common.sh` header comments that repeated the lib files' own headers.
- I rewrote the PR body: the mechanism lists became outcome bullets that point to `DEPLOYMENT.md` and `system-path.sh`.

I updated `test/install-node22.test.ts` to match. Locally the installer suite (35 tests) and typecheck pass. The full suite had one local failure, in `test/git-remote/capability.test.ts`, which this PR doesn't touch; the same suite passed in CI.

Things to decide on:
- **The oauth2-proxy pin changes what the live box gets.** CD runs `deploy-oauth2-proxy.sh` on every main push, so after merge it will replace the live binary with v7.15.5 if it is a different version. Before this change it always took the latest release.
- **Two operator steps need SSM, and I ran neither.** Running the reclaim script once on each box, and installing the repository's `endo-ocapn-daemon.service`.
- I didn't act on the comment-only notes: pruning old `/opt/node` releases and simplifying the installer's ownership checks.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (5095499 cached reads)
- Output: 27515 tokens
- Cost: $2.6091998
- Wall-clock: 2426s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
