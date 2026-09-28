I added a regression test for finding `ccb76a40851925f9` to the standing branch and documented it on PR #1298. No engine fix was needed: this was a false divergence caused by the old XS reference ("oracle"), and the fix for it is already on the branch. I did not start the gauntlet.

**Starting point:** a prior attempt had left nothing committed. The branch had no commits for `ccb76a40851925f9`, PR #1298 had no comments about it, and no PR existed under this job's marker.

**Reproduction**
- I decoded the input from the journal's `input_base64`; its sha256 matched `8876046f…270247c` (5 bytes).
- At the finding SHA `38ca1d18` it **reproduces** (exit 77) with `match meter ironhorse=5152440320 pin=857473024`.
- The two engines agree on the match result and capture groups; only the step meter differs. The input generates a 922-byte regexp with nested backreferences, flag `i`. It matches after 78620 metered steps, so the meter reaches 5152440320, which is over the 32-bit maximum.
- The pinned XS value is exactly the port's value mod 2³²: at that SHA the oracle stored the meter in a 32-bit field and it wrapped.
- At the head of `ironhorse-fuzz-findings` the target exits 0 on this input.

**Fix:** the oracle fix `c8497fd88`, which widens the meter fields to 64 bits, is already on the branch. The engine port was already correct. This is the same kind of finding as `f2f53bb078bc8a4e`, `bf6cfbd74a7487fc` and `cfdc1a28296f23a1`.

**What changed** (commit `d65c656754`, pushed to `kriscendobot:ironhorse-fuzz-findings`; the fetch/rebase/push went through on the first try):
- **`ironhorse-vm/tests/finding_ccb76a40851925f9_regexp_meter_overflow.rs`:** runs without the submodule. It checks the exact input size, the generated pattern, the match and capture groups, and the full 64-bit meter, and asserts the meter is not the old wrapped value.
- **`ironhorse-fuzz/src/regexp.rs::finding_ccb76a40851925f9_regexp_meter_overflow_agrees`:** checks that the exact input still generates this case and that the fixed oracle agrees with the port.
- **Fixtures:** `finding-ccb76a40851925f9.input.bin` (the committed file's sha256 matches) and `.pattern.txt`.
- Both tests pass locally.

**PR:** `ensure-pr.sh --find-only` found the existing standing PR #1298 (draft), so I opened no new one. The explanation is posted at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864259677.

**Follow-ups**
- **Gauntlet not run:** the job asked for it, but under the manual-trigger rule only the maintainer starts gauntlets. Earlier fuzz-finding jobs on this PR made the same call. The last panel review predates the current head, so #1298 needs a maintainer "run the gauntlet".
- **Checkout cleanup:** I reverted the stray `packages/floot/package.json` change that the cached dependency install left in the project checkout. I removed the temporary checkout at the finding SHA.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ccb76a40851925f9-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (4 unmetered)
- Input: 44 tokens (1544411 cached reads)
- Output: 12008 tokens
- Cost: $1.1668581999999998 (4 engagement(s) unpriced)
- Wall-clock: 648s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×2

<!-- garden-usage-end -->
