---
gate: orchestrated
orchestrated_by: ironhorse-js-26-residual-closure
priority: normal
posted_by: producer
posted_at: 2026-08-14T22:15:13Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual language gap: the `with` statement

Part of the js-26 residual-closure orchestration (measured on PR endojs/endo-but-for-bots#970 head `b3c3ae93`). **This cluster: 949 actionable cases** (unsupported + ironhorse-failure) as measured by the authoritative full-suite run at that head.

**Causal reason families in scope:**
- `unsupported-opcode` — 943
- `strict:unsupported-opcode:with` — 6

**Top test262 subtrees:**
- `language/statements` — 276
- `language/eval-code` — 250
- `language/expressions` — 228
- `annexB/language` — 145
- `built-ins/Proxy` — 9
- `built-ins/Array` — 8
- `language/function-code` — 6
- `language/identifier-resolution` — 5
- `language/types` — 5
- `built-ins/Function` — 3

**Example case paths (relative to test262 `test/`):**
- `annexB/language/eval-code/direct/func-block-decl-eval-func-block-scoping.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-block-fn-no-init.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-block-fn-update.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-fn-no-init.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-fn-update.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-var-no-init.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-existing-var-update.js`
- `annexB/language/eval-code/direct/func-block-decl-eval-func-init.js`

Repository: `endojs/endo-but-for-bots`.

**Shared branch/PR (do not create a new one):** work on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN, draft, keep it open, do NOT merge). Fetch the remote branch first and preserve every prior commit; stack your bounded commits on its head and push with a rebase CAS loop. Peers on sibling clusters may be pushing serially — this orchestration is serial to avoid working-tree/CAS collisions, but always fetch+rebase before push.

**Pins (unchanged; record any change):** engine measured on head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (init with `git submodule update --init --depth 1 c/moddable`). Rust toolchain: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off any noexec mount.

**Acceptance bar (identical to the js-XX arc, non-negotiable):** convert this cluster's cases from unsupported/failure to **covered** via **real execution against the official XS differential oracle** (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pinned checkout>`), except for a **specifically justified, standards-grounded host-only or proposal exclusion** (e.g. an `oracle-host-missing-*` where XS itself cannot serve as authority — cite the spec/proposal). Add focused **Rust unit/regression tests** for each causal feature under `rust/engine/ironhorse-262/tests/`. Do **NOT** merely relabel, suppress, skip-list, or add expectation files for failures. Zero generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`, `abort-value-differs`, or `non-primitive-completion` reasons may remain **within this cluster's scope**.

**Regression invariant:** no case covered in the starting report (`rust/engine/ironhorse-262/baseline/baseline.json`) or by any earlier child may regress; no new `ironhorse-failure` or `infrastructure` result may appear; every proprietary exact-metering/byte-identity case under `rust/engine/ironhorse-262/cases/**` must stay passing with its exact computron expectation unchanged (`ironhorse-xst --gate-meter-exact` corpus + `cargo test --workspace --release`). Run the affected official slice, the full Ironhorse Rust workspace gates, and the exact-metering corpus before every push.

**If this cluster is itself too large for your handler budget:** do NOT partially relabel. Sub-decompose into bounded causal children under a nested halt-on-failure orchestration and hand off (report the durable continuation). This mirrors how js-26 spawned this orchestration.

**Report:** commands run, totals before/after for the affected slice, changed skip reasons, head SHA, and PR URL. Keep the PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
