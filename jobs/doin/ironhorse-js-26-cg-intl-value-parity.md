---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:07:09Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual language gap: Intl formatter value/metering parity (abort-value-differs across NumberFormat/DateTimeFormat/Locale/Duration/RelativeTime/DisplayNames/ListFormat)

Part of the js-26 residual-closure orchestration (measured on PR endojs/endo-but-for-bots#970 head `b3c3ae93`). **This cluster: 887 actionable cases** (unsupported + ironhorse-failure) as measured by the authoritative full-suite run at that head.

**Causal reason families in scope:**
- `abort-value-differs` — 804
- `unsupported-opcode` — 60
- `ironhorse-aborted` — 21
- `over-acceptance: ironhorse completed a source the oracle rejected` — 2

**Top test262 subtrees:**
- `intl402/NumberFormat` — 221
- `intl402/DateTimeFormat` — 106
- `intl402/Locale` — 93
- `intl402/DurationFormat` — 89
- `intl402/RelativeTimeFormat` — 67
- `intl402/Intl` — 51
- `intl402/ListFormat` — 45
- `intl402/DisplayNames` — 43
- `intl402/Collator` — 38
- `intl402/Segmenter` — 29

**Example case paths (relative to test262 `test/`):**
- `intl402/Array/prototype/toLocaleString/calls-toLocaleString-number-elements.js`
- `intl402/Array/prototype/toLocaleString/invoke-element-tolocalestring.js`
- `intl402/BigInt/prototype/toLocaleString/builtin.js`
- `intl402/BigInt/prototype/toLocaleString/de-DE.js`
- `intl402/BigInt/prototype/toLocaleString/default-options-object-prototype.js`
- `intl402/BigInt/prototype/toLocaleString/en-US.js`
- `intl402/BigInt/prototype/toLocaleString/length.js`
- `intl402/BigInt/prototype/toLocaleString/name.js`

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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T01:12:46Z
