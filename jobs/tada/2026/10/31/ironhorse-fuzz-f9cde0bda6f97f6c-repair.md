I fixed the hang: it was in the fuzz test harness, not in Ironhorse's engine. The fix and the regression locks are pushed to the standing findings PR endojs/endo-but-for-bots#1298 as commit `168f38e5e4`. I didn't wait for #1298's CI run on the new commit.

**Which engine hangs:** both, and only inside the `differential_regexp` harness. The input turns into a 415-byte pattern of chained `.*` atoms with a lookbehind and a lookahead, flag `i`, run against `"cccccccc"`. The pattern ends in a `0` that the subject doesn't contain, so every way of splitting the subject among the `.*` atoms gets tried. I ran each engine alone: Ironhorse's matcher and the XS oracle each ran past 180 s and were killed.
- The harness called Ironhorse's `match_regexp`, which has no budget, and the XS oracle, which has no meter limit.
- Ironhorse's normal `RegExp` path already stops this. It uses `match_regexp_budgeted` and the computron meter, so there was no engine defect to fix.

**The fix** (`ironhorse-fuzz/src/regexp.rs`):
- The harness now runs Ironhorse first, capped at `MAX_DIFFERENTIAL_MATCH_STEPS` = 2^25 matcher steps. If a case uses up the cap, it is skipped before XS runs. The two engines count steps identically, so XS would run at least as long.
- Matches longer than 65,536 steps, the size behind the earlier meter-overflow findings, still reach XS.
- I added `differential_check_regexp_within(case, max_steps)`. Two existing locked findings take longer than the cap (`13b68e2edb67861a` at about 92M steps and `79f0475dd0440b2d` at about 464M), so their tests now use it with no limit. Their checks are just as strict as before.

**Regression locks:**
- The exact 664-byte input (sha256 `f9cde0bd…`) and the generated pattern are saved as fixtures under `ironhorse-vm/tests/fixtures/`.
- A test in the fuzz crate checks that the input still produces that pattern, that the budgeted match hits the cap without matching, and that the harness skips the case.
- A test in `ironhorse-vm` that doesn't need the Moddable source checks that Ironhorse's meter stops the same match close to its limit.

**Verification:**
- On the findings input with `-timeout=60`, the fuzz target now finishes in about 2.8 s instead of timing out.
- A 60-second fuzzing run did about 365k executions with no findings.
- All tests in `ironhorse-fuzz` pass (release build, 105 unit tests plus the other test files), and the new `ironhorse-vm` test passes.
- `cargo fmt` is clean, and clippy shows no new warnings.

**Still open:**
- The fix reaches `llm` only when #1298 merges. Until then, other PRs' fuzz jobs can still time out on similar patterns.
- A budget only on the XS side (setting a meter limit in the XS oracle code) would let XS-only hangs be locked separately. Nothing needs that now.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `168f38e5e42e1b5d1e1e83ef8d7a963bfec77b08`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-f9cde0bda6f97f6c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3196821 cached reads)
- Output: 25157 tokens
- Cost: $1.9699762000000003
- Wall-clock: 889s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
