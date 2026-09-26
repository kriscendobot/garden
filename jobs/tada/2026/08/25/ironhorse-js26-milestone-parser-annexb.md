Work complete and pushed. Here is my report.

---

## Milestone: js-26 parser/compiler-unimplemented + Annex-B parse (`parse-or-decode` family)

**Repo:** endojs/endo-but-for-bots · **Branch:** `feat/ironhorse-262-language-completion` · **Head SHA:** `a4f611c36b041f3a40e8e6a2b533815d223ecf9a` · **Draft PR:** [#1060](https://github.com/endojs/endo-but-for-bots/pull/1060) (OPEN/DRAFT; the prior #970 was merged upstream by someone else and #1060 is its live successor on the same branch — invariant preserved).

### What I did
Measured the four in-scope slices against the XS differential oracle (pins as specified: engine `b3c3ae93`, test262 `be13516f`, Moddable `23b4d6b0`), isolated the parser/compiler-level residuals from the VM-level ones, and landed two front-end fixes:

1. **`AllPrivateNamesValid` early error, strict mode** (`ironhorse-compile/src/scoper.rs`). An unresolved private-name reference (`this.#x`, `obj.#m()`, `#x in obj`) already rejected correctly in sloppy mode, but the strict eval-goal scope synthesized a brand declare (mirroring XS `fxScopeLookup`) and then **panicked** in the coder's `assert_declared_kind` → `strict:compiler-unimplemented:parse`. The static oracle-shim compile drives the whole program as one eval goal, so this scope is the top-level program with no enclosing private environment — the synthesized brand can never resolve. Removing the synthesize lets `bind_private_member` report `invalid private identifier`, matching XS's own SyntaxError verdict (XS emits a stub and throws a deferred runtime SyntaxError, which both the runner and `compile_diff` treat as a parse rejection). Verified safe for byte-identity: these sources are never accept+complete on XS.

2. **`invalid break` / `invalid continue`** (`ironhorse-compile/src/coder.rs`). A `break`/`continue` with no enclosing target `panic!`ed; XS reports it as a code-time `fxReportParserError`. Now records the structured SyntaxError via the existing `report()` path, matching XS in both modes.

Added a regression test (`ironhorse-262/tests/parse_early_errors_private_and_break.rs`) covering both families, sloppy and strict, asserting `IronhorseCompile::Rejected` + `BothAbort` + SyntaxError.

### Before → after (real oracle runs, per slice)
| slice | before covered | after covered | Δ | fail |
|---|---|---|---|---|
| language/function-code | 201 | 201 | 0 | 0 |
| language/global-code | 20 | **24** | +4 | 0 |
| language/statements/class | 3892 | **3935** | +43 | 0 |
| annexB/language | 349 | 349 | 0 | 0 |

**+47 cases converted to COVERED via real XS-differential execution**, zero new failures, `ironhorse-failure`/`infrastructure` unchanged. The private-name (`compiler-unimplemented:parse`) and break/continue clusters are fully closed.

### Gates (all run)
- Four affected official slices: rc=0, +47 covered, no regressions.
- `cargo test --workspace --release`: **pass** (exit 0), incl. new regression test.
- `ironhorse-xst --gate-meter-exact`: 51 failures, **all pre-existing** and entirely in `built-ins/stage3*` (json-metering, regexp, bigint, number, string) — the documented off-by-one baseline (see memory `ironhorse-262-branch-meter-gate-red`). Disjoint from my language-level rejection changes, which emit no built-in bytecode and cannot shift a metering count. Not my regression; not repairable within this family's scope.

### Honest residual (what remains and where)
- **`language/statements/class`: 3 `parse-or-decode`** — `static-init-scope-{var-open,var-close,lex-close}`. These need the deferred "static block with lexical declarations" coder fold (var/lexical hoisting into the field-init function scope with XS-exact `scopeMaximum`/RESERVE frame reservation, two panic sites at coder.rs:2960/2997). Left un-closed: it's a deep byte-exact-sensitive fold better suited to a dedicated claim, and milestone discipline is to bank verified gains rather than risk the byte-identity bar for 3 cases.
- **`annexB/language`: 6 `parse-or-decode`** — the `eval-code/{direct,indirect}/global-{block-decl,switch-case,switch-dflt}-...` Annex B.3.3 cases. Confirmed these depend on **direct-eval runtime execution** (the outer program parses/accepts fine; the decode arises inside the eval'd string). That is the VM/runtime surface (`eval:direct-scope`), out of scope for this parse-family milestone.

The remaining VM-level skips in these slices (`abort-value-differs`, `unsupported-opcode:*`, `feature:IsHTMLDDA`, `async:*`, etc.) are out of scope by causal reason and were left untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-parser-annexb.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 230 tokens (13673404 cached reads)
- Output: 68471 tokens
- Cost: $10.266124
- Wall-clock: 1077s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
