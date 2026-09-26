The work is complete. Let me write the completion report.

---

## Completion report — `endor-walker-exports-resolution-20260827`

**Outcome: Increment 2 (Group C — conditional & subpath exports/imports) landed. Gate met.**

The two prior halts were provider-acquisition failures, not task difficulty — this attempt ran a real worker end-to-end and completed the increment.

### What I did
Implemented conditional/subpath `exports` and `#imports` resolution in the endor `entry_walk` walker and graduated all five Group-C fixtures against committed node-oracle goldens.

**Walker (`rust/endo/src/entry_walk.rs`):**
- Ported the compartment-mapper resolution slice (`infer-exports.js` + `pattern-replacement.js`): condition selection, exact-subpath aliases, `*`-wildcard subpath patterns (matching across `/`, Node semantics), `PATTERN_KEY_COMPARE` specificity ordering, and null-target exclusions.
- `#imports` self-references resolved against the importing package's `imports` field (same compartment).
- Honor a package-local `"parsers"` override (e.g. `{ "js": "mjs" }`) for `.js` language classification — this is what made `typeparsers` reachable.
- Preserve `exports`/`imports` object **key order** (new `OrderedJson` type) so condition selection is insertion-order sensitive, matching Node (`{ "endo:lib": …, "default": … }` selects `endo:lib`, not `default`). `serde_json::Value` would have sorted the keys and silently picked `default`.
- Added `WalkOptions` (emulated condition set + host/exit-module set) and `ingest_entry_point_with_deps_with_options`. Un-hooked host/scheme specifiers (`endo:lib`) and declared exit modules (`builtin`) are dropped from the static map, matching compartment-mapper's archive mapper with no import hook.

**Oracle (`rust/endo/tools/gen-parity-golden.mjs`):** threads per-fixture `conditions`/`modules` options through `mapLocation`, supplying the same emulated inputs to node and the walker (the design's "emulate, don't refactor" rule).

**Manifest/test:** flipped `conditional-host-exports` (emulated `endo:lib` condition), `export-patterns`, `package-imports-exports`, `nested-pkg`, and the mixed CJS/ESM kitchen-sink `fixtures-0` to `Exercise`; bumped `EXERCISED_FLOOR` 11 → 16; added 6 focused unit tests for the new resolution helpers.

### Verification (all local, green)
- Parity suite: 5/5 pass. Scoreboard: **16 exercised / 16 pending / 8 durable** (of 40); floor 16 met, drift guard green.
- `entry_walk` unit tests: 49/49 (43 existing + 6 new). Full endo lib: 304/304.
- Oracle determinism: `gen-parity-golden.mjs --check` reports no drift.
- Graduation is atomic (capability + goldens + Exclude→Exercise + floor bump in one commit `7476b427f`).

The local-build gotcha (gitignored Moddable `xs/` sources + empty `xsnap/src/*_bootstrap.js`/`ses_boot.js` stubs) was staged from a same-commit sibling and left uncommitted. CI does not run this parity test target or gate on rustfmt/clippy; the endo lib (which CI does compile via the `ironhorse_store_worker` test) builds clean.

### Pushed
Commit `7476b427f` → `origin/feat/endor-run-entry-point-deps` (`13f1ff837..7476b427f`), CAS push clean on first attempt.

### Follow-ups
- The 5 downstream ratchet children (dep-classification, dynamic-import, nested-resolution, language-extensions, host-hooks) remain parked under `orchestrated_by: endor-fixture-parity-ratchet-campaign-20260823`; a future press re-orchestrates them now this Group-C blocker (which twice halted the campaign) has cleared. Increment 3 (Group D dep-classification) is next and depends on Increment 1.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-walker-exports-resolution-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 285 tokens (27623224 cached reads)
- Output: 124475 tokens
- Cost: $19.640490000000003
- Wall-clock: 2086s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
