# Gauntlet undraft report: endojs/endo-but-for-bots PR #1349

PR #1349 was already out of draft when I checked, so this stage changed nothing. I did not run `gh pr ready`.

- **First check, before any change:** the PR is OPEN, `headRefOid` is `fe74338e19e25691cb368e73ade3275c53873b89` (the head the panel passed), and `isDraft` is false.
- **Second check:** the result was the same, `isDraft=false` with the head still `fe74338e…`.

**Advisory appellate pass:** I ran `claude -p` with Sonnet over the full PR diff. This review is advisory and did not affect the undraft. These points from it are worth the maintainer's attention:
1. **Repeat `lockdown()` on XS:** a second call may throw "repairIntrinsics did not report the shim Compartment constructor" if an early-return path skips the callback. No test calls `lockdown()` twice.
2. **No rollback:** `tameTextCodecs()` changes host state (the global and the host prototype's `constructor`) before permits enforcement and hardening. If lockdown fails partway, the host is left half-changed.
3. **`toString` presentation:** the tests expect `[native code]` output, but the diff never calls `markVirtualizedNativeFunction`. Check that the wrapper source and the internal name `EncapsulatedConstructor` don't leak.
4. **Narrow detection:** it only looks for own non-configurable `caller`/`arguments` properties. CI only simulates the Chromium shape; real Chromium <138 isn't run in CI.
5. **Unrelated CI changes are bundled in:**
   - `browser-test.yml` drops its `master` branch filter on `pull_request`, so it now runs on every PR, including frozen-base ones.
   - The runner is pinned to `ubuntu-24.04`.
   - There is new `BROWSER_TEST_PORT` plumbing.

   These could be split out or justified.

**Follow-ups:** none required. The five points above are optional for the maintainer.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-b122ff91-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176996 cached reads)
- Output: 1365 tokens
- Cost: $0.41500320000000007
- Wall-clock: 67s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
