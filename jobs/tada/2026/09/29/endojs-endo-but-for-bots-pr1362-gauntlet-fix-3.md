# Fix round 3 for endojs/endo-but-for-bots PR #1362: panel-3 must-fix items applied, CI green

I pushed six follow-up commits to `build/npm-dev-registry-serving` (head `e7efe19990` → `214e0d28c7`). The final CI run passed all 33 checks (`ci-wait-merge` rc 0), and the PR is still a draft.

**Must-fix items addressed:**
- **assessor:** when an upstream response declares a size over the limit, `readLimited` now discards it before throwing. Before, it left the keep-alive socket stuck.
- **breaker #1:** `refreshUpstream` now keeps serving cached rows when a failure happens after the upstream has already replied 200. That covers a truncated body, an oversized body, a body that isn't JSON, and a packument for a different name. Both new registry tests fail when run against the old `registry.js`.
- **prover:** a new test covers the 409 "already exists from the upstream registry" branch of `conflictReason`.
- **corner-prober #1 / wire-watcher #2:** every refusal that `ingestTarball` documents now has a test. That includes symlinks, hard links, devices, FIFOs, absolute and `..` paths, entries outside the root, and a `package.json` that is missing, not JSON, or not an object.
- **fast-checker #2:** instead of adding a property-test dependency, the test enumerates the whole finite domain. Each of the four hash algorithms is absent, right or wrong (3⁴ combinations), checked in both listing orders.
- **stylist:** test identifiers renamed from `dir` to `directory`, and from `req`/`res` to `request`/`response`.
- **surfacer:** `index.js` now documents that `isAllowlistEntry` is deliberately left out of the public exports.
- **scribe:** I posted the missing round-1 summary inside the round-3 summary comment.

**Should-fix items I also took:** `@scope/*` allowlist entries are now capped at the 214-character name limit, with boundary tests at 214/215 characters and token-length tests at 31/32. `isRegistryHttpError` now also checks `reason`.

**Two CI failures after the first push, both fixed:**
- My `acknowledgement` → `acknowledgment` spelling fix in `SECURITY.md` broke lint, which requires every package's copy to match `packages/skel/SECURITY.md` byte for byte. I reverted it; the spelling fix belongs in the canonical copy for all packages.
- `test (24.x, macos-15)` failed in an existing node-fetch test from an earlier round: a fixed 200 ms timeout could expire before the response headers arrived. The test now triggers the timeout only after the headers are in, so it no longer depends on runner speed.

**Not changed (reasons are in the PR comments):**
- **archivist (SECURITY.md):** the file is the canonical copy every package shares, which the lint check enforces.
- **integrator #1/#2:** the design this PR implements (#1361) hasn't landed, and the integrator asks for the PR to reuse the repo's existing CAS and registry tables instead of its own. That's a direction call for the maintainer; the PR stays draft behind #1361.
- The remaining should-fix and comment-only items are left for follow-up: the saboteur's and breaker's metadata-trust findings, BigInt semver comparison, HHMMSS validation, async gunzip and fsync batching.

**Verification:** under Node 24, all 59 package tests pass, `tsc` is clean and `eslint` reports no errors (warnings only). This host's `better-sqlite3` is built for Node 24, so the tests have to be run with `/usr/local/n/versions/node/24.21.0/bin`.

**Summary comments:** `issuecomment-5884340039` and `issuecomment-5884560580`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 128 tokens (7030304 cached reads)
- Output: 27595 tokens
- Cost: $3.1020568000000006
- Wall-clock: 3727s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
