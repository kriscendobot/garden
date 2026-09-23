Work is complete and pushed. Let me write the completion report.

## Completion report

**Job:** endor-xst core — the xst-analogue test262 runner (PR #600, test262-convergence child 1/5).

**Landed:** `endojs/endo-but-for-bots` branch `xs2rust-endor` @ `f31ad65a46` (PR #600, kept **DRAFT**).

### What I built
The new `endor-xst` binary in the `endor-262` crate (design § Part 2), the xst-analogue of `xs/tools/xst.c` + `xst262.c` plus the differential oracle xst never had:

- **Full YAML frontmatter** — new `src/frontmatter.rs` using `yaml-rust2` (pure-Rust, `default-features` off; `#![forbid(unsafe_code)]` holds). Parses flow *and* block sequences, typed `negative:` (phase+type), `features:`, description/info. `test262.rs`'s three-field hand parser is retired by delegating to it.
- **Feature skip list** (`gxFeatures` analogue) + `--features-include` opt-in (e.g. `ses-xs-parity`).
- **Sloppy+strict mode selection** (`onlyStrict`/`noStrict`/`raw`); strict is a named skip until the stage-5 compiler.
- **Negative verdicts** — constructor-name vs `negative.type`, stack/meter aborts accepted for an expected `RangeError`; parse/resolution negatives named-skipped until `endor-compile` lands.
- **Dual-run oracle wiring** (`--oracle` default-on) — verdict-agreement gating, observable-agreement gating, computron comparison **advisory** (accuracy-over-parity), `--gate-meter-exact` tightening, `--repeat N` determinism gate.
- **xst-shaped YAML report** (`-o`) — `mode:`/`skip:`/`fail:` plus endor `advisory:`/`skip-detail:`; validated as well-formed YAML.

### Retirement
`test262-language` retired **by name** (file + Cargo entry removed; README + in-crate refs rewired). Verified reproduction: identical covered/skipped/divergent split on every subtree checked (addition 48/15/0, if 69/17/0, throw 14/14/0, logical-not 19/15/0) — the *only* delta is former `builtin-coercion-computron-gap` skips now reported as `covered` + a computron advisory, exactly the design's accuracy-over-parity upgrade.

### Verification
All **61** endor-262 lib tests pass (incl. new frontmatter/xst unit tests + a bounded xst integration bar); clippy clean on the new Rust; rustfmt applied.

### Follow-ups
- **Flagged to maintainer (pre-existing, not mine):** the committed `c/moddable` gitlink is `5516726` (moddable 8.0.1), but HEAD's "bump oracle pin → 8.3.1" commit, the oracle build script, and the `module_corpora_byte_identity_no_divergence` test all require `23b4d6b` (8.3.1) — that test fails at 8.0.1, passes at 8.3.1. A fresh `submodule update --init` reds the endor-262 module-byte gate. The pin-bump commit appears to have not staged the submodule pointer. I did not touch the gitlink (out of scope); it needs a separate `c/moddable → 23b4d6b` commit.
- Remaining convergence children (2/5 corpus conversion, 3/5 async/`$DONE`, 4/5 lockdown/third-host, 5/5 fuzz-trophies) are gated on later stages per the design's orchestration and not part of this core step.
