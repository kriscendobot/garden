## Gauntlet fix round 5: kriscendobot/minion.town#192

I applied the round-5 panel's must-fix items and pushed `bc97cca` and `0969cf9` to `fix/node-install-root-ownership` through `safe-push-pr-head.sh`. CI is green on `0969cf9` (`ci-wait-merge` rc 0). The first push went red because of a bug in my own test, which the second commit fixes.

**What changed, by panel theme**
- **Content-addressed Node install (decomplector):** I rewrote `lib/install-node22.sh` so each checksummed tarball unpacks as root, with `--no-same-owner`, into its own `/opt/node/<sha256>`. It gets there by renaming a finished unpack, and `/opt/node/current` is switched atomically to point at it. The installer now only checks that `/opt/node` and its parent are root-owned and not writable by others. The old `/usr/local` audit is gone: the stamp file, the fixed entry list, the ACL walk, the symlink containment check and the chown/setfacl repairs. The file went from 166 to about 60 lines, and the test suite was rewritten to cover the new design (27 tests).
- **Node paths:** every systemd unit, deploy script and helper now runs `/opt/node/current/bin/node` (and `corepack`). The gateway, gateway-gc and git-remote deploys install units that run Node but don't install it themselves, so they now refuse to run if `deploy-app.sh` hasn't installed it yet.
- **`sudo` lookups through `/usr/local` (locksmith, saboteur, wire-watcher, breaker, purist):** a new `lib/system-path.sh` is put at the start of every SSM script by `ssm_invoke`. It sets a system-only `PATH`, and wraps `sudo` so its command runs through `/usr/bin/env` with that `PATH` rather than sudo's own lookup path, which searches `/usr/local` first.
  - This covers `ensure_setfacl`'s `sudo env apt-get` and every later bare `sudo` call in all remote scripts, not just the three that install Node.
  - The new test decodes the SSM payload that is actually sent, rather than the script source.
  - The three Node install sites no longer call `ensure_setfacl`, since Node no longer needs ACL tooling.
  - `xargs sudo rm` became `xargs rm`.
  - The port-orphan reaper, which systemd runs as root, now sets the system `PATH` too.
- **Pruner and PR body:** the three copies of the trusted-PATH comment are gone (it is now stated once, in `system-path.sh`), and the `DEPLOYMENT.md` bullet is down from 22 lines to 11. I rewrote the PR body (253 words, first line no longer panel jargon) and retitled the PR "fix(deploy): install Node into a root-owned /opt/node tree". I reverted the `deploy-secret-preflight` test change, which the new prelude makes unnecessary.

**Not done / follow-ups**
- **Old installs on existing boxes:** the earlier Node install and its build-uid-owned directories in `/usr/local` are left on the box. Nothing the deploy runs uses them any more, and `DEPLOYMENT.md` documents removing them as a manual step.
- **Old releases:** previous `/opt/node/<sha256>` releases are never deleted.
- **Not run on the live box:** none of this was run against the real instance, which needs SSM.
- **Local test failures:** a full local test run had a few timeout and git-environment failures in `git-remote/capability`, `git-remote-e2e` and `endo-guest-lockdown`. This PR doesn't touch those tests' code, and they passed in CI.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (6017660 cached reads)
- Output: 45844 tokens
- Cost: $3.2791080000000004
- Wall-clock: 3228s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
