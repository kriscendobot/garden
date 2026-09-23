Fixed finding `1898f584e9bf841a` in commit `dbdddec76`, now included in standing PR [#1088](https://github.com/endojs/endo-but-for-bots/pull/1088).

- Corrected erroneous metering when `RegExp.source` reuses an unescaped source string.
- Added an exact-byte, submodule-free regression test and frozen fixtures.
- Verified pre-fix failure, post-fix pinned fuzz reproduction, regression sensitivity, VM/snapshot suites, and repository probes.
- Documented the finding in the [PR comment](https://github.com/endojs/endo-but-for-bots/pull/1088#issuecomment-5473044944).
- A concurrent finding advanced the shared branch after this commit. The active staged gauntlet `ironhorse-fuzz-2276f4edebdcb3bb-repair-gauntlet` owns current-tip CI, panel review, and undrafting.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-1898f584e9bf841a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2588s

<!-- garden-usage-end -->
