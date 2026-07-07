---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T00:40:04Z -->

---
model: opus
---
# Stage-5 child 6/7: coder — functions, classes, control flow, generators/async, modules (`xsCode.c`, second half)

Complete the `endor-compile` coder's emission surface (framework + expressions landed in child 5).

**Scope, per `xsCode.c`:**
- Function emission in all flavors: plain/generator/async/async-generator, parameter-list
  emission (defaults, destructuring, rest), `arguments` machinery, closures (the scoper's slot
  contract), arrow functions, home-object/`super` paths.
- Classes: constructor/derived-constructor emission, methods/accessors, static members, private
  fields/methods/brands, static blocks — to the pin's surface.
- Control flow: all loop forms (incl. `for-in`/`for-of`/`for-await-of` iteration protocols as
  XS emits them), `switch`, labeled break/continue, `try`/`catch`/`finally` (the CatchJump/
  unwind shapes the interpreter already executes), `with`, `debugger`.
- Generators/async: yield/await emission, the saved-frame shapes the stage-3/4 interpreter work
  established.
- Modules: import/export linkage emission per the pin, module-body wrapper.
- Strict-vs-sloppy emission differences wherever XS branches on mode.

**Local bar:**
- Byte-identity fixtures spanning every construct above (extend child 5's differential test +
  disassembler diff), incl. per-construct slices drawn from the stage-1..4 conformance corpora,
  all byte-identical.
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

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  claimed_at: 2026-07-07T07:43:07Z
