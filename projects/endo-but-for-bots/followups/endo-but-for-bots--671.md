---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 671
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-11T14:40:48Z
last_appended_at: 2026-07-11T14:40:48Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#671

Created from the code-panel verdict (19 seats, panel-hints subset) on `feat(daemon): EndoRegistry capability and required @registry host name` (branch `endo-registry-capability`, base `llm`). The PR implements the M3 registry-capability / MVS-resolver stack: a JS reference `EndoRegistry` exo (minimal semver + greatest-mentioned-satisfying MVS walk + LRU table + four structured error classes), a Node reference backend (registry HTTP + SRI verification + tarball → CAS check-in), and the required `@registry` host special name. The panel's fixer round addressed integrity fail-closed, resolutionHash key-dedup, doc-symbol drift, and the missing changeset (commit d863566953). The items below were dispositioned `follow-up` — real, out of scope for this round, revisit when the PR (or a later upstream mirror) merges.

## Items

- [ ] **Origin-pin tarball fetches (SSRF surface).**
  **Source seat(s)**: saboteur, warden.
  **Round**: 1.
  **Recommended action**: open a follow-up PR pinning `provideTree`'s tarball fetch to the configured `registryUrl` origin (or an allowlist).
  `registry-node-backend.js` fetches `versionRecord.dist.tarball` verbatim; a hostile or MITM'd packument can point it at an internal address (e.g. a link-local metadata endpoint). The first-cut threat model (`designs/registry-capability.md` § *Non-Goals*, "runs without credentials") does not record this stance; capture the decision or add the origin pin.

- [ ] **Bound the resolve walk (resource-exhaustion surface).**
  **Source seat(s)**: saboteur.
  **Round**: 1.
  **Recommended action**: add a package-count / depth budget to the `resolve` frontier and a per-package version-count cap in `maxSatisfying`.
  The walk is exposed as a host capability with no depth, total-package, or version-count cap; a hostile registry can enumerate an unbounded distinct-dependency chain. The design's *Caching and retention* bounds CAS bytes but not the resolver's in-flight frontier.

- [ ] **Workspace member must not be displaced by a registry candidate.**
  **Source seat(s)**: prover.
  **Round**: 1.
  **Recommended action**: guard the MVS candidate short-circuit so a `workspace:`-pinned entry (treeRef `undefined`) is never overwritten by a plain-range edge of the same name.
  `processEdge`'s `existing >= candidate` comparison can replace an on-disk workspace member when a registry candidate is greater, violating the stated "the on-disk member always wins" invariant. Untested (only single-workspace-importer coverage today).

- [ ] **Narrow the optional-dependency catch.**
  **Source seat(s)**: assessor.
  **Round**: 1.
  **Recommended action**: demote to `unmetOptionals` only on `RegistryMissingPackageError`, re-throwing `RegistryNetworkError` / `RegistryOfflineError`.
  The optional-dep `catch` wraps `versionsFor`, so a genuine transport failure on an optional dep is silently reclassified as "unmet optional" rather than surfaced.

- [ ] **Semver / MVS test-coverage expansion (property-based).**
  **Source seat(s)**: corner-prober, fast-checker.
  **Round**: 1.
  **Recommended action**: add fast-check property tests (parse round-trip, `compareVersions` total order, `maxSatisfying` soundness) plus example tests for prerelease precedence (semver §11), `||` unions, hyphen-range wildcard approximation, `^0.0.x`, and `maxSatisfying([], range)`. Add `@fast-check/ava` (catalog) to daemon devDependencies.
  The prerelease comparison path and several range shapes are currently unexercised.

- [ ] **Node-backend behavioral coverage.**
  **Source seat(s)**: corner-prober, integrator.
  **Round**: 1.
  **Recommended action**: extend the new `test/registry-node-backend.test.js` with flat/no-root, empty, and symlink-only tarball fixtures for `checkinPackageTar`, and drive one `resolve`/`fetch` through the incarnated daemon slot in `registry-endo.test.js` (the integration test currently only exercises construction-time `help`/`lookup`/`list`, so the `contentStore`/`makeReadableTree` wiring is never traversed end-to-end). Also add a `stop`/`start` reincarnation round-trip to the "formula is persisted" test, which today only proves multi-client reachability.

- [ ] **Engine-neutral core: no host primordials at module top.**
  **Source seat(s)**: engine-realist.
  **Round**: 1.
  **Recommended action**: move `registry.js`'s module-top `new TextDecoder()` to a lazy/injected helper.
  The file is billed as the engine-neutral reference core a future Rust/XS/Hermes lane reuses, but touches a host-provided primordial at load; safe today (Node-only importer) but a latent load-time fault when bundled to a non-Node host.

- [ ] **Inject `fetch` as a daemon power.**
  **Source seat(s)**: warden, purist.
  **Round**: 1.
  **Recommended action**: thread outbound-HTTP authority through `makeDaemonCore`'s `powers` rather than reading `globalThis.fetch` in `requireFetch`.
  Keeps the registry's network authority enumerable in the confinement graph, consistent with `net`/`crypto`. The backend already parameterizes `fetch`, so the daemon need only pass an injected power.

- [ ] **Migration path vs. design divergence for required `@registry`.**
  **Source seat(s)**: breaker, scribe, releaser, assessor.
  **Round**: 1.
  **Recommended action**: reconcile code and design — either implement the one-shot idempotent upgrade pass `designs/registry-capability.md` § *Migration for already-formulated hosts* promises, or amend that section to record the deliberate fail-fast (matching the existing `@node` "Phase 6 required" precedent). The changeset added this round already carries the user-facing "re-initialize" note.
  A pre-registry host formula throws `Host formula missing registry (@registry required)` on incarnation; the design's cross-referenced § Migration currently over-promises auto-migration for both this slot and `@node`.

- [ ] **Typing completeness: RegistryResolution type + dead RegistryDeferredTaskParams.**
  **Source seat(s)**: typist.
  **Round**: 1.
  **Recommended action**: declare a `RegistryResolution` typedef in `types.d.ts` and annotate `resolve`/`buildRegistryResolution` `@returns`; move the cross-file-`@import`ed `RegistryBackend` typedef (and its semver siblings) into `types.d.ts`; wire or drop `RegistryDeferredTaskParams` (currently zero consumers).

- [ ] **Spell-out abbreviated identifiers.**
  **Source seat(s)**: stylist.
  **Round**: 1.
  **Recommended action**: rename freshly-introduced abbreviations — `gz` → `gzipBytes`, `impl`/`fetchImpl` → `implementation`/`fetchImplementation`, `cmp` → `comparison`, `memberPj`/`childPj` → `memberPackageJson`/`childPackageJson`, and the test-local `pjByTree`/`mk`/`pv`.
  Low value against diff churn; bundle with the next substantive touch of these files.
