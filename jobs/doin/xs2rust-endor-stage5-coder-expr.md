---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T00:13:08Z -->

---
model: opus
---
# Stage-5 child 5/7: coder — emitter framework + expression/simple-statement bytecode (`xsCode.c`, first half)

Port the XS coder's emission framework and the expression + simple-statement surface into
`endor-compile` (lexer/parser/scoper landed in children 1–4). This child produces the FIRST real
byte-identity evidence.

**Scope, per `xsCode.c`:**
- The emitter framework: code buffer, the two-pass branch sizing XS performs (branch-width
  selection — this visibly shapes the bytes; port the exact algorithm, not an equivalent),
  targets/fixups, stack-depth accounting, atom/identifier ID assignment and constant
  encodings in exactly XS's order, function-body chunk layout and headers as `endor-vm`'s
  decoder already consumes them (the decoder — `endor-vm/src/opcode.rs` + interp — is your
  in-tree Rosetta stone for encodings).
- Emission for: literals of every kind, identifier/property loads and stores (with the scoper's
  slot indices), all unary/binary/relational/logical/coalescing operators, conditional,
  assignment (simple + compound + destructuring-assignment), call/new/member (incl. optional
  chaining's branch shape), object/array literal construction, template literals, sequence;
  expression statements, `if`/`else`, blocks, `var`/lexical declarations without initial-value
  edge cases deferred to child 6 only where genuinely function-shaped.
- Parse/codegen meter accounting continued.

**Local bar — byte identity on a fixture corpus:**
- A differential test: for each fixture source (grow a corpus of expression/simple-statement
  programs, incl. slices of the stage-1/2 conformance files), assert
  `endor_compile::compile(src)` bytes == `endor_oracle::run(src).bytecode`, byte for byte.
  Divergences print an opcode-level diff (you will need a small disassembler for triage — it
  pays for itself immediately).
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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-07T00:13:14Z
