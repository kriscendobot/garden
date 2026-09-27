I found nothing left to do: an earlier attempt already finished this job and pushed it. I only checked; I didn't change or push anything this time.

**What's already on the standing PR** (endojs/endo-but-for-bots#1298, open draft, mergeable, live head `02c92f512f`):
- **Cause:** the 5-byte input turns into a program whose `RegExp.source` result is 1,037 bytes long. The old XS comparison engine had a 1,024-byte result buffer and returned only the first 1,023 bytes, while IronHorse correctly returned the whole value. The fuzz harness read that mismatch as a disagreement and panicked. IronHorse itself was never wrong.
- **Fix:** commit `7fae4aea2f` was already on the branch before this finding. It enlarged the buffer and now reports the true length plus a truncation flag, so an overflow can't pass for an engine disagreement. This finding needed no further code change.
- **Regression tests:** commit `b2fa09cada` adds two:
  - a Rust test in `ironhorse-vm` that replays the exact input from saved bytecode and symbols. It needs neither the comparison engine nor the submodule, and it checks the full 1,037-byte result with no panic.
  - an exact-input comparison test in `ironhorse-fuzz`.

  Both are in the live head.
- **Evidence the earlier attempt reported:** it reproduced the crash at `38ca1d18` with `nightly-2026-08-15`, and the input's sha256 matched. Restoring the old 1,024-byte limit made the new test fail; the fix makes it pass. The one-shot `cargo fuzz` replay exits 0.
- **Write-up:** the PR comment "Fuzz finding `af5b4a677483eac3`" (posted 2026-09-27 13:49Z) covers the case and its solution.
- **Gauntlet:** the PR's existing gauntlet is running and is now on fix round 3 (head `02c92f512f`). I didn't post a duplicate.

**Follow-ups:**
- The earlier attempt couldn't finish the full local JS test run (it stalled on memory limits), so GitHub CI on the PR is the full check. I didn't check its current result.
- The reused project checkout (`scratch/project-wt-ironhor-f00a888c9908-dc6c292b`) holds a commit that was never pushed, `a4bdda364f` ("align differential number result policy"), plus an uncommitted edit to `packages/floot/package.json`. Neither is about this finding. It looks like leftover gauntlet-fix work, probably already covered by the pushed rounds 2–3, but I didn't compare it. I left both untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-af5b4a677483eac3-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 3 host(s) (7 unmetered)
- Input: 14 tokens (371832 cached reads)
- Output: 3240 tokens
- Cost: $0.6319504 (7 engagement(s) unpriced)
- Wall-clock: 15330s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
