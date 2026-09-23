Done. Let me write the completion report.

---

## Completion report

**Job:** `endojs-endo-but-for-bots-pr544-builder` — write the mechanical follow-on PR that PR #544's design (`designs/intra-package-plain-re-exports.md`) prescribes, per erights' direct request on #544.

**Delivered:** PR **#571** → https://github.com/endojs/endo-but-for-bots/pull/571 (base `llm`, open, ready-for-review, authored kriscendobot). Acknowledgment posted on #544 linking it.

**What it does (Staging step 2 of the design — the repoint-and-remove pass):** repoints intra-package importers off *plain re-exports* onto the modules that define each name. I enumerated reach-backs mechanically (a Python survey over every package's `package.json` `"exports"` map plus a name-level re-export tracer), distinguishing true reach-backs (target module *re-exports* the name) from legitimate definer imports. Edits across 3 packages, 5 source files + 1 empty changeset:

- **base64** — `atob.js`/`btoa.js` import `decodeBase64`/`encodeBase64` from the definers `./src/decode.js`/`./src/encode.js`, not the `./decode.js`/`./encode.js` declared-export pass-throughs (which stay, as public API).
- **genie** — `main.js` and `dev-repl.js` import from the defining modules (`src/agent/index.js`, `src/loop/*`, `src/tools/registry.js`, `src/interval/scheduler.js`) instead of the pure `src/index.js` barrel; dropped a now-stale `import/no-unresolved` suppression.
- **ocapn** — `src/cbor/index.js` imports `cborToDiagnostic` from its definer `src/cbor/diagnostic/encode.js`, not the `diagnostic/index.js` barrel.

**Repoint-only:** no declared export removed, no module deleted (none became fully unreferenced, so corollary-2 removal didn't fire), no version bump — recorded with an empty changeset.

**Scope calls (surfaced in the PR body for the maintainer):** excluded test modules (they exercise the public `"exports"` surface deliberately; all the design's examples are `src` modules), `export *` aggregators (design open question), and documented seams like `evasive-transform/src/visitor.js` (kept per the design). Notably the design's `genie/src/agent/tool-gate.js` `ChatEvent` example already imports from the definer on the current `llm` branch, so it correctly needed no change.

**Verification:** full monorepo install (only `better-sqlite3`'s native build failed — the known sandbox bin-shim limitation, irrelevant here). ESLint clean (0 errors) on all 3 packages; `tsc` clean on base64 and ocapn; genie `tsc` error set **identical before/after** (84 pre-existing message-protocol errors, line numbers shifted only). Runtime smoke confirmed base64 `btoa`/`atob` roundtrip and that the ocapn definer binding `===` the barrel re-export (proving binding-identity).

**Follow-ups:** none blocking. The excluded categories (tests, `export *`, documented seams) are deferred per the design; if the maintainer wants test repointing or the `export *` cases, those are a natural next pass. CI on #571 will run on push.

**Self-improvement:** nothing this time — existing skills covered the work; the sandbox bin-shim workaround (run tooling via `node <store-path>`) and read-only journal/worktree handling were already captured in memory.
