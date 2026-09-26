The generators are provably unchanged (endor-fuzz diff is a doc comment only). The work is complete, verified, and pushed. Here is my completion report.

---

## Completion report: `xs2rust-endor-262-fuzz-trophies-regressions` (PR #600 convergence 5/5)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` — pushed as `194454363a`, PR #600 confirmed still **DRAFT/OPEN**.

### What I did
Established `rust/engine/endor-262/cases/regressions/` as the durable, portable home for differential-fuzz trophies, per design § Part 1 ("The fuzz-grammar arms"), and amended the fix workflow so every future trophy lands here. The `endor-fuzz` generators are unchanged (verified: the only endor-fuzz diff is a doc comment — no `gen_*` edits).

### The honest trophy inventory (established via a thorough sweep)
The differential-fuzz arms run bit-exact by construction, so the **source-level runtime axis carries no residual named trophies** — every bring-up divergence was folded into the stage corpus (now `cases/language` / `cases/built-ins`) as it was fixed. The genuinely-durable trophies live by shape:
- **One source-expressible trophy** → seeded here (below).
- **Decoder-hang** (target 2, bytecode `[0x25 0xfe]`) → no JS-source preimage; stays locked in `endor_fuzz::decoder_hang_is_bounded_not_infinite`. Cross-referenced.
- **Compiler byte-identity** divergences (CESU-8 strings, the `()=>eval("this")` capture-closure fold) → dual-run to the same result; locked by the compile-diff corpus, not the runtime tree. Cross-referenced.

### Changes
- **`cases/regressions/regexp-backreference-out-of-range.js`** — the one source-expressible fuzz trophy. `differential_regexp` found XS reads a backreference's decimal digits greedily and rejects an out-of-range ref (`/\11/` with <11 groups) as SyntaxError rather than falling back to `\1`; fix in `endor-regexp`. A parse-negative (`endor-dual-run`, arm named in `info:`), named-skipped `pending-compiler` until `endor-compile` is the default dual-run compiler — identical to the converted corpus's parse-negatives.
- **`cases/regressions/README.md`** — case-shape contract, the full trophy inventory, and the fix workflow.
- **`tests/regressions_dual_run.rs`** — the gate: runs the tree through `endor-xst`, holds every case to **zero divergence** (named skips permitted), fails the build if a checked-in trophy re-diverges.
- **`tests/corpus_conversion_equivalence.rs`** — excludes `regressions/` (not corpus; its parse-negative skips would break `covered==total`).
- **`README.md` (engine)** + **`endor-fuzz/src/lib.rs`** — the fix-workflow amendment: where a trophy lands by shape.

### Verification (real execution)
- Built the C-XS oracle (initialized the `c/moddable` submodule) — clean build.
- **Trophy is genuine** (probe against the pinned oracle): both engines reject `/\11/` and `/\1/` (0 groups); both accept `/(a)\1/` and an 11-group `\11`. Probe removed after.
- `cargo test -p endor-262 --test regressions_dual_run` → **ok** (`total=1 covered=0 failed=0 skipped=1: negative-parse:pending-compiler`).
- `cargo test -p endor-262 --test corpus_conversion_equivalence` → **ok** (`total=1711 covered=1711 failed=0` — regressions cleanly excluded, count unchanged).
- `endor-fuzz` suite → passes.

### Follow-up (not mine; surfaced honestly)
`compile_diff::tests::module_corpora_byte_identity_no_divergence` **fails in this build environment** (`45/47 identical, 2 divergent`) against **both** the branch's recorded submodule gitlink (`5516726818…`) **and** the README's documented 8.3.1 pin (`23b4d6b0a65f`). It touches none of my files (compile_diff / module corpora / oracle / endor-compile) and is a pre-existing, environment-specific sensitivity in the stage-5 module byte-identity bar. Also worth noting: the recorded `c/moddable` gitlink at the branch head (`5516726818…`) does not match the README's documented pin (`23b4d6b0a65f`) — a possible stale-gitlink follow-up for the maintainer.
