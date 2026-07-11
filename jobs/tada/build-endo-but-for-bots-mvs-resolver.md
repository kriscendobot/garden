Cleaned up. This build is a genuine duplicate — the entire `mvs-resolver` design deliverable already lives in open PR endojs/endo-but-for-bots#671, so I opened no PR and made no commits, and surfaced the finding to the maintainer for a close-as-subsumed decision.

---

## Completion report

**Job:** `build-endo-but-for-bots-mvs-resolver` — build the JS reference MVS resolver per `designs/mvs-resolver.md`.

**Outcome: NOT BUILT — subsumed by open PR endojs/endo-but-for-bots#671.** No PR opened, no commits made.

**What I found (by code inspection of the PR's head branch `endo-registry-capability`):**
- PR endojs/endo-but-for-bots#671 ("feat(daemon): EndoRegistry capability and required @registry host name", base `llm`, state OPEN, `MERGEABLE`/`CLEAN`) already lands the full `mvs-resolver` design inside `packages/daemon/src/registry.js` (977 lines) — the exact file the design's implementation sketch and `registry-capability` § Phase 1 both name. The file header explicitly states it "implements the Go-like Minimum Version Selection walk from `designs/mvs-resolver.md`."
- Present in that file: the eager single-pass `resolve(packageJson, options)` frontier walk, one selection per `(name, major)` with major coexistence, content-addressed `resolutionHash`, minimal semver (`parseVersion`/`compareVersions`/`satisfies`/`maxSatisfying`/`rangeMajor`), the LRU `RegistryTable`, `buildRegistryResolution`, `workspace:` specifier handling, `peerDependencies` cross-check (`RegistryMissingPackageError`), `optionalDependencies` best-effort with an `unmetOptionals` diagnostic side-channel, and offline mode (`RegistryOfflineError`).
- `packages/daemon/test/registry.test.js` already covers every MVS fixture the design enumerates: widened transitive range, incompatible-majors-as-distinct-keys, `resolutionHash` determinism, offline hit/miss, peer satisfied+unmet, optional missing, and workspace member + version-mismatch diagnostic.

**Why it's a duplicate, not a stacked build:** the roadmap tracks `registry-capability` (layer 1) and `mvs-resolver` (layer 2) as separate Proposed designs, but the capability is non-functional without its resolver and the algorithm lives in the *same* `registry.js` the capability PR created. There is no separable file to put in a distinct PR; endojs/endo-but-for-bots#671 correctly bundled the two layers.

**Verification honesty:** I did not run the test suite — the finding is a factual claim about PR endojs/endo-but-for-bots#671's contents, established by reading its full `registry.js`, `registry-node-backend.js`, `registry.test.js`, and changeset on its head branch. I make no "tests pass" claim.

**Actions taken:** Read both designs and the roadmap; created and inspected an isolated project worktree on the PR head branch; sent a message to the maintainer inbox (`20260711T152535Z-0f5e62`) with the finding and a recommendation to close this job as subsumed; removed the project worktree.

**Recommended follow-up (maintainer decision):** close `build-endo-but-for-bots-mvs-resolver` as subsumed by endojs/endo-but-for-bots#671. The real downstream unblock for `snapshot-mapper` and `daemon-worker-import-from-mount` is endojs/endo-but-for-bots#671 **merging**, not a separate mvs PR.

**Self-improvement:** nothing this time — the builder's "verify no open PR already implements the issue" pre-flight is exactly the safety net that caught this, and it worked as intended.
