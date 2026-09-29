---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Post the fix-round-4 summary comment on endojs/endo-but-for-bots#1362

The fix-4 stage (job endojs-endo-but-for-bots-pr1362-gauntlet-fix-4) pushed `214e0d28c7..7f73e29871` to https://github.com/endojs/endo-but-for-bots/pull/1362 but its host PAT cannot comment on endojs (403). Post the comment below VERBATIM as a top-level PR comment with `gh pr comment 1362 -R endojs/endo-but-for-bots --body-file <file>` and nothing else. Do not touch code.

----- COMMENT BODY -----
**Fix round 4** (gauntlet `endojs-endo-but-for-bots-pr1362-gauntlet`, stage `fix-4`). Pushed `214e0d28c7..7f73e29871` in response to the round-4 panel review ([5349029000](https://github.com/endojs/endo-but-for-bots/pull/1362#pullrequestreview-5349029000)) and its [part 2](https://github.com/endojs/endo-but-for-bots/pull/1362#issuecomment-5885573187).

**Applied**
- **assessor**: every publish and dist-tag refusal after authentication is audited in one place, after any transaction rolls back. The 413, the in-transaction version race, `recheckGrant`, `checkMonotonic`, and the date-tag mismatch are now logged. There is a test for this.
- **engine-realist, warden, purist**: packument `dist-tags` are built with `Object.fromEntries`. An upstream tag named `constructor` or `hasOwnProperty` no longer throws under lockdown, and `__proto__` is no longer dropped. There is a test for this.
- **breaker, wire-watcher**: upstream indexing skips dev coordinates and `dev-*` tags (tested). `versions: null` now gives a 502 instead of a 500 (tested). The HHMMSS part of a dev version is range-checked.
- **saboteur, breaker, wire-watcher (manifest confusion)**: `peerDependenciesMeta`, `os`, `cpu`, `libc` and `engines` are now compared with the tarball. `bundledDependencies` is folded the way npm does it, and an absent field is treated as equal to an empty one. `hasInstallScript` and `_hasShrinkwrap` are derived from the tarball. Each of these has a test.
- **saboteur**: the tarball `try` blocks are narrowed, so CAS failures no longer show up as "not a valid archive". A stale fallback after a failed refresh is now logged.
- **spec-keeper**: the expiry must be an ISO date or a date-time with an explicit offset (tested). The integrity check now cites `ssri` instead of W3C SRI, and the `Math.max` spread is replaced with a reduce.
- **stylist**: renamed `stateDir` to `stateDirectory`, `makeTempDir` to `makeTemporaryDirectory`, and `args` to `operands`.
- **archivist**: the README now matches the code. Hard links and symlinks are both refused, with 400 on publish and 502 upstream.
- **curator, integrator, purist (CAS)**: the docstring now explains why `makeFileCas` does not implement `CasInterface` or reuse `@endo/daemon-cas`.
- **locksmith**: an unset `REGISTRY_PUBLISHER_PACKAGES` now fails closed. The request handler receives only `authenticate`, `makeRegistry` no longer takes `grants`, and the grant recheck runs before any CAS write.
- **purist, warden**: `isRegistryHttpError` checks a WeakSet brand. The store's statement table is frozen. The config readers and `parseSemver` return hardened records.
- **fast-checker, corner-prober**: added fast-check properties for the `compareSemver` total order, the package-name round trip and the CAS round trip. Added boundary tests for sha length, safe-integer components, PORT/TTL and empty vs absent upstream. `@fast-check/ava` is a new dev dependency, and `yarn.lock` is changed in its own commit.

**Not applied, with reasons**
- **pruner, orthographer (`SECURITY.md`)**: the lint job requires this file to stay byte-identical to `packages/skel/SECURITY.md` (see `c2d2782340`).
- **integrator must-fix (design #1361 unlanded; phase order)**: this needs a maintainer decision on #1361, and a code change cannot settle it. The PR stays in draft.
- **integrator, packager (history reset into logical commits)**: this is a retcon-shaped rewrite, so it is left for a separate retcon pass before un-draft.
- **locksmith #1 (unforgeable grant brand)**, engine-realist should-fixes (batching fsync, avoiding copies), and **typist** (`types.ts` consolidation): deferred as should-fix or comment-only.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T08:37:08Z
