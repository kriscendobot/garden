Fix round 5 for endojs/endo-but-for-bots #1588 is pushed (`1649db1691..5ca2ce64d0`) and CI is green: `ci-wait-merge` returned rc 0 with 36 checks and none failed. There was no pre-pass block, so I worked from panel-5's two reviews (5904153722 and 5904189826).

On the first CI pass, `cover (22.x, ubuntu-latest)` failed once in `@endo/sandbox` ("bwrap timeout and repeated cancellation reap process groups"). This PR doesn't touch that package, the same test passed on the 24.x leg, and it's a known pre-existing bwrap flake. I reran the failed job and it passed. The first 1-hour wait timed out (rc 4) while the macOS test legs were still running; the final check returned rc 0.

**Must-fix items applied**
- **Revocation durability and fail-closed revival** (assessor, locksmith, saboteur, breaker, purist, wire-watcher, engine-realist, corner-prober):
  - `@endo/confined-fetch` now keeps policy and bindings in one `policy.json`, committed in a single write, so a crash can't pair new policy with stale bindings.
  - Every `HttpClientControl` mutator, including `revoke`, resolves only after the write is committed, and rejects if the write fails. The change still takes effect immediately.
  - Only a missing store means first setup. A store that can't be read or parsed, or has the wrong shape, now makes revival fail instead of falling back to the setup `env` values.
  - New tests cover a restart right after revocation (no sleep), a failed write, corrupt and invalid stores, and a transient read error.
- **Daemon cancellation** (migrator): a new adapter, `makeFetchLikeFromPlatformFetch`, turns the `cancelled` token into an `AbortSignal`. The daemon's `http-client` maker and the default ambient fetch both use it, and a new daemon test shows a timeout aborts the request.
- **Remote policy authority** (warden): the client now calls `E(authority).decide(harden(...))`, so a remote authority works and gets a frozen request. The transport is hardened too.
- **Opaque redirects** (spec-keeper): `Fetch` responses now carry the Fetch Standard `type`, with an end-to-end test of a browser opaque redirect. The timer-limit comment now cites the HTML timer profile instead of ECMA-262.
- **Packaging** (packager, surfacer, curator, changeset-auditor, releaser): both new packages have a top-level `index.js`, a declarations build and an empty `CHANGELOG.md`. They start at `0.1.0` with a `major` changeset, and the four changesets are now one. The composite tsconfigs are regenerated, and `yarn.lock` is in its own commit.
- **Smaller items**:
  - `Timer.delay` is typed `Promise<undefined>` (typist).
  - The flagged short identifiers are spelled out (stylist).
  - The limiter retune test now holds a slot before lowering the limit, with new tests for lowering below held slots and the timer range edges (prover, corner-prober).
  - Design docs are updated and the unrelated `designs/README.md` churn reverted (archivist, integrator).
  - README and module headers are trimmed and the PR body shortened (pruner).
  - A completion summary is posted for the new head (scribe).

**Declined, with reasons in the PR comment**
- **`harden()` on the `M.*` guards** (breaker, purist): the repo lint rule `@endo/no-harden-pattern-maker` flags it.
- **Narrowing `cancelled` to `Promise<never>`**: the type the guard produces won't accept it, and the runtime guard already rejects anything that isn't a promise.
- **Reusing `makeDelay`**: it requires a token and never clears its timer, and `Timer` needs both.
- **`minor` or `0.0.0` for `@endo/fetch`**: the package was never published, so the new-package rule applies.
- **A daemon changeset**: the daemon's behavior is unchanged.
- **Splitting out `.node-version` and the action-pin comment**: both are needed to unblock CI on the frozen base, and the PR body says so.

**Checked locally:** these all pass:
- the suites for fetch (13), confined-fetch (28), exo-http-client (49) and http-confine (30), plus the daemon's `http-client` test (14);
- the agent-tools code-mode type tests;
- `tsc` for the four packages and the daemon, and the composite declarations build;
- eslint (0 errors) and prettier.

**Follow-ups**
- `yarn install` with the default linker fails here with a cross-device hardlink error (EXDEV). The classic node-modules linker worked.
- `tsc --build` leaves `.d.ts` files that make the agent-tools code-mode tests falsely fail until you delete them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 242 tokens (21641538 cached reads)
- Output: 67222 tokens
- Cost: $7.552747600000001
- Wall-clock: 7151s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
