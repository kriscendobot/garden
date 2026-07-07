---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T14:52:25Z -->

---
model: opus
---
# Stage-5 fix2 4/6: direct eval inside a function (the EVAL environment slice)

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07).

## The problem

Round-1's rejects child attempted in-function direct eval, found it needs the whole
in-function eval-body slice — not just the parameter `with`/`STORE` dance — reverted, and
documented it as the self-naming assert `eval-scope params deferred` on
`scope_coding_params`. Program/block-level direct eval is already byte-identical. This is
the port's deepest remaining loud fold (it rejects, never mis-emits), and it blocks real
test262 files (e.g. `statements/try/catch-parameter-boundnames-restriction-*-eval-throws.js`).

## The task

Port XS's in-function direct-eval emission from `xsCode.c`/`xsScope.c` at the pin, whole
slice: the `EVAL` opcode's environment plumbing (`EVAL_ENVIRONMENT`/`EVAL_REFERENCE` family
as XS emits them inside a function), the parameter dance under a detected direct eval
(`fxScopeCodingParams`'s eval branch — the `with`-published parameter frame), sloppy-mode
in-function eval variable resolution, and the strict-mode variant. Work incrementally:
params-only first, then body forms; keep each landed slice byte-identical.

## Bar

- The `eval-scope params deferred` assert is gone; in-function direct-eval fixtures (sloppy +
  strict, param + body references, nested functions) added to
  `endor-compile/tests/coder_byte_identity.rs`, byte-identical vs the oracle.
- `statements/try` endor-rejected → 0. Report before/after reject tallies on `statements/try`
  and one more eval-heavy subtree of your choosing.
- If the full slice exceeds budget: land the green sub-slices, keep a self-naming assert on
  the honest remainder, and report the precise residual scope.
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

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  claimed_at: 2026-07-07T14:52:29Z
