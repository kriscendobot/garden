Inbox empty. All verification steps complete. Here is my report.

---

# fix3-verify 5/5 — full stage-5 byte-identity re-verification

**Remote tip:** synced to `4a8bdf6ab9` (`git fetch origin xs2rust-endor` → FETCH_HEAD). All four fix3 siblings present (Class α `b1581c9250`/`8b0ca20e8a`, Class β `4305c946d0`/`946372a598`, Class γ `9f45d63ba5`/`632bb6c04d`/`729a581ba6`/`a608404cfc`, Class δ `4a8bdf6ab9`). Oracle pinned at `48ee02d8cfe0` in `c/moddable` (never staged). PR #600 kept DRAFT; no PR comment, no maintainer message.

## Results

| Gate | Result | Status |
|---|---|---|
| **Workspace** `cargo test --workspace -1` | EXIT=0, every `test result: ok`, no failures/OOM | ✅ |
| **Curated corpora** (`compile-diff`) | `total=1711 identical=1711 divergent=0 endor-rejected=0 accept-disagree=0` | ✅ BAR MET |
| **Module corpora** (in-crate gate) | `corpora-modules: total=45 identical=45 divergent=0 endor-rejected=0 accept-disagree=0` | ✅ BAR MET |
| **Determinism** | `parse_computrons_are_deterministic_per_build … ok` | ✅ |
| **Fuzz smokes** | `decoder_never_panics…`, `parser_is_total…` ok | ✅ |
| **`using` reject-agreement** | both throw `SyntaxError: missing ;` (only cost differs → skip, not divergence) | ✅ |

**Stage-4 dual-run spot-checks** (all EXIT=0, no crash-aborts): `built-ins/Object` 176/0 of 3127 ✅; `built-ins/Function` 40/0 of 511 ✅; `built-ins/Array` 437/0 of 2625 ✅ — all match expected.

**Broadened byte-identity sweep, 12 subtrees** (`compile-diff <subtree>`, columns total/identical/divergent/endor-rej/oracle-rej/accept-disagree):

| subtree | total | ident | **div** | endor-rej | oracle-rej | acc-dis |
|---|--:|--:|--:|--:|--:|--:|
| expressions/addition | 48 | 48 | **0** | 0 | 0 | 0 |
| statements/if | 69 | 29 | **0** | 0 | 40 | 0 |
| expressions/conditional | 22 | 20 | **0** | 0 | 2 | 0 |
| statements/for-of | 712 | 641 | **0** | 0 | 71 | 0 |
| statements/try | 192 | 168 | **0** | 0 | 24 | 0 |
| expressions/async-generator | 585 | 507 | **0** | 0 | 78 | 0 |
| expressions/assignment | 466 | 404 | **0** | 0 | 62 | 0 |
| statements/function | 434 | 390 | **0** | 0 | 44 | 0 |
| expressions/object | 1049 | 914 | **0** | 0 | 135 | 0 |
| **statements/class** | 3908 | 3236 | **62** | 0 | 610 | 0 |
| statements/switch *(new)* | 105 | 36 | **0** | 0 | 69 | 0 |
| expressions/call *(new)* | 96 | 94 | **0** | **1** | 1 | 0 |

fix3 drove `object`/`assignment`/`function` fully byte-clean (and their endor-rejects → 0) and `class` 113 → 62.

## Attribution (item 8) — every residual named, opcode-by-opcode

The 62 `class` divergences partition, all disassembled and confirmed:
- **Class α** (closure-vs-local scope classification) — **6**: `accessor-name-{inst,static}/literal-numeric-{leading-decimal,non-canonical}`, `strict-mode/arguments-callee`, `intercalated-static-non-static-computed-fields`. Spot-check: `literal-numeric-leading-decimal` diff@5, endor 16B longer (local vs closure slot).
- **Class β** (private-member install: nested-class scope count + brand read index) — **35**: the `private-*-on-nested-class` / shadowing / `privatefield{get,set}-typeerror` family. Spot-check: `private-field-on-nested-class` diff@4 `RESERVE 0x0d` vs oracle `0x09`.
- **Class γ** (in-initializer direct-eval field-function scope) — **19**: `*direct-eval*` / `*-visible-to-direct-eval-*` family. Spot-check: `derived-cls-direct-eval-contains-superproperty-1` diff@195, endor 7B shorter (omitted eval prelude).
- **Class ε** (field-init function scope / temp depth) — **2**: `init-value-incremental`, `static-field-init-with-this`. Spot-check: `init-value-incremental` diff@150 `RESERVE 0x02` vs `0x03`.

6 + 35 + 19 + 2 = 62. The one `endor-rejected` (`expressions/call/tco-call-args.js`) is the **named** coder fold `captured function name deferred` (`coder.rs:3100` assert). **No unattributable divergence anywhere ⇒ no new kill-criterion evidence.**

## BAR verdict (item 10)

**FULL STAGE-5 BAR: BAR NOT MET** — `divergent == 0` everywhere fails on `statements/class` (62 fully-attributed byte divergences). The bar **IS MET** on curated corpora (1711/1711), module corpora (45/45), and 11 of 12 broadened subtrees; `accept-disagree == 0` holds **everywhere**; the sole `endor-rejected` is the one named `tco-call-args.js` fold. Every residual is a narrow, named coder mechanism (α/β/γ/ε), not a feasibility wall.

## README refresh (item 9)

Committed README-only (`rust/engine/README.md`, +88/−32, explicit pathspec) as `2632f1e3c7`, pushed rebase-CAS to `xs2rust-endor` (verified EXIT=0, remote tip = `2632f1e3c7`): updated section header to fix3-verify 5/5, replaced the broadened-sweep table with the re-measured 12 subtrees, rewrote the residual ledger with the exact α/β/γ/ε partition + opcode spot-checks, corrected the stale "62 = γ + 2 ε" characterization, added the `call` named-fold note, and added an explicit `FULL STAGE-5 BAR: NOT MET` status line.

**Follow-ups (not this job):** the remaining `class` residual is the class private-member install (β), class field-initializer direct-eval + real field-init function scope (γ/ε), and literal-numeric-key / captured-`arguments` scope classification (α); plus the `tco-call-args.js` captured-function-name coder fold — all narrow, all deferred.
