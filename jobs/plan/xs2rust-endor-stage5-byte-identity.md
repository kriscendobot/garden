---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5
priority: normal
posted_by: gardener
posted_at: 2026-07-06T21:33:17Z
---

---
model: opus
---
# Stage-5 child 7/7 (STAGE BAR): full-corpus byte-identity differential harness + parse-metering determinism + parser fuzz target

The stage-5 acceptance child. Children 1–6 landed `endor-compile` end to end; this child proves
the roadmap-row-5 bar.

**Scope:**
1. **Full-corpus byte-identity differential harness.** Extend `endor-262` with a
   compile-differential mode: for EVERY file in the conformance corpus (the test262 subtrees the
   stage-1..4 runners cover — run per-subtree, whole-tree `language/` in one process OOMs), where
   the oracle compiler accepts the file, assert `endor_compile` bytes ==
   `endor_oracle::run(...).bytecode`. Report `total / identical / divergent / oracle-rejected /
   endor-rejected` with NAMED divergence classes and per-file identification. **Stage bar:
   divergent = 0 and accept/reject agreement, over the full corpus.** This is a program KILL
   CRITERION (design § Feasibility Verdict): if some construct class cannot reach byte identity,
   do NOT skip or hide it — report the evidence to the supervisor inbox immediately; the
   supervisor owns the kill-criterion call.
2. **Parse-metering determinism (roadmap bar).** A locked test: identical parse computrons across
   repeated compiles of the same sources on the same build (deterministic per release); the meter
   is endor's own table per the doctrine, oracle compile computrons advisory only.
3. **Parser fuzz target armed (roadmap bar).** In `endor-fuzz`: a structure-aware parser fuzz
   target (no panics, structured errors only) and a differential fuzz target (endor-compile vs
   oracle compiler: accept/reject agreement + byte identity on accepts; an oracle process crash
   is a named outcome, not a harness abort). Arm them (buildable, brief smoke run documented);
   long fuzz campaigns are follow-up work, not this child's budget.
4. **Wire the pipeline seam.** Give the dual-run runner / `endor-vm` embedding an explicit
   compiler-selection seam (oracle-compile vs endor-compile) so later stages can flip the
   default; default stays oracle-compile until the supervisor accepts stage 5.
5. **README evidence block** (`rust/engine/README.md`): the stage-5 numbers, per-subtree, honest
   about anything folded.

**Local bars:** the harness bar above; `cargo test --workspace -- --test-threads=1` EXIT=0.
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
