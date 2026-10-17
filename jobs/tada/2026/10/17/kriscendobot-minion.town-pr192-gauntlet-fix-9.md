## Gauntlet fix round 9: kriscendobot/minion.town #192

I pushed one follow-up commit, `240a5b9`, on top of `72e8d48` on `fix/node-install-root-ownership`, using `safe-push-pr-head.sh` in advance mode. CI is green: `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing (`test`, Claude harness amd64 and arm64).

**Must-fix items from the round-9 panel, and what I did:**
- **Saboteur: bare `node` on the box.** The `ENDO_FN` snippet in `provision-guest-reminders.sh`, which ships to the box, now runs `/opt/node/current/bin/node`. I left the bare `node` in `endo-federation-box.sh`'s `FEDERATION_LOCAL=1` branch alone, because that is the local test mode and never runs on the box.
- **Decomplector: replace the `sudo` wrapper.** The wrapper and its option parser are gone. The prelude now installs a `Defaults:root secure_path="/usr/sbin:/usr/bin:/sbin:/bin"` sudoers drop-in, checked with visudo before it is moved into place. It applies only when root runs `sudo`, so other users' `sudo` behaves as before. If the file already matches, nothing is written.
- **Decomplector: one smaller primitive and one trust boundary.**
  - The trust boundary is now stated once in `system-path.sh`: root never finds a command through `/usr/local`, and anything a service runs from `/usr/local` by absolute path is owned by root.
  - `reclaim_usr_local` now runs once per box, and a marker file records that it has run. If it fails, it says which path. This also covers the saboteur's should-fix about a failure aborting every deploy.
  - The legacy-Node links moved into `install_node22`. The comment now names the program that still needs them: the hand-installed `endo-ocapn-daemon.service`. They only replace commands that already exist.
  - Cleanup now removes only `npm` and `corepack` from `lib/node_modules` (saboteur should-fix #3), and the test knob for the Node path no longer leaks into the reclaim.
- **Pruner cuts.**
  - I rewrote the PR body and retitled the PR.
  - The `DEPLOYMENT.md` paragraph lost its migration history.
  - I removed the comments that repeated nearby code from `install-node22.sh`, `system-path.sh`, the tests, the gateway and git-remote deploy scripts, and `content-gc-runbook.md`.
  - The PR body now says the legacy-box path has only been tested in a sandbox, never on the live box (saboteur should-fix #5).

**Tests:** `test/install-node22.test.ts` was rewritten for the new behaviour and all 33 tests pass. The full local run had one failure, `test/git-remote/capability.test.ts`, in code this PR doesn't touch, and CI's `test` job passed. I did not run anything against the live box, since that needs SSM.

**Follow-ups:**
- The new sudoers drop-in (`/etc/sudoers.d/00-minion-town-root-path`) is a lasting change on every box, including `ci.minion.town`, though it only affects root's `sudo`.
- `deploy-oauth2-proxy.sh` still reinstalls the binary on every deploy. That was a should-fix and is now listed as out of scope.

The driver should post panel-10 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3519979 cached reads)
- Output: 27608 tokens
- Cost: $2.1437318000000003
- Wall-clock: 1269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
