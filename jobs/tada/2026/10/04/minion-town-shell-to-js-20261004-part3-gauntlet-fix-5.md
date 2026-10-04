**Fix round 5 for kriscendobot/minion.town PR #154: all three panel-5 must-fix items are fixed in commit `e461d76`, and CI is green (3 of 3 checks passed).**

The commit was pushed with `safe-push-pr-head.sh`, advancing the head from `c5a3e50` to `e461d76`.

**Must-fix items:**
1. **Broken `endo()` wrapper** (`provision-guest-reminders.js`): each line of the wrapper now ends in one backslash instead of two. With two, Bash ended the command early, so the final `node … endo.cjs` line ran without `sudo -u endo-daemon` and without the daemon's `HOME`/`XDG_*` paths. A new test runs the wrapper under Bash with a stub `sudo` and checks every argument it passes. I put the double backslash back to confirm the test then fails.
2. **Unchecked `FEDERATION_HOST`/`FEDERATION_PORT`** (`deploy-endo-federation.js`): `federationSettings` now rejects a host that isn't a host name or IPv4 address and any port outside 1–65535. `main` exits with an error on either. `makeBoxScript` now quotes every value it puts into the root SSM script. Tests cover injection strings, a leading zero, `0`, `65536`, and both edge ports.
3. **Whole-file hashing** (`npm-registry-backup.js`): files are now hashed in 1 MiB chunks, so memory stays bounded as `registry.sqlite` grows. The function stays synchronous so the backup/restore cleanup code doesn't have to change. This script runs on its own on the server, so it keeps its own copy of the hash helper.

**Should-fix items taken:**
- `lib/common.js` now has one shared Bash `quote()` and a chunked `sha256File()`, both tested.
  - `quote()` replaces the two separate helpers in `provision-guest-reminders.js` and `endo-root-host.js`, and `revival-test` now uses it instead of hand-written quotes.
  - `sha256File()` is used by `deploy-app.js`, `deploy-npm-registry.js` and `provision-guest-reminders.js`.
- `designs/endo-reminder-minion-town.md:142,222` now say `endoCommit` instead of `ENDO_COMMIT`.

**Should-fix items left out, with reasons in the PR summary comment:**
- `store-deployed-daemon-compat.js:19` still mentions `deploy-endo-daemon.sh`. The file's sha256 is pinned in `COMPATIBILITY_STORE_PROVENANCE.json` and in the design, so editing that comment would break the reviewed pin.
- Merging the three copies of the `endoCommit` parser, making the `${NAME}` and `$NAME` forms accept the same names, and the extra boundary and property tests are left as follow-ups.

**Tests:** the four deploy test files pass (94 tests) and `tsc --noEmit` is clean. The full suite has 3 failing files, all in code this round didn't touch:
- `test/git-remote/capability.test.ts`: the `projectPartition` git-failure test.
- `tools/claude-harness/install.test.mjs` and `release-verifier.test.mjs`: vitest reports "No test suite found" in each.

I didn't check whether these also fail on the base. CI passed regardless.

**Summary comment:** posted the combined fix-round summary on the PR (issuecomment-5985087199).

**Follow-ups:** none blocking. The skipped should-fix items above are open for the next pass, and the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2791692 cached reads)
- Output: 16536 tokens
- Cost: $1.6718504000000003
- Wall-clock: 488s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
