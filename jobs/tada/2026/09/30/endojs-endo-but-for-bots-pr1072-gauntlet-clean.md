# Gauntlet CLEAN stage: endojs/endo-but-for-bots PR #1072 (clean=done)

The coverage pass is done: I added one test file and pushed it to the PR head. CI is green on the new head, `f8a8d9d934f` (33 checks, 0 failed).

**Starting state:** the PR was a draft at `585218bed5`. One check had failed: `test (24.x, macos-15)`, on `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. That test is timing-sensitive, runs only on macOS, and exercises daemon process teardown. This PR's only daemon change is the hint parsing in `packages/daemon/src/networks/ocapn.js`, so the failure isn't from this PR. I re-ran the failed job.

**Coverage pass (ocapn-noise, run locally):**
- All 65 existing tests pass. Overall coverage is about 91.7% of statements.
- **Gap found:** the new `src/transports/advertised-hosts.js` had no tests for its wildcard-bind path. That is where it lists the machine's network interfaces, drops loopback and link-local addresses, and orders IPv6 before IPv4 (lines 63–75 and 136–138).
- **Fix:** new file `packages/ocapn-noise/test/advertised-hosts.test.js` with 6 tests. They cover:
  - `bracketHost`
  - a specific bind, including a deliberate loopback bind
  - the explicit `hosts` override: IPv6 first, duplicates removed, loopback kept
  - wildcard enumeration, compared against `os.networkInterfaces()`
  - enumeration triggered by the wildcard `boundAddress` alone
  - `discoverHosts` folded in after the base set, with loopback and duplicates dropped
- eslint and `tsc` both pass on the new file.
- **Dead code:** none. Every new helper and export is still used, and nothing the PR replaced still has references.

**Push:** commit `f8a8d9d934` ("test(ocapn-noise): cover advertised-host computation, including wildcard enumeration"), pushed with `safe-push-pr-head.sh` as a fast-forward from `585218bed5`.

**CI:** `ci-wait-merge.sh` returned rc 0.

**Follow-ups:**
- **Early green from `ci-wait-merge.sh`:** about a minute after the push it reported GREEN with only 7 checks attached, before the main CI workflow had registered. I didn't rely on that result. I polled until all 33 checks finished and re-ran the script, which then reported total=33, failed=0. The script should probably require the main CI workflow's checks before calling a PR green; this may deserve its own fix job.
- **Rate limit:** mid-wait, GitHub's REST API returned rate-limit errors (403) even right after the reported reset, while GraphQL calls still worked. I switched to GraphQL for polling.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2691599 cached reads)
- Output: 12908 tokens
- Cost: $1.3935598000000007
- Wall-clock: 2242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
