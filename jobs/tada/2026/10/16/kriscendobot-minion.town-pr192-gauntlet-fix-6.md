**Fix round 6 for kriscendobot/minion.town PR #192: done, CI green.**

I pushed commit `b672cdb` to the PR head `fix/node-install-root-ownership`, fast-forwarding it from `0969cf9` through `safe-push-pr-head.sh`. It addresses both must-fix items from the round-6 panel review (5548759784) and one should-fix.

1. **corepack couldn't find `node`.** corepack runs through `env node`, and the new restricted PATH didn't include the Node directory. In `deploy-endo-daemon.sh` and `deploy-npm-registry.sh`, both corepack calls (`corepack enable` and the one run as the service user) now get `env PATH=/opt/node/current/bin:/usr/sbin:/usr/bin:/sbin:/bin`. A new test checks that.
2. **Root still trusted files under `/usr/local`, which the old Node install's build user owns on older boxes.** I added a `reclaim_usr_local` function to `lib/system-path.sh`, the shared preamble every deploy script runs on the box. It:
   - hands `/usr/local` to root (`chown -R -h root:root`);
   - removes group and other write access (`chmod -R go-w`);
   - then deletes the old Node files.

   It changes ownership before deleting so the build user can't redirect the deletion through a symlink, and it refuses to run if `/usr/local` is itself a symlink. `deploy-app`, `deploy-endo-daemon`, `deploy-npm-registry` and `deploy-oauth2-proxy` call it before they write or run anything under `/usr/local`. The `DEPLOYMENT.md` paragraph and the `common.sh` comment now describe this instead of a manual cleanup.
3. **Wider regression test.** The panel asked for this to go beyond the Node-binary grep. It's now a per-script check: any deploy script that names `/usr/local/` outside a comment must call `reclaim_usr_local` first. New tests also cover what the reclaim does, including that it leaves symlinks alone and refuses a symlinked `/usr/local`.
4. **Should-fix: the `sudo` wrapper.** It now refuses any option other than `-u`, `-g`, `-n`, `-E`, `-H` and `--`, so an option's argument can't be mistaken for the command. A test covers this. The other half of that item was child shells that bypass the wrapper and use `sudo`'s own command lookup. That's no longer exploitable once `/usr/local` belongs to root, so I didn't add a sudoers drop-in.

I also posted the summary comment the scribe asked for, covering this push and the rounds 4–5 `/opt/node` redesign: https://github.com/kriscendobot/minion.town/pull/192#issuecomment-6217289377

**Testing:** the 66 tests in `install-node22`, `endo-pin-drift` and `git-remote-partition-script` pass locally. `ci-wait-merge.sh` returned 0: one Actions run, no failures. The bot token can't read the PR's combined status checks, so CI was judged from the Actions run alone.

**Not done:** the pruner's wording cleanups (duplicated comments, collapsing the PR body's Behavior section) were left for a later round. `DEPLOYMENT.md` fails Prettier's check, but it already did on main and CI doesn't check it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1653314 cached reads)
- Output: 18927 tokens
- Cost: $1.3722827999999996
- Wall-clock: 1365s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
