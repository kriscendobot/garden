---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T21:55:18Z -->

---
model: opus
---
# Stage-5 child 2/7: parser — expression grammar (`xsSyntaxical.c`, first half)

Port the XS parser's AST model and expression grammar into `endor-compile` (the lexer landed in
child 1; build on it).

**Scope:**
- AST node model mirroring XS's `txNode` kinds and layouts from `xsScript.h` — same node kinds,
  same child order, same flags. Do NOT design a nicer AST: the scoper and coder byte-identity
  depend on XS's exact tree shapes (e.g. how XS desugars or flags a construct is the spec).
- Expression grammar per `xsSyntaxical.c`: primary expressions, member/call/new (incl.
  `new.target`, `import.meta`, dynamic `import()`), optional chaining, tagged templates,
  unary/update/binary/relational/shift/logical/coalescing with XS's exact precedence and
  associativity, conditional, assignment (all compound operators), comma; object and array
  literals (spread, computed keys, methods, getters/setters, `__proto__` handling as XS does
  it); destructuring binding + assignment patterns (with defaults, rest, nesting); arrow
  functions (incl. async arrows and the cover-grammar reparse the way XS resolves it); `yield` /
  `await` in expression position with the parser-state flags XS uses; regexp-vs-divide
  disambiguation wired to the lexer.
- Structured syntax errors matching XS's error classification (early errors that live in the
  parser); no panics on malformed input.
- Parse-meter accounting continued per production.

**Local bars:**
- AST fixture tests (dump-and-compare) over an expression corpus covering every construct above,
  green.
- `cargo test --workspace -- --test-threads=1` EXIT=0.
## Program context (shared by every stage-5 child)

You are ONE child of the serial orchestration `xs2rust-endor-build-stage5` — stage 5 (compiler
port) of the XS→Rust port program on PR `endojs/endo-but-for-bots#600` (branch `xs2rust-endor`,
base `llm`, **KEEP DRAFT**). Design: `designs/xs2rust-endor-engine.md` (§ roadmap row 5; Design
Decisions 4 and 5). Stages 1–4 are built and accepted (stage-4 acceptance: PR #600
issuecomment-4897783472). Stage 5 ports the XS compiler into a new `endor-compile` crate
(lexer → parser → scoper → coder) to replace the oracle compiler, behind the stage bar:
**byte-identical bytecode vs the oracle compiler on the full conformance corpus**
(`endor_oracle::run(source).bytecode` already returns the exact XS-emitted bytes to compare
against), plus deterministic-per-release parse metering and an armed parser fuzz target. The
byte-identity kill criterion is real: XS's coder is the ground truth — port its behavior exactly
(node shapes, slot numbering, branch sizing, atom/constant table order all leak into the bytes).

Practical (hard-won, do not rediscover):
- Isolated worktree: `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <YOUR-JOB-BASE> endojs/endo-but-for-bots xs2rust-endor`, cd to the printed path. Never work in a shared checkout.
- Reference C sources at oracle pin `48ee02d8cfe0`: `c/moddable/xs/sources/{xsLexical,xsSyntaxical,xsScope,xsCode}.c` + `xsScript.h`. The committed gitlink is a known-stale value; populate with `git init` inside `c/moddable`, then `git -C c/moddable fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git -C c/moddable checkout FETCH_HEAD` (depth-1 works; a full fetch dies on missing parents). NEVER `git add` anything under `c/moddable`.
- `cargo` is at `$HOME/.cargo/bin`. Workspace: `rust/engine`. Every engine crate keeps `#![forbid(unsafe_code)]`.
- Capture `cargo test` output to a FILE and check `$?` directly (piping to `tail` masks the exit code). `cargo test --workspace -- --test-threads=1` must be EXIT=0 before every push.
- DOCTRINE (accuracy-over-parity, maintainer-directed 2026-07-04): the meter is endor's own frozen release-versioned cost table (`endor-meter-N`); the C-XS oracle certifies RESULTS — and in this stage BYTES — while computron-vs-oracle stays advisory telemetry. Never back-fit meter constants to oracle computrons or CESU-8 byte lengths.
- Commit with explicit pathspecs; push with a rebase-CAS loop (`git push origin HEAD:xs2rust-endor`, rebase-and-retry on rejection). Keep PR #600 DRAFT. No maintainer contact, no PR comments.
- BUDGET DISCIPLINE (hard lesson from stages 3–4): you have ONE 2400s handler invocation. Land and push your FIRST GREEN SLICE inside the first half of the budget, then iterate in small landable increments — never sit on a large uncommitted tree. If the budget runs out, push what is green and report the honest remainder.
- REPORT: send your completion / scope-fold report to inbox `port-xs-to-rust-memory-safe-engine-s12` via `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s12` — NEVER the maintainer inbox. Name every fold (anything you scoped out) explicitly.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->
