---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T23:07:10Z -->

---
model: opus
---
# Stage-5 child 3/7: parser — statements, declarations, functions/classes/modules (`xsSyntaxical.c`, second half)

Complete the `endor-compile` parser surface (expressions landed in child 2).

**Scope, per `xsSyntaxical.c`:**
- Statements: blocks, `var`/`let`/`const`, expression statements, `if`, all loop forms
  (incl. `for-in`/`for-of`/`for-await-of` with their binding forms), `switch`, labels,
  `break`/`continue`, `return`, `throw`, `try`/`catch` (optional binding)/`finally`, `with`
  (sloppy), `debugger`, empty statement.
- Automatic semicolon insertion exactly as XS applies it (restricted productions:
  `return`/`throw`/`break`/`continue`/postfix, arrow bodies).
- Directive prologues (`"use strict"`) and strict-mode propagation flags on the nodes XS sets.
- Function declarations/expressions in all flavors (plain, generator, async, async generator),
  parameters (defaults, destructuring, rest), the `arguments`/duplicate-parameter early errors
  per mode.
- Classes: declarations/expressions, `extends`, constructors, methods/accessors,
  static members, private fields/methods/`#x in obj`, static blocks — to exactly the surface the
  XS pin supports (verify against `xsSyntaxical.c`, not the spec).
- Modules: `import`/`export` in all forms the pin supports (named, default, namespace,
  re-export, `export *`), goal-sensitive parsing (Script vs Module).
- WHOLE-CORPUS PARSE SMOKE: every file in the conformance corpus that the ORACLE compiler
  accepts must parse without panic (agreement of accept/reject where cheap to assert; full
  byte-identity waits for the coder). Files the oracle rejects should be rejected too — classify
  mismatches, don't hide them.

**Local bars:**
- Statement/declaration AST fixtures green; the parse-smoke pass over the corpus completes with
  zero panics and a named tally of accept/reject agreement.
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
  gardener: 7
  claimed_at: 2026-07-06T23:07:15Z
