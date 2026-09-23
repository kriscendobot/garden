All four jobs are correctly gated. The setup is complete and pushed to `origin/journal2`. My cwd worktree has no main2 (garden-repo) changes to commit — this job's deliverable is journal board state, already pushed by `post-plan.sh`. Done.

---

**Completion report — `xs2rust-endor-strings-utf16-replace-cesu8`**

**What this was.** A deferred plan (auto-promoted by the idle-board foreman) to swap the `xs2rust-endor` port's internal JS string representation from chunk-backed **CESU-8** to **UTF-16** and delete the O(1)-index machinery. Nature: designer-first, then staged build. The port is real: `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600, engine at `rust/engine/`, design `designs/xs2rust-endor-engine.md`, driven by the Fable supervisor chain `port-xs-to-rust-memory-safe-engine-s7`.

**What I found (the reason I did not swap now).**
- The build would collide head-on with **in-flight stage-3b work**: children 8 (xsre-core), 9 (xsre-integration = RegExp + String methods), 7 (promises, alive), and 5 (object-statics-intern, the string→id intern table) are still landing String code on the same PR #600 branch. The plan's own gate says "sequence against the in-flight Stage 3 build."
- The program owner **`s7` is parked** `blocked_on: xs2rust-endor-build-stage3b` (not yet awake); it owns program sequencing and binding-design approval.
- The plan's ask to "update the metering section to accuracy-over-parity" is **already done** (design doc revised 2026-07-04, maintainer directive: oracle governs results only, computrons advisory, meter is endor's own frozen release-versioned cost table). The remaining design delta is only the string-*representation* paragraph (currently "Strings remain CESU-8 in chunks").

**What I did.** Translated the plan into an executable, correctly-sequenced orchestration rather than firing a colliding swap:
- Parked three orchestrated children (`orchestrated_by: xs2rust-endor-strings-utf16`), each with a full, fact-grounded brief:
  - `…-strings-utf16-design` (Fable) — revise the design doc's string-rep section to UTF-16 + re-base string-op cost weights (do **not** re-litigate the already-correct doctrine).
  - `…-strings-utf16-build` (Opus) — swap endor-vm storage to UTF-16; delete cursor/ASCII-BMP/side-table hacks; update literals/`fxConcatString`/comparison/`typeof`/rendering/snapshot atoms/FFI boundary; re-base + freeze string meter weights.
  - `…-strings-utf16-test` (Opus) — result parity via the differential oracle; add surrogate-pair/`codePointAt`/index-heavy/lone-surrogate cases; update meter expectations to recalibrated costs (never back-fit to CESU-8 or oracle computrons).
- Posted a **blocked "arm" job** `…-strings-utf16-arm` (`blocked_on: port-xs-to-rust-memory-safe-engine-s7`) that, on wake, records the serial halt-on-failure orchestration over the three children. This defers the whole revisit until the supervisor's current stage lands (which is after stage-3b + its stage-3 reproduction), so the swap cannot corrupt in-flight String work and the supervisor keeps sequencing authority.

All four jobs verified present in `origin/journal2` with correct frontmatter; my own job is in `jobs/doin/`. No garden `main2` changes were needed.

**Follow-ups / handoff.**
- When `s7` reaches `tada/`, the unblock watcher promotes the arm job; a gardener records the orchestration and design→build→test runs in order.
- The supervisor may prefer to fold this revisit into a later roadmap stage — the arm job's body says it may cancel/re-sequence the orchestration.
- Meter re-basing should coordinate with the live `xs2rust-endor-meter-calibration-stage-c1` and the `…-meter-opcode-cost-instrumentation` plan.
