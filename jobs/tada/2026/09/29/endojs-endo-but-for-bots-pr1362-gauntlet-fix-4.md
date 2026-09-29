# Fix round 4 for PR #1362: fixes pushed, CI green (33 checks, 0 failed)

I applied the round-4 panel's must-fix items and most of its should-fix items. Seven commits went to `build/npm-dev-registry-serving` (`214e0d28c7..7f73e29871`) through `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` exited 0. Before pushing, the package's tests (72 passing), `tsc` and `eslint` were clean locally (eslint showed only warnings that were already there), and prettier was clean on the changed files.

**Commits:**
1. **Renames (stylist):** `stateDir` → `stateDirectory`, `makeTempDir` → `makeTemporaryDirectory`, and `args` → `operands` in the admin CLI.
2. **Dev versions:**
   - The HHMMSS part of a dev version is now range-checked (breaker).
   - `parseSemver` refuses version numbers too large to compare exactly, and numeric prerelease parts now compare exactly (corner-prober).
   - New fast-check property tests (fast-checker's must-fix-loop item): `compareSemver` is a total order, and package names round-trip through their URL form.
   - New boundary tests for commit-hash length and time of day.
   - `@fast-check/ava` is a new dev dependency.
3. **`chore: Update yarn.lock`:** I added the one lock line by hand; I did not run `yarn install`. CI passed with it.
4. **Config fails closed:**
   - A publisher token without `REGISTRY_PUBLISHER_PACKAGES` is now an error instead of defaulting to `@endo/*` (locksmith).
   - The expiry must be an ISO date, or a date-time with an explicit `Z` or offset (spec-keeper's must-fix).
   - `PORT` and the upstream TTL are range-checked, with direct unit tests.
5. **Errors and authority:**
   - `isRegistryHttpError` recognizes only errors the package itself created (tracked in a WeakSet), not any error with the right shape.
   - The store's statement table is frozen.
   - The HTTP handler receives only `authenticate`, and `makeRegistry` no longer takes `grants`.
   - One side effect: `tsc` fails on this commit by itself (`makeRegistry` still requires `grants`) until commit 7, so a bisect landing on it would need to skip it.
6. **CAS docs:** the docstring now explains why the file store doesn't implement `CasInterface` or reuse `@endo/daemon-cas` (curator's must-fix). Also added a fast-check round-trip test.
7. **Registry (the main behavior changes):**
   - **Audit log (assessor):** every refusal after authentication is recorded in one place, after any transaction rolls back. This covers the size-limit 413, the version race, the grant re-check and backward tag moves.
   - **Dist-tags (engine-realist's must-fix):** built with `Object.fromEntries`, so an upstream tag named `constructor` no longer crashes under lockdown.
   - **Upstream data:** can no longer add dev versions or `dev-*` tags. A packument with `versions: null` now returns 502 instead of 500.
   - **Publish checks against the tarball:** `peerDependenciesMeta`, `os`, `cpu`, `libc` and `engines` must match. `bundledDependencies` is normalized the way npm does it. `hasInstallScript` and `_hasShrinkwrap` now come from the tarball, not the client's document.
   - **Error handling:** the tarball `try` blocks are narrowed, so disk errors are no longer reported as a bad archive. Serving stale data after a failed refresh is now logged. The grant is re-checked before anything is written to the CAS.
   - **Docs:** the integrity check now cites npm's `ssri`, not W3C SRI. The README now matches the code: hard links and symlinks are both refused, with 400 on publish and 502 for upstream (archivist's must-fix).

**Not applied:**
- **`SECURITY.md` (pruner, orthographer):** the lint job requires it to stay identical to the canonical copy.
- **Integrator must-fix:** the design in #1361 hasn't landed, and the phase order conflicts with it. This needs a maintainer decision, not a code change, and the PR stays in draft.
- **Commit-history reset (integrator, packager):** this should be a separate retcon before un-draft.
- **Deferred should-fix or comment-only items:**
  - locksmith: make grants unforgeable
  - engine-realist: batch the fsyncs and avoid extra copies
  - typist: move typedefs into `types.ts`

**Follow-up:** this host's bot token gets a 403 when commenting on endojs PRs, so I couldn't post the round summary. I posted job `endojs-endo-but-for-bots-pr1362-fix4-summary-comment`, pinned to `host=endolin-garden-ece02cb4`, to post it word for word. The next panel's scribe seat will look for it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (9214562 cached reads)
- Output: 49779 tokens
- Cost: $4.195500399999999
- Wall-clock: 3868s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
