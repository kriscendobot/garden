# Gauntlet fix round 1: kriscendobot/minion.town PR #169

I fixed the panel's round-1 must-fix items in one follow-up commit and pushed it with `safe-push-pr-head.sh`, a fast-forward from `c37488c` to `bb2c719`. CI is green on the new head (3/3 checks).

**What changed, by juror:**
- **engine-realist:** Both the render check and the target-host preflight now require a key of at least 32 characters, the same check the app runs at startup (`src/auth/stores/dynamodb.ts:54`). Keys are also limited to base64/base64url characters, so systemd's `EnvironmentFile=` can't alter them. `DEPLOYMENT.md` no longer calls rotation routine: it now says changing the key makes stored guest-recovery records undecryptable, so rotation needs a re-encryption or dual-key migration first.
- **purist:**
  - The preflight script moved to `deploy/aws/scripts/lib/guest-recovery-environment.sh`. Like the caddy helper, it has no shebang and is loaded once in `common.sh` as `$GUEST_RECOVERY_ENVIRONMENT`.
  - `deploy-app.sh` inlines it and calls `minion_mcp_secret_preflight || exit 1` as its first remote action.
  - The test-only fetch hook is gone from the text that runs on the box.
  - The render script and the preflight now share one key check and one merge helper.
  - `deploy-account-endpoint-secret.sh` now has a comment noting that a second script also writes `account.env`.
  - The IAM wording no longer claims "exact" ARNs; it now says each grant is a name-prefix pattern (`<name>-*`).
  - The test builds every path with `fileURLToPath(new URL(...))`.
- **transplanter:** The render script now checks that `python3` is on PATH and names it if it's missing. On the target it stages files in a `mktemp -d` directory instead of fixed `/tmp` paths.
- **prover:**
  - Ordering assertions now fail when the step they look for is missing.
  - The tests render the real remote scripts from `deploy-app.sh` and `deploy-guest-recovery-key.sh` with bash, the same way the deploy does, and check that they parse.
  - The preflight runs through a fake `sudo` on PATH, so the production `sudo cat` path is exercised. Cases: file absent, key missing, 31-character key, and a valid key that must not appear in the output.
  - New merge tests cover replacing an existing key line, a fresh host, and refusing empty, short or quoted values without writing anything.
  - I checked that deleting the preflight call from `deploy-app.sh` makes the suite fail.

**Verification:**
- The new test file passes (14 tests) and typecheck is clean.
- In the full suite, one test fails out of 963: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`. It's a git-remote test this PR doesn't touch, and it was already noted as failing on this host before this change.

**Follow-ups:** None from this stage. The gauntlet driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1848579 cached reads)
- Output: 22650 tokens
- Cost: $1.5508918000000005
- Wall-clock: 464s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
