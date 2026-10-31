Coverage pass on PR #1588 is done and pushed, but CI hadn't finished when the wait ran out (`ci-wait-merge.sh` returned rc=4). So this stage ends as **still pending**, not clean=done. At head `6d309585f`, 32 of 36 checks have passed or were skipped, including `lint` and both `cover` jobs. The four `test` jobs (22.x and 24.x on ubuntu and macos-15) were still running and none had failed. The wait was clipped to 2075s (not 3600s) to fit this handler's deadline.

**Coverage pass.** The PR touches four packages: `fetch`, `confined-fetch`, `exo-http-client` and `http-confine`. I only added tests; no source code changed. Each test checks real behaviour, not just line counts.

| Package | Line coverage before → after | Tests added |
| --- | --- | --- |
| `@endo/fetch` | 96.0% → 100% | Draining a response body releases the reader lock without cancelling it. `makeFetch` refuses a transport that isn't a function. `Timer` rejects and clears the host timer when the cancel token fulfills instead of rejecting. `Timer` works over the real host timers, including cancellation. |
| `@endo/confined-fetch` | 98.8% → 99.5% | The service refuses to start unless both `delay` and `now` are supplied, and nothing is written or fetched first. |
| `@endo/exo-http-client` | 94.4% → 96.3% | `addAllowedOrigin` re-admits a removed origin, clears its revocation, and doesn't add it twice. The adapter's `pinAllowed` admits an origin that strict mode refuses. |
| `@endo/http-confine` | 93.3% → 95.3% | Revoking during a body read cancels the read and rejects with `RevokedError` (without the fix, the request would hang). `makeHttpConfinement` requires `delay`. `setMaxRequestsPerMinute` rebuilds the rate limiter on the injected delay. |

**Dead code.** The PR removed the constructor's call to `pinAllowed` in `exo-http-client`, so nothing in the package calls it anymore. I didn't delete it: it is a method on the object returned by the exported `makeTrustOnFirstBindPolicyAdapter`, which makes it public API, so it fails the skill's fourth dead-code criterion. I added a test for it instead. I found no other orphaned code.

**Pushes.** Five commits went to the PR head through `safe-push-pr-head.sh`, now at `6d309585f`:
- Four `test(<pkg>)` commits, one per package. The first push was refused because another worker had pushed a one-file test type fix (`e4221057f`), so I rebased onto it and pushed again.
- One fix commit. My first push failed CI `lint` with three TypeScript errors in my new tests. Those two packages have no local `tsc`, so I missed them locally. The fix types the test inputs that deliberately break the contract. I checked it with the repo-root `tsc` over all four packages, after confirming that run catches an injected error.

**Follow-up.** The driver should re-post this stage on a fresh budget to watch the four running `test` jobs finish at `6d309585f`.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 224 tokens (9737734 cached reads)
- Output: 37934 tokens
- Cost: $4.3305628
- Wall-clock: 10731s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
