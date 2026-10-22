---
handed-off: ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9-open-pr
deliverable-complete: false
---
## Completion report: ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9

The fuzz timeout is a real interpreter defect, not a harness artifact. I fixed it and pushed the fix with a regression test, but the draft PR is not open yet: this host's bot PAT gets a 403 when creating PRs on endojs. A successor job pinned to endolin owns opening it.

**Reproduction.** I took the 198-byte input from the run's artifact (`ironhorse-fuzz-tripwire-artifacts`), not from the log. This host has no `cargo fuzz`, so I called `disassemble` and `run_program_bounded` directly with the harness's 2M-dispatch limit. Time grew quadratically with the dispatch count:

| Dispatches | Time |
| --- | --- |
| 10,000 | 21 ms |
| 100,000 | 1.86 s |
| 1,000,000 | not done after 120 s |

**Cause.** The input loops through a catch handler. Each round it does 24 `store_1` into `this`, which is the global object. `store` appends to a property chain by walking it from the head every time. XS does the same walk (`xsRun.c:2120` at the pinned 23b4d6b0), but compiled code stores each value once into a fresh closure environment, so the chain stays short. Here one chain grows every round and every store walks all of it, which is where nearly all the time went.

**Fix** (`fix/ironhorse-store-chain-walk-bound`, commit a61dffa38, based on the existing frozen `llm-54d3d2a`):
- **Scope:** the cap applies only under `run_bounded`, like the existing `BOUNDED_RUN_SLOT_CEILING` guard. Ordinary runs keep XS's walk, so execution and metering are unchanged.
- **Code:** a new `store_chain_tail` helper in `ironhorse-vm/src/interp/environment.rs` stops the walk after 4096 links (`BOUNDED_RUN_STORE_CHAIN_CEILING`). `store` and `store_arrow` both halt with `Halt::StepLimit` when it does.
- **Result:** the reproducer now halts after 12,941 dispatches in under 0.1 s.
- **Regression test:** the repo README says a finding's regression is a Rust test, not a corpus entry. So the "regression seed" is `ironhorse-vm/tests/finding_1015c4e9cf8a361f_store_chain_walk.rs`, which pins the full input. With the fix reverted, the test hung until I killed it at 90 s.

**Checks:**
- `cargo test --release -p ironhorse-vm` and `-p ironhorse-snapshot` pass.
- fmt and clippy on 1.88.0 with `-D warnings` (the CI form) are clean.
- The `ironhorse-fuzz` tests were not run locally because they need the `c/moddable` submodule; CI covers them.

**PR handoff.** `ensure-pr.sh` failed on `createPullRequest` with a 403, the known limit for this host. I posted job `ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9-open-pr` with `requires: host=endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` under this job's base with the PR body embedded (it follows the repo's PR template), and it is on the board in `todo/`. I also saved a memory note: on oros, `cargo` is not a rustup shim, so `cargo fmt`, `cargo clippy` and `cargo +1.88.0` fail until the rustup toolchain's `bin` is put on PATH.

**Follow-up (not done here).** Ironhorse, like XS, never checks that a `store` target is a closure environment, so bad bytecode can still append closure slots to an ordinary object such as the global. A check would need a marker on closure environments, which `new_environment` doesn't set today. This is recorded in the PR body.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (7927657 cached reads)
- Output: 41200 tokens
- Cost: $3.6072434000000007
- Wall-clock: 1843s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
