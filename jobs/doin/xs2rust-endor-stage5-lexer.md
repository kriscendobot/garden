---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T21:34:06Z -->

---
model: opus
---
# Stage-5 child 1/7: `endor-compile` crate skeleton + lexer/token port (`xsLexical.c`)

Create the `endor-compile` workspace crate (`#![forbid(unsafe_code)]`, workspace member alongside
`endor-vm`/`endor-oracle`/`endor-262`) and port the XS lexer.

**Scope:**
- Token model mirroring `xsScript.h`'s token enumeration EXACTLY (same token kinds and
  classification — the parser and coder byte-identity downstream depend on seeing exactly what
  XS sees).
- Scanner per `xsLexical.c`: identifiers + keywords (incl. contextual keywords as XS handles
  them, Unicode ID_Start/ID_Continue per XS's tables, `\u` escapes in identifiers), numeric
  literals (decimal/hex/octal/binary, legacy octal + sloppy-mode flags as XS records them,
  numeric separators, BigInt suffix), string literals with the full escape surface, template
  literal parts (head/middle/tail, raw vs cooked), regular-expression literal scanning (raw
  scan + flags; validation stays with `endor-regexp`), punctuators, comments (incl. HTML-like
  comments where XS honors them), line terminators with the ASI-relevant
  crossed-a-newline flag XS tracks.
- Source positions (line/offset) as XS records them — error messages and debugger line tables
  consume these later.
- Thread a deterministic parse-meter hook from the start (a per-token/per-production counter in
  the endor-meter style; constants are endor's own, calibration advisory — see doctrine). Cheap
  now, painful to retrofit.

**Local bars (byte-identity is NOT this child's bar):**
- A token-stream fixture corpus in `endor-compile` unit tests covering the edge surface
  (escapes-in-identifiers, surrogate pairs, template nesting, regexp-vs-divide ambiguity
  fixtures, legacy octal, ASI newline flags), all green.
- `cargo test --workspace -- --test-threads=1` EXIT=0.
- Lexer errors surface as structured errors (no panics on any byte sequence — fuzz will hit this
  in child 7).
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
  host: endolin-garden2-5bcdff64
  gardener: 11
  claimed_at: 2026-07-06T21:34:10Z
