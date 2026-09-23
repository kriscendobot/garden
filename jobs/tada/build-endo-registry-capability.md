The work is complete. Let me write the completion report.

---

## Completion report

**Job:** Build the M3 `registry-capability` design on `endojs/endo-but-for-bots` — the `EndoRegistry` daemon capability exposed as the required `@registry` host special name.

**Delivered:** Draft PR **[endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671)** (base `llm`, branch `endo-registry-capability`), mergeable and CI-green on the touched files.

### What I built
- **`packages/daemon/src/registry.js`** — the JS reference backend: a minimal npm-flavoured semver, the Go-like **Minimum Version Selection** walk (major coexistence, `workspace:` members, `peerDependencies` cross-check, silent `optionalDependencies`), an LRU-bounded `RegistryTable`, the four structured failure classes (`RegistryTamperedError`/`MissingPackageError`/`NetworkError`/`OfflineError`), and the `EndoRegistry` exo (`resolve`/`fetch`/`lookup`/`list`/`help`) with a content-addressed `resolutionHash`. Side effects are injected as a `RegistryBackend` so the resolver runs in CI with no network or live daemon.
- **`packages/daemon/src/registry-node-backend.js`** — the Node backend: registry HTTP, SRI integrity verification, gunzip, and tarball→CAS check-in (stripping the npm `package/` prefix); Node modules load lazily so incarnating `@registry` never blocks daemon start.
- **Host wiring** — `registry` as a required `HostFormula` field, populated at host formulation; new `registry` formula type + maker + inspector record; `@registry` bound in the host special-name map (fails fast if absent, mirroring the `@node` precedent). Touched `daemon.js`, `host.js`, `interfaces.js`, `formula-type.js`, `formula-record.js`, `types.d.ts`.
- **Tests** — `test/registry.test.js` (13 unit tests) and `test/registry-endo.test.js` (3 integration tests proving `@registry` resolves on every host). Bumped one fragile existing `endo.test.js` pull-window (12→13) since I legitimately added a special name.

### Verification
- 21 new tests pass; `tsc` and `eslint` clean on all touched files (I built `better-sqlite3` from source and confirmed the daemon boots with `@registry` wired — full `endo.test.js` couldn't run in-sandbox only because the long worktree path exceeds the unix-socket limit, so my integration test uses short `/tmp` sockets).

### Deliberate first-cut scope / follow-ups (noted in the PR)
- Capability boundary takes `package.json` as UTF-8/JSON text (a mutable `Uint8Array` isn't Passable); a Passable byte-array shape is a follow-up.
- Structured error identity is `err.name` (collapses to `Error` across CapTP — a pass-style limitation; message carries the class).
- `treeRef`s are ephemeral CAS-backed readable-trees; the hard `thisDiesIfThatDies` CAS retention link belongs to the snapshot-mapper layer (follow-up).
- The Rust backend (Phase 5) and the one-shot host-formula migration are follow-ups (the `@node` precedent it "mirrors" is itself a fail-fast, not a migration).
