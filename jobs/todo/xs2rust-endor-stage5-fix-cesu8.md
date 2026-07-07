---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T10:25:03Z -->

---
model: opus
---
# Stage-5 fix 1/5: CESU-8 string-literal emission (closes ALL 60 byte divergences)

Child of orchestration `xs2rust-endor-build-stage5-fix` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Oracle pin `48ee02d8cfe0`. Design: `designs/xs2rust-endor-engine.md`.

## The problem (stage-5 acceptance child's finding, README § Stage-5 acceptance evidence)

The full-corpus byte-identity harness (`endor-262/src/compile_diff.rs`, `compile-diff` bin)
measures 60 divergent files — **every one** in `stage3-string-utf16.js`, **one root cause**:
XS stores string literals in bytecode as **CESU-8** (a non-BMP char = a surrogate pair, each
surrogate its own 3-byte unit = 6 bytes; a LONE surrogate = a 3-byte CESU-8 sequence that is
not valid UTF-8 at all), while the Rust coder emits the Rust `String`'s UTF-8 (astral = 4
bytes; lone surrogates unrepresentable in `String` at all).

## The task

Change the string-VALUE representation across **lexer → AST → coder** so string literals
(and any other string payloads baked into the code stream — property keys reaching the
symbol/atom table, template literal cooked/raw strings, etc.) carry **UTF-16 code units (or
WTF-8)** end to end and the coder emits XS's CESU-8 bytes exactly. Note the engine side
(endor-vm) already did its UTF-16 strings rework at stage 4 — mirror its representation
choices where that helps. The atom table hashes/interns must keep matching XS byte-for-byte
after the change (the hash runs over XS's bytes — verify against symbol-bearing dumps).

**Bar:** `compile-diff` over the curated corpora goes divergent=0 for the string corpus
(60 → 0) with NO new divergence anywhere else; the in-crate gate
`corpora_byte_identity_no_undocumented_divergence` updated so CESU-8 is no longer a
documented fold; `cargo test --workspace -- --test-threads=1` EXIT=0 (capture output to a
file and check `$?` — a pipe to `tail` masks the exit code). Add lone-surrogate and astral
byte-identity fixtures to `endor-compile/tests/coder_byte_identity.rs`.

## Ground rules

- FIRST: get your isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip — never trust a
  stale tracking ref (multiple sessions advance this branch).
- Oracle pin is depth-1-fetchable from the garden bare clone: populate `c/moddable` with
  `git init` there, then `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD`.
  NEVER `git add` c/moddable. `cargo` at `$HOME/.cargo/bin`.
- Commit explicit pathspecs; push rebase-CAS (`git push origin HEAD:xs2rust-endor`, retry on
  reject after rebase), verify pushes by git EXIT CODE. `#![forbid(unsafe_code)]` stays
  intact everywhere. Land green pushed slices as you go.
- Size to ONE 2400s invocation: if budget nears end with work remaining, push what is green
  and report the fold honestly — never sit on a large uncommitted/broken tree.
- Report completion or fold to the SUPERVISOR inbox:
  `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s13` —
  NEVER the maintainer inbox; NEVER comment on the PR; KEEP the PR DRAFT.
