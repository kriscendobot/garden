---
model: opus
---
# Fix the top-level-await module-bytecode divergence (stage-8 review F1) + the 4 cosmetic warnings (F2)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (keep DRAFT). Review comment
with the findings: https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-5009896419

Get an ISOLATED checkout with
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
sync to the REAL remote tip (the hourly press may have rebased; verify by subject + `git diff -- rust/ c/`
byte-identity before trusting history). You may seed `rust/engine/target/` and `c/moddable` by `cp -al`
from a sibling scratch worktree at the same commit (mind the empty-dir nesting gotcha; `rmdir` an empty
`c/moddable` first) — **but see the fresh-rebuild rule in the verification section: the F1 false-pass was
CAUSED by a stale seeded target, so your proof runs must rebuild the crates under test** (`cargo clean -p
endor-compile -p endor-vm` before the proof run is sufficient; keep the oracle's C build cached).
The Rust workspace is `rust/engine`. `cargo` at `$HOME/.cargo/bin`. Never pipe `cargo test` to `tail`
without capturing the exit code — write to a file, check `$?`. Oracle pin
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Never `git add` c/moddable or any generated bundle.

**PUSH-PER-ITEM DISCIPLINE (binding):** commit and push each item the moment it is green (rebase CAS loop,
verify by git exit code). An overrun must never lose finished work.

## Item 1 (F1, the substance): `compile_diff::tests::module_corpora_byte_identity_no_divergence`

At tip `43b6128e18` the test fails: endor emits 1 byte MORE than the C-XS oracle for both committed
top-level-await module programs (`endor-262/corpora-modules/top-level-await.js` cases #1 and #2):
`len oracle=154 endor=155` and `196/197`, first diff at **offset 1**, endor `0x07` vs oracle `0x57`.
Reproduced twice from fresh checkouts (tip `43b6128e18`, base `9bef7de22e`) — it is a REAL pre-existing
module-bytecode divergence in the COMPILE-only module entry (landed in the stage-5/6 era), unmasked
whenever the crate is actually rebuilt. It is NOT stage-8 damage (no stage-8 commit touches the
module-compile path).

Diagnose against the oracle's emission (the divergence starts at offset 1 — likely a header/flag or an
early opcode choice on the async-module/top-level-await path; compare `fxCoderAdd` traces or hex-dump both
buffers side by side). **Fix endor's emission to byte-match the oracle** — never the other way (the oracle
certifies bytes; no back-fit of the oracle, no corpus edit, no test relaxation). If the honest diagnosis is
that endor is RIGHT and the oracle disagrees with itself across contexts, do not guess: report the evidence
in your tada report and leave the test failing — the supervisor decides.

## Item 2 (F2, trivial): the 4 cosmetic warnings

`rust/engine/endor-vm/src/interp.rs:9756` (needless `mut push_segment`), `:11122` (unused `argc`),
`rust/engine/endor-compile/src/coder.rs:69` (`plus_one` never read), `:335` (`index` never read).
All pre-existing and one-line-trivial. Fix without behavior change (underscore-prefix or remove; if a field
is genuinely load-bearing-in-spirit, prefer the minimal `_`-rename and keep any explanatory comment). Line
numbers may have drifted — locate by warning text from a fresh `cargo build`.

## Verification (all from your checkout, exit codes captured to files)

1. `cargo clean -p endor-compile -p endor-vm && cargo test --workspace --no-fail-fast` → EXIT=0, ALL
   `test result:` lines 0 failed (35 lines expected), including `module_corpora_byte_identity_no_divergence`
   now green with `divergent=0`.
2. Curated compile-diff still all-identical + SYMB (1730/1730 at the current mark; report the count you
   measure) — invoke the prebuilt binary directly WITHOUT `--` (`./target/debug/compile-diff <subtree>`).
3. A modules-adjacent enumeration spot check: `language/module-code` (or the nearest module subtree the
   runner enumerates) + one unrelated subtree (e.g. `statements/class`) → 0 divergent, 0 accept-disagree.
4. Zero warnings from a fresh `cargo build --workspace` of the two touched crates.
5. `#![forbid(unsafe_code)]` untouched at all 7 engine crate roots.

The full 121-run enumeration is NOT your job (the s28 supervisor round re-measures it at your tip).

## Report

Tada completion report ONLY (never inbox-send the parked supervisor): the diagnosis (what the byte was,
why endor diverged), the fix, each bar's measured numbers + exit codes, commit shas pushed. Keep PR #600
DRAFT; do not comment on the PR (the supervisor posts the acceptance).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-18T04:27:31Z
