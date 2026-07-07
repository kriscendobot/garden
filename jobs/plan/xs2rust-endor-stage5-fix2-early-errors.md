---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix2
priority: normal
posted_by: producer
posted_at: 2026-07-07T12:43:34Z
---

---
model: opus
---
# Stage-5 fix2 5/6: missing early errors (Class E accept-disagreements) + dynamic import()/import.meta coders

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07).

## The problem

**Accept-disagreements** (endor ACCEPTS what the oracle REJECTS — the wrong-direction half of
the accept/reject-agreement bar; 53 in `statements/class`, 2 in `expressions/object` at the
round-1 sweep): missing early errors. Named classes from the sweep:
- `arguments` inside a class-field initializer (`*-init-err-contains-arguments`);
- duplicate private methods (`grammar-privatemeth-duplicate-*`);
- non-simple parameter list with a `"use strict"` body (`*-param-strict-body`).

Port each check from the oracle's parser/scoper at the pin (find where xsSyntaxical.c /
xsScope.c raises them), so endor rejects exactly the set the oracle rejects. Sweep
`statements/class` and `expressions/object` for any FURTHER accept-disagree classes and close
or name them.

## Secondary scope (if budget allows, after Class E is closed)

Dynamic `import()` and `import.meta` node CODERS (module goal): the parser flags are wired
and the MODULE flag byte is ready (round-1 modules child, `825213276`), but no coder/fixture
exists. Port `fxImportCallNodeCode`/`fxImportMetaNodeCode` (their names at the pin may
differ — find the oracle's emission) + curated module fixtures, byte-identical.

## Bar

- Accept-disagree → **0** on `statements/class` and `expressions/object` (report the tally;
  divergent/rejected counts in those subtrees are siblings' scope — do not chase, just report).
- Negative-parse fixtures for each early error added (endor-compile parser tests asserting
  rejection + oracle agreement via the differential harness).
- Curated corpora stay `1711/1711 divergent=0 endor-rejected=0`; module corpora green (35/35
  or better if import()/import.meta lands with new fixtures).
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
