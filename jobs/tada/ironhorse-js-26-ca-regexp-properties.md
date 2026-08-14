Implemented and pushed XS-compatible RegExp Unicode character-property escapes.

- Added canonical binary, general-category, Script, and Script_Extensions aliases from pinned Moddable XS, vendored deterministically with pin/checksum provenance.
- Added `\p{...}`/`\P{...}` execution in u/v modes, including negation, classes, astral characters, ignoreCase behavior, and syntax rejection for invalid aliases.
- Added 453-case bit/meter-exact XS parity and focused end-to-end Rust tests.
- Regression proof: disabling property lookup failed the focused test; restoration passed.

Gates passed:

- `cargo test --workspace --release`
- Temporal/Intl representative tests: 24 passed
- `ironhorse-xst --gate-meter-exact built-ins/RegExp/property-escapes`
  - Before: 538 total, 6 covered, 136 parse-phase over-acceptance failures, 396 named skips
  - After: 538 total, 143 covered, 0 failed, 395 existing named skips
- Pre-push probes: 5/5 passed
- CI `test-ironhorse`: passed

Final head: `7c472dee6a4b1c7cbfa2d89f3aa8985503165357`  
PR: https://github.com/endojs/endo-but-for-bots/pull/970 — remains open and draft.

Follow-up scope remains separately named for v-mode string-valued properties and set-expression syntax.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-properties.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2559s

<!-- garden-usage-end -->
