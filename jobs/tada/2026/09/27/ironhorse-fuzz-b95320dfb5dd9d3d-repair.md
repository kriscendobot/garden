## Completion report: ironhorse-fuzz-b95320dfb5dd9d3d-repair

This is not a port defect, so the engine is unchanged. The regression locks are pushed to the standing PR.

**Reproduction**
- The input checks out: sha256 `89590ab0…7d07`, 5 bytes.
- It reproduces at the base SHA `38ca1d18` using the service's prebuilt `differential_regexp_surface` binary. The target panics with `computrons: oracle=117 ironhorse=118`.
- The generated program is `var m = new RegExp("([0-9]{2}([a-c0-9]{2}[0-9]{2}(\\w{2}0+?a{2})?)){2}[0-9]{2}", "").exec("aac00aa"); m ? m.index : -1`.
- Both engines return `-1`, and Node/V8 does too. The only difference is the computron count.
- On the standing branch `ironhorse-fuzz-findings`, `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` exits 0. The current comparison treats a computron gap with XS as advisory, not a failure. This is the same case as findings `6ca7a76e0bfe3435` and `c6c71d428a37088c`, so no fix is needed. Changing a meter constant would change a hash-pinned meter release record.

**Changes** (commit `e4a4c7fd8a` on `kriscendobot:ironhorse-fuzz-findings`, pushed after a fetch and rebase onto the live tip)
- `rust/engine/ironhorse-vm/tests/finding_b95320dfb5dd9d3d_regexp_surface_meter.rs`: a test that needs no submodule, so CI can run it. It replays the bytecode and symbols the XS oracle produced and checks that the program completes with the result `-1`. It deliberately does not pin the computron count.
- Fixtures in `ironhorse-vm/tests/fixtures/finding-b95320dfb5dd9d3d.*`: the exact input, plus the bytecode, symbols and expected result.
- `ironhorse-fuzz/src/lib.rs`: the test `finding_b95320dfb5dd9d3d_regexp_exec_cost_gap_is_advisory`, which runs the same input through the XS differential and checks there is no divergence.
- Both tests pass locally. I restored the `c/moddable` symlink to an empty directory before committing.

**Pull request**
- `ensure-pr.sh --find-only` adopted the existing standing PR, https://github.com/endojs/endo-but-for-bots/pull/1298 (draft), and did not open a new one.
- The finding and how it was handled are documented in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855338813

**Gauntlet**
- I did not start a new gauntlet because one is already running on #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet`, currently in its `fix-1` stage).
- I sent the `fix-1` job an inbox message that the PR head moved to `e4a4c7fd8a`, so it will fetch and rebase before pushing.

**Follow-ups:** none for this finding. The inbox drain failed at the start of the job because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-b95320dfb5dd9d3d-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (7 unmetered)
- Input: 52 tokens (1707427 cached reads)
- Output: 12185 tokens
- Cost: $1.1370814 (7 engagement(s) unpriced)
- Wall-clock: 1141s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
