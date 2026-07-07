---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T12:55:03Z -->

---
model: opus
---
# Stage-5 fix2 2/6: private member READS + static-block lexicals (closes the class-tail loud folds)

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07).

## The problem

Round-1's class-tail child (`1cb4529c1`) landed private member DECLARATION (fields, methods,
accessors, instance + static, two-pass collection order) byte-identically, but left two named
loud folds (self-naming coder panics, never mis-emits) that now dominate the class subtree's
endor-rejects (1572+ rejects across the sweep):

1. **Private member reads/writes in bodies** — `this.#x` get/set, `obj.#m()` calls,
   `#x in obj` (ergonomic brand checks): the `GET_PRIVATE`/`SET_PRIVATE`/`HAS_PRIVATE`
   access path. Port from `xsCode.c` at the pin: how a private reference resolves through
   the class-scope `symbolAccess`/`valueAccess` closures the declaration slice already
   creates, and the member-access coder branch that emits the `*_PRIVATE` family (including
   compound assignment / increment on private members and optional-chained private access
   `obj?.#x` if XS supports it at the pin — check the oracle, mirror exactly).
2. **Static blocks with local lexical declarations** — the field-init function needs its own
   frame count for block locals (round-1 report: "needs the field function's own frame count
   for block locals").

## Bar

- Private-read/write/brand-check + static-block-lexical fixtures added to
  `endor-compile/tests/coder_byte_identity.rs`, each byte-identical vs the oracle.
- `compile-diff` on `statements/class`: endor-rejected drops substantially (report the
  before/after tally and NAME every remaining reject class); divergent must not increase.
  Report the divergent split you observe — byte-length/accessor-key divergences belong to
  sibling 3, do not chase them.
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

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  claimed_at: 2026-07-07T13:43:09Z
