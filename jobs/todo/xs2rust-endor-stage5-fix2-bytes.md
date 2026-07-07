---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T14:19:13Z -->

---
model: opus
---
# Stage-5 fix2 3/6: remaining byte-length divergences (Classes B+C — async-gen yield*, class-tail lengths, numeric accessor keys, class direct-eval)

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07). You run AFTER the named-eval and private-reads
siblings — re-measure first; attribution is cleaner now.

## The problem

After Class A (NamedEvaluation destructuring defaults) and the private-read folds close, the
sweep's remaining DIVERGENT files (both compilers accept, bytes differ) are:

- **Class B:** async-generator `yield*` byte-LENGTH divergences (`statements/for-of` and
  async-gen files) — likely a record-sizing/branch-width or missing dance segment in the
  delegated-yield emission vs `fxYieldNodeCode`/the async-gen resume path at the pin.
- **Class C:** class-tail byte-length divergences, numeric accessor keys
  (`get 1(){}`/`set 1(x){}` — the AT/atom encoding for numeric keys), and class-scope
  direct-eval divergences.

## The task

1. Re-run `compile-diff` on `statements/class`, `statements/for-of`, `expressions/object`,
   `expressions/assignment`, `statements/try` at YOUR tip; collect every remaining DIVERGENT
   file and attribute each to a class (the harness prints first-diff offsets; the crate has
   an opcode-level disassembler for triage).
2. Fix each attributed class byte-identically against the oracle source at the pin.
3. Anything you cannot attribute or fix in budget: name it precisely in your report with a
   representative file + first-diff triage — an UNATTRIBUTED divergence is kill-criterion
   evidence and the supervisor must see it clearly.

## Bar

- Named divergence classes B and C at **0** across the five subtrees above (or an honest,
  attributed fold report for what remains).
- Fixtures for each fixed construct in `endor-compile/tests/coder_byte_identity.rs`.
- Curated corpora stay `1711/1711 divergent=0 endor-rejected=0`; module corpora 35/35.
- `cargo test --workspace -- --test-threads=1` EXIT=0 (capture to file, check `$?`).
## Ground rules

- FIRST: get your isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip — never trust a
  stale tracking ref (multiple sessions advance this branch).
- Oracle pin (CORRECTED full sha — earlier specs carried a garbled one): populate `c/moddable`
  with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` c/moddable. `cargo` at `$HOME/.cargo/bin`.
- Byte-identity harness: `cargo run -p endor-262 --bin compile-diff` (no arg = curated
  corpora; one arg = a test262 subtree, e.g. `statements/try`). Run test262 per SUBTREE
  (whole-tree `language/` in one process OOMs). A pipe to `tail` masks exit codes — capture
  to a file and check `$?` directly.
- Commit explicit pathspecs; push rebase-CAS (`git push origin HEAD:xs2rust-endor`, retry on
  reject after rebase), verify pushes by git EXIT CODE. `#![forbid(unsafe_code)]` stays
  intact everywhere. Land green pushed slices as you go. `cargo test --workspace --
  --test-threads=1` must be EXIT=0 before every push.
- Size to ONE 2400s invocation: if budget nears end with work remaining, push what is green
  and report the remaining scope honestly as a fold — never sit on a large
  uncommitted/broken tree.
- REPORTING: your completion report (stdout → the job's tada record) IS the report of
  record — put the full measured tallies and any folds there. Do NOT inbox-send to the
  supervisor (it is parked and the send would dead-letter into a noise job). NEVER message
  the maintainer; NEVER comment on the PR; KEEP the PR DRAFT.
