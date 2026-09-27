**Completion report: ironhorse-fuzz-f2f53bb078bc8a4e-repair**

Finding f2f53bb078bc8a4e reproduced at the finding SHA. The input no longer crashes at the standing branch head because the fix was already there. I added regression tests for this exact input, amended the standing PR #1298 and documented the finding there. CI on the PR is fully green.

**Reproduction**
- I rebuilt the 21-byte input from the journal's `input_base64`, and its sha256 matched (`d1ab102b…faef3`).
- I built the fuzz target at `38ca1d1893` in a temporary checkout, using the `c/moddable` submodule from a peer worktree and `nightly-2026-08-15`. The target panicked with `match meter ironhorse=11182604288 pin=2592669696`.
- The input generates the pattern `(((a*a*)?a*)?([a-c0-9](a*a*)?|a?)?){2}[a-c0-9]((a*|a*)?[^a-c0-9]{2}){1,2}` with flag `s`, matched against `"aaaaaaaa"`. It fails to match after 170633 metered steps, so the port's meter is 11182604288, which is larger than `u32::MAX`.

**Cause and fix**
- The pin's figure is exactly the port's value mod 2³². At that SHA the XS oracle (the reference implementation the fuzzer compares against) truncated the meter to 32 bits, so the reported difference was false.
- The fix is commit `c8497fd88`, which widened the oracle's meter fields to 64 bits. It is already on the standing branch, so no code change was needed. The port was always correct.
- This is the same class as findings `cfdc1a28296f23a1`, `f83dc8932cd3b41a` and `5d122a6fc10babd9`.
- At the branch head, the same input runs clean.

**What changed**
- Commit `dbe7d26394` on `kriscendobot:ironhorse-fuzz-findings`, pushed with fetch/rebase/push. It adds:
  - `rust/engine/ironhorse-vm/tests/finding_f2f53bb078bc8a4e_regexp_meter_overflow.rs`: builds without the oracle or submodule. It pins the exact input, the generated pattern, the non-match, the captures and the full 64-bit meter, and asserts the meter is not the truncated 2592669696.
  - The input and pattern files under `ironhorse-vm/tests/fixtures/`.
  - A paired test in `ironhorse-fuzz/src/regexp.rs`, `finding_f2f53bb078bc8a4e_regexp_meter_overflow_agrees`. It checks that these exact bytes still generate this case and that the widened oracle agrees.
- Both tests pass locally, and `cargo +1.88.0 fmt --check` is clean.
- `ensure-pr.sh` found the standing PR endojs/endo-but-for-bots#1298 (draft) and created nothing new. I added a "Finding `f2f53bb078bc8a4e`" section to its body.
- Two other finding jobs pushed commits on top of mine, so the PR head is now `b2fa09cada`. CI on that head: 27 checks passed, 7 skipped, 0 failed.
- I removed the temporary checkout used for the reproduction.

**Follow-ups**
- I did not start a review gauntlet. Under the current rules only the maintainer can start one, with "run the gauntlet #1298". This matches the sibling finding jobs.
- The inbox check at the end was skipped because the journal clone timed out.
- The project worktree still has unrelated uncommitted changes from before this job (`packages/floot/package.json` and two untracked fixture directories). I left them alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-f2f53bb078bc8a4e-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (5 unmetered)
- Input: 68 tokens (2712217 cached reads)
- Output: 16010 tokens
- Cost: $1.5628194000000002 (5 engagement(s) unpriced)
- Wall-clock: 4570s
- Model(s): claude-opus-4-8 ×3, claude-opus-5-5 ×1

<!-- garden-usage-end -->
