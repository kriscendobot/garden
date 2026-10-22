---
handed-off: endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane-open-pr
deliverable-complete: false
---
## Completion report: endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane

The change is committed, tested locally and pushed, but the draft PR is not open yet. This host's bot token gets a 403 when it tries to create PRs on endojs, so I posted a successor job on another host to open it.

**What changed** (endojs/endo-but-for-bots)
- New branch `llm-endor-run-unit-tests-ci-lane`, one commit `a2157494c7`: `ci(endo): run endor run input-handling unit tests in build-xsnap`.
- `.github/workflows/ci.yml`: a new `build-xsnap` step, "Test endor run input handling (endo crate)", placed right after the existing endo crate tests. It runs `cargo test --locked -p endo --features ironhorse-engine --lib -- cas_archive:: run_input::` as a block scalar. The comment above it explains why these modules are safe from the `inproc` segfault: they use xsnap's archive types but never run an xsnap machine.
- Base: the frozen `llm-54d3d2a`, which is the current `llm` tip `54d3d2a682` and already existed on origin.

**Verification**
- js-yaml parses the edited workflow, and the new step's `run` value comes out as the intended command string.
- Run locally on aarch64 Linux after building the XS bundles and initializing `c/moddable`: **29 passed, 0 failed, 0.17s**. The job spec says 47; that count includes tests #1531 adds, which aren't on this base.
- GitHub CI has not run, because there is no PR yet.

**PR handoff**
- `ensure-pr.sh` failed with `createPullRequest` 403 ("Resource not accessible by personal access token"). Nothing was opened, so there is no duplicate to clean up.
- I posted **`endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane-open-pr`**, pinned to `requires: host=endolin-garden-ece02cb4`. It contains the exact `ensure-pr.sh` call (using this job's base as the marker) and the full PR body, already reformatted to the repo's PR template.
- The PR body mentions that `fuzz-ironhorse` will run and should be judged on its own (its `bytecode_decoder` timeout is tracked by `ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9`). It also says `endor_run_cli.rs` stays out of CI until the xsnap `txJump`/`c_setjmp` guard lands.

**Follow-ups**
- The successor names the PR URL so the gauntlet gets staged. If endolin is at its token cap, that job could sit unclaimed for a while; that has happened before.
- The real fix is giving the bot token "Pull requests: write" on the endojs org. I added this occurrence to the existing memory note about the 403.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1655022 cached reads)
- Output: 11120 tokens
- Cost: $1.0746444
- Wall-clock: 1883s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
