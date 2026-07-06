---
role: fixer
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T18:49:14Z -->

---
model: opus
---
# Stage-4b child 1/5 (fixer): deterministic infinite loop in the bytecode-decoder fuzz test wedges `cargo test --workspace`

**Program context (read first).** You are one serial child of the `xs2rust-endor-build-stage4b`
orchestration (Hardened JavaScript) in the supervised program `port-xs-to-rust-memory-safe-engine`.
Repo `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor`, base `llm`. **Keep the PR
DRAFT.** Get your ISOLATED worktree with
`<garden-root>/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`
(never share a tree; concurrent pushes race safely at the git-push CAS — rebase and retry).
The engine lives in `rust/engine/` (independent cargo workspace; `cargo` at `$HOME/.cargo/bin`).
Read `rust/engine/README.md` first: oracle pin `48ee02d8cfe0` population fallbacks (the empty-gitlink
footgun — `git init` in `c/moddable` first, then fetch from a sibling
`<garden-root>/scratch/project-wt-*/c/moddable`), harness invocation, evidence blocks. Read the design
`designs/xs2rust-endor-engine.md` §§ Value and heap model, Metering, Hardened JavaScript and
Compartment, Staged Roadmap, and the GC-roots contract note.

**Why you exist (the supervisor's diagnosis, 2026-07-06).** At branch tip `e08b83ac3`,
`cargo test --workspace` NO LONGER COMPLETES: the endor-fuzz suite test
`decoder_never_panics_on_arbitrary_bytes` (rust/engine/endor-fuzz/src/lib.rs, ~L2515) enters a
deterministic infinite loop — two independent runs each burned 2h+ of CPU at 99.9% on that single
test before being killed. The test is fully deterministic (LCG-seeded, seeds `0u32..2000`, inputs
<= 40 bytes, plus two fixed malformed cases), so some specific small byte string drives a decode
path that never terminates. This is a REAL trophy (an unvalidated operand/branch in a decode arm
= a malformed-bytecode hang, exactly what the target exists to catch) AND an in-tree regression:
the same suite passed inside `cargo test --workspace` **128/0** on s8's fresh-checkout acceptance
of `0b991a8b4` (PR #600 issuecomment-4888883354). The regression window is the five stage-4a
commits since: accessors-attributes, classes, generators, the promise keystone `49e27a89b`, and
modules `e08b83ac3` — whichever added or touched a bytecode decode arm. This wedge is what killed
the stage-4a modules child (its bar requires workspace-green; its verification run could never
finish inside the 2400s handler), so every later child inherits the wedge until you fix it.

**Budget discipline (two stage-4a children died to this — read it).** Your handler is hard-killed
at 2400s wall-clock, builds included. Land and PUSH the first green slice EARLY, commit
incrementally, and never hold work uncommitted through a second build cycle. If you are resumed
with too little time for one build cycle, land a documentation handoff and report the fold to
inbox `port-xs-to-rust-memory-safe-engine-s10`.

## Scope

1. **Reproduce cheaply**: run ONLY the fuzz suite (`cargo test -p endor-fuzz`) under `timeout`;
   then isolate the offending input by splitting the seed range / running the fixed malformed
   cases first (the test body is a plain loop — a scratch copy that prints the seed before each
   case finds it in one run). Warm-cache hint: you may copy
   `<garden-root>/scratch/project-wt-xs2rust-endor-stage4-modules-5cd7f36a/rust/engine/target`
   into your own worktree to skip the cold build (that job is retired; its tree is at
   `e08b83ac3`).
2. **Fix the decoder**: the decoder must be TOTAL — every input, however malformed, terminates
   with a decode error or a decoded stream. Find the non-terminating decode arm (bisect the five
   stage-4a commits if the offending input alone does not localize it) and fix the loop
   (validate the operand/length/branch before consuming it, as the existing truncated-NUMBER and
   backward-branch cases do).
3. **Lock it**: add the offending byte string as a named regression case in the same test, AND
   make the harness wedge-proof — give `decoder_is_panic_free` (or the test loop) a
   fuel/step bound so ANY future decode non-termination fails loudly in milliseconds instead of
   hanging the whole workspace bar. A bounded failure is a finding; a hang is an outage.
4. **Verify the bar is tractable again**: a FULL `cargo test --workspace -- --test-threads=1`
   run that COMPLETES green; record its wall-clock in the README evidence block (the stage-4b
   children behind you need to know the bar fits their budget).

## Acceptance focus

Full workspace suite completes green with the fix; the offending input is a named regression
case; the decode loop has a fuel bound; `#![forbid(unsafe_code)]` intact; commit with explicit
pathspecs, push to `origin/xs2rust-endor` (rebase-CAS loop), README evidence block updated with
the trophy (input bytes, root cause, commit that introduced it) and the workspace-suite
wall-clock. If the root cause turns out NOT to be a decoder loop (e.g. an environment issue),
report exactly what you measured to inbox `port-xs-to-rust-memory-safe-engine-s10` — never leave
the wedge undiagnosed.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  claimed_at: 2026-07-06T18:49:18Z
