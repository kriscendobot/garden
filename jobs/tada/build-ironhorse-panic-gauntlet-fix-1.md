The prior attempt's committed work fully covers this stage; I verified it and confirmed CI is terminal-green.

## Completion report — FIX round 1, PR #1150

**State re-derived on a clean requeue.** A prior claim of this job had already committed and pushed all fix work to the PR head (`kriscendobot:build/ironhorse-panic`), which now sits at `b7fa85172` (3 commits ahead of the original build). The reaper interrupted it during the CI-watch phase, so the actual deliverable was done — only the terminal-green confirmation was outstanding.

**Fixes already on the head (verified by inspecting the two follow-up commits):**
- `09508ae47` — applies the panel's load-bearing must-fix items to `rust/`:
  - **classify fails closed** — `ExecutionOutcome::classify` gives `Halt::Unsupported` an explicit `Panicked` arm and the catch-all now returns `Panicked(other)` instead of `Quiesced`, so a release daemon (where `debug_assert!` compiles out) discards an unrecognized/engine-gap crank rather than committing it. Pinned by `unsupported_engine_gap_never_commits`. (assessor #1 / typist / migrator / engine-realist / corner-prober)
  - **FFI poison drained early** — `ffi_panicked()` is now checked at the bootstrap window and before the crank loop's blocking recv, so a guarded panic during bundle eval no longer leaves the worker registered and hung forever. (assessor #2 / engine-realist)
  - plus should-fix items: CAPTURING save/restore in nested guards, a real-`extern "C"` install test, inproc recovering the caught panic message via exported `panic_payload_message`, `describe_halt` rendering `EngineFault`, the cross-crate rustdoc link → prose, and the abbreviation spell-outs (`msg`→`message`, `loc`→`location`, `prev`→`previous_hook`, `p`→`ffi_panic`).
- `b7fa85172` — `ASYNC-AWAIT-HANDOFF.md` TMPDIR parameterized to `${TMPDIR:-$HOME/tmp}` with the `noexec /tmp` reason stated. (transplanter #1)
- The base-staleness caveat several seats flagged is also resolved: the head is rebased onto current upstream `llm` (`e84a4c83c` is now `HEAD~3`), so the diff is the real ~6-file delta.

**CI:** all 27 checks pass. `ci-wait-merge.sh --no-merge` returned rc 0 (`CI GREEN`, total=27 failed=0).

No further push was needed. Per the fix-stage contract I applied fixes once (already present), confirmed green, and stopped without re-running the panel — the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 194 tokens (9489475 cached reads)
- Output: 58701 tokens
- Cost: $7.732491249999999
- Wall-clock: 1130s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
