Inbox empty. All checklist items complete. The PR stayed DRAFT (I only pushed the README commit to the branch head; posted no PR comment, messaged no maintainer).

---

# fix4-verify 4/4 — completion report

**Full stage-5 byte-identity re-verification on a fresh sync of the live tip.** Synced `origin/xs2rust-endor` to **`d93d2a4ee8`** (all three fix4 siblings present: structural field-init fold, direct-eval prelude, numeric-key/captured-`arguments`/captured-self-name slice), oracle pinned `c/moddable` @ **`48ee02d8`** (never `git add`-ed). No engine-code change was needed; landed a **README-only** refresh (commit `1762272561`, pushed rebase-CAS to `xs2rust-endor`, git EXIT=0).

## Results — every bar re-measured, captured to file, `$?` checked directly

| bar | result |
|---|---|
| Workspace (`cargo test --workspace -- --test-threads=1`) | **EXIT=0**, all 20 `test result:` lines **ok** |
| Curated corpora (`compile-diff`) | **1711/1711** identical, divergent=0, endor-rej=0, accept-disagree=0 |
| Module corpora (`module_corpora_byte_identity_no_divergence`) | ran **ok** (45/45) |
| Determinism + fuzz smokes | `parse_computrons_are_deterministic_per_build`, `decoder_never_panics…`, `parser_is_total…` all **ok** |
| `using` reject-agreement | both engines throw `SyntaxError: missing ;` (harness `BothAbort`) |
| `#![forbid(unsafe_code)]` | intact at crate root in every engine crate; `endor-oracle` the sole documented FFI-seam exception |

**Stage-4 dual-runs** (all EXIT=0, **no crash-aborts**, every skip a named `unsupported-opcode:*`): `built-ins/Object` **176/0** of 3127 · `built-ins/Function` **40/0** of 511 · `built-ins/Array` **437/0** of 2625.

**13-subtree sweep — every subtree byte-clean (`divergent=0 endor-rej=0 accept-disagree=0`, EXIT=0):**

| subtree | total | identical | div | subtree | total | identical | div |
|---|---:|---:|---:|---|---:|---:|---:|
| addition | 48 | 48 | 0 | object | 1049 | 914 | 0 |
| if | 69 | 29 | 0 | **statements/class** | 3908 | 3298 | **0** |
| conditional | 22 | 20 | 0 | switch | 105 | 36 | 0 |
| for-of | 712 | 641 | 0 | call | 96 | 95 | 0 |
| try | 192 | 168 | 0 | **expressions/class** (new) | 3663 | 3086 | **0** |
| async-generator | 585 | 507 | 0 | | | | |
| assignment | 466 | 404 | 0 | function | 434 | 390 | 0 |

Since fix3-verify: `statements/class` **62 → 0**, `expressions/class` **50 → 0** (the subtree the fix3 sweep missed — measured for the first time this round, confirmed clean), `expressions/call`'s lone `tco-call-args` fold closed (endor-rej 1 → 0). All `oracle-rejected` counts are accept-**agreements** (accept-disagree=0 everywhere).

## Attribution (step 10) — no unattributable divergence

Across the curated + module corpora and all 13 swept subtrees: **zero** byte divergences, **zero** endor-rejected folds — a clean bill, nothing to attribute. The **only** residual divergence anywhere in `language/` is `expressions/arrow-function` (**6** divergent, endor-rej=0), which I measured explicitly for an honest full-tree verdict and **fully attributed**: all 6 are `byte-length/endor-shorter` on the `scope-param-{elem,rest-elem}-var-{open,close}` / `scope-body-lex-distinct` / `arrow/binding-tests-3` family — a parameter var-environment / body-lexical **scope-slot classification** scoper fold (closure-vs-local opcode-pair family, fixed first-diff opcode delta of 4). Known, pre-existing, outside the class-focused fix4 scope. **No unexplained byte divergence anywhere ⇒ no new kill-criterion evidence.**

## Verdict

**FULL STAGE-5 BAR: NOT MET** — strict `divergent == 0` *everywhere* across `language/` is held open **solely** by the fully-attributed 6-file `expressions/arrow-function` scoper fold. The bar **IS MET** on the curated corpora (1711/1711), module corpora (45/45), and **all 13** swept subtrees — including the **entire class surface** (`statements/class` 0, `expressions/class` 0), which was the fix4 target and is now byte-clean (62 + 50 → 0). `accept-disagree == 0` and `endor-rejected == 0` hold on every measured subtree.

**Changed:** `rust/engine/README.md` only (section heading + authoritative-verdict callout + new "fix4-verify 4/4" block with the 13-subtree table, all-bars ledger, attribution partition, and explicit BAR line). **Follow-up:** the `expressions/arrow-function` scope-param-var-environment scoper fold (6 divergent) is the sole remaining gap to a strict full stage-5 bar — a narrow, named scoper fold for a later slice, not a feasibility wall. PR #600 left DRAFT; no PR comment, no maintainer message.
