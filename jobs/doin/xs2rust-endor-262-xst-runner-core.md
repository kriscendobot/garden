---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-11T05:01:34Z -->

---
model: opus
---
# Builder: endor-xst core — the xst-analogue test262 runner (PR #600, test262-convergence child 1/5)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT).
Design: `designs/xs2rust-endor-test262-convergence.md` § Part 2 (the behavioral table is
grounded in `xs/tools/xst.c` + `xs/tools/xst262.c` at the pin `48ee02d8cfe0`).

Build the `endor-xst` binary in the `endor-262` crate: full YAML frontmatter parsing
(replacing `test262.rs`'s three-field hand parser; pure-Rust YAML, `forbid(unsafe_code)`),
the endor not-yet-implemented feature skip list + `--features-include`, sloppy+strict
double-run mode selection (strict = named skip until stage 5), negative verdicts
(constructor-name vs `negative.type`, stack/memory aborts accepted for expected
RangeError), the dual-run oracle wiring (`--oracle` default-on: verdict agreement gating,
observable agreement gating, computron advisory; `--gate-meter-exact`, `--repeat N`
determinism gate), and the xst-shaped YAML report (`mode:`/`skip:`/`fail:` plus
`advisory:` and `skip-detail:`). Subsumes and retires `test262-language` by name once it
reproduces its output.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-11T06:03:09Z
