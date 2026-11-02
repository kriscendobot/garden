I've applied panel-2's must-fix items to PR #1588 and pushed them, but CI hadn't finished when the one-hour wait ran out (rc 4). One CI job, `test-xs`, has already failed. I don't think my change caused it, but I couldn't rerun it to confirm.

**What I fixed** (five follow-up commits, pushed `0c55ae5d6c..0d50424b56` with `safe-push-pr-head.sh`):

- **Revoke race (breaker, corner-prober):** in `@endo/exo-http-client`, `revokeBinding`, `unpin` and `setAllowedOrigins` now take the origin off the allowlist *before* awaiting the policy update. Before, a fetch fired in that gap skipped the policy check and reached the network, and if the revoke failed the origin stayed fetchable for good. `removeAllowedOrigin` already worked this way.
  - New tests fire a fetch while each update is still pending and check it is refused. All three fail on the old code and pass on the new.
  - `policyPromptTimeoutMs` is now capped at `2**31-1`, the range the Timer accepts, with a test.
- **Redirects (spec-keeper):** in `@endo/http-confine`, only statuses 301, 302, 303, 307 and 308 count as redirects. A 304, or a 300/305 without a `Location`, is no longer rejected.
  - Opaque redirects and malformed `Location` headers are now rejected; a bad `Location` used to throw a raw `TypeError` instead.
  - The `x-http-method`, `x-http-method-override` and `x-method-override` headers are now forbidden. New tests cover this.
- **Shared header copy (procurer):** `@endo/fetch` now imports `snapshotHeaders` from `@endo/http-confine` instead of keeping its own copy. That adds a dependency; the `yarn.lock` update is its own `chore: Update yarn.lock` commit.
  - I also removed the duplicate `@endo/patterns` dev dependency from `@endo/confined-fetch`, and added a comment citing the source of the timer delay limit.
- **Changeset (curator, migrator, changeset-auditor, releaser):** I rewrote `.changeset/add-endo-fetch.md` with one paragraph per package, one sentence per line.
  - `@endo/http-confine` goes from `patch` to `minor`, and the changeset now lists its renames and option changes with migration lines.
  - For `@endo/exo-http-client`, the text no longer says "backward-compatible". It names the `signal` → `cancelled` change, the control methods that now return promises, the switch from `now` to `delay`, and the new `Delay` type.
  - `@endo/fetch` and `@endo/confined-fetch` follow the garden's new-package rule: version `0.1.0`, `major` bump, empty `CHANGELOG.md`. Both are still `private`.

**Local checks:** all tests pass in the four packages:

| Package | Tests |
| --- | --- |
| `exo-http-client` | 49 |
| `http-confine` | 26 |
| `fetch` | 12 |
| `confined-fetch` | 24 |

Lint has no errors, Prettier is clean, and the repo-root `tsc -p tsconfig.json` type-check passes.

**CI when the wait ended:** 4 of 36 checks were still running, the four `test` jobs (Node 22/24 on ubuntu and macos-15).
- **`test-xs` failed** on a test-baseline change in `@endo/hardened262`: `sesNode/module` went from passed to failed on `test/intrinsics/ThrowTypeError/intrinsic-metadata.js`. This PR doesn't touch `ses` or `hardened262`, so I think it's a flake, but that's unconfirmed.
- I tried to rerun it, and GitHub refused because the workflow run (41409630671) was still in progress. The next stage should run `gh run rerun 41409630671 --failed` once that run completes. If it fails again, look at whether the baseline drift is a known issue on the frozen base `llm-9a14ddf`.

**Not done:** the remaining non-must-fix comments.
- The `src/` entries in the `exports` maps stay, because the tests and `confined-fetch/src/transport.js` import through them.
- The pruner's suggested trims to the PR body and comments are not done.
- The `instanceof Uint8Array` / `ArrayBuffer.isView` and `Set-Cookie` collapse notes are not done.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4480870 cached reads)
- Output: 19356 tokens
- Cost: $2.115886
- Wall-clock: 3987s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
