---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:46:36Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual language gap: Iterator helpers plus Set/Map residual semantics

Part of the js-26 residual-closure orchestration (measured on PR endojs/endo-but-for-bots#970 head `b3c3ae93`). **This cluster: 952 actionable cases** (unsupported + ironhorse-failure) as measured by the authoritative full-suite run at that head.

**Causal reason families in scope:**
- `ironhorse-aborted` — 714
- `abort-value-differs` — 206
- `unsupported-opcode` — 32

**Top test262 subtrees:**
- `built-ins/Iterator` — 635
- `built-ins/Set` — 200
- `built-ins/Map` — 95
- `built-ins/MapIteratorPrototype` — 11
- `built-ins/SetIteratorPrototype` — 11

**Example case paths (relative to test262 `test/`):**
- `built-ins/Iterator/concat/arguments-checked-in-order.js`
- `built-ins/Iterator/concat/fresh-iterator-result.js`
- `built-ins/Iterator/concat/get-iterator-method-only-once.js`
- `built-ins/Iterator/concat/get-iterator-method-throws.js`
- `built-ins/Iterator/concat/get-value-after-done.js`
- `built-ins/Iterator/concat/inner-iterator-created-in-order.js`
- `built-ins/Iterator/concat/is-function.js`
- `built-ins/Iterator/concat/iterable-primitive-wrapper-objects.js`

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

<!-- garden-provider-quota-backoff: type=session reset-at=2026-08-15T03:30:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T01:52:17Z
