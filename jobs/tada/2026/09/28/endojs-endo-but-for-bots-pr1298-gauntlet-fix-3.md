# Gauntlet fix round 3: endojs/endo-but-for-bots PR #1298

All six must-fix items from the round-3 panel review (5335270628) are now on the PR head, and CI is green on the new head `c9accbf5d` (34 checks, 0 failed).

**Already applied before this job:** When I checked the PR, the head had moved past the reviewed head `a60453be`. An earlier push had rewritten the history at 07:49, and commits at 08:06 made most of the fixes:
- **Byte identity:** `results_agree` now requires byte identity when the completion is not a Number, and `as_ecma_number` is deleted. There is a regression test for the String case (commit `8686311f3`).
- **Fixtures tied to inputs:** each finding test now asserts its input's cited sha256. A new test, `ironhorse-fuzz/tests/vm_finding_fixtures.rs`, scans the fixtures directory, regenerates the program, regexp-case, bytecode and symbols fixtures from each input, and requires byte identity (commits `c0c8ea377` and `b60c602f9`).
- **Pasted generator grammars:** the VM finding tests now read pinned `program.txt` / `regexp-case.txt` fixtures instead of carrying their own copy of the grammar. The only two files that still do are on the base branch, not in this PR.
- **Stale docs:** `rust/engine/README.md`, `rust/engine/ARCHITECTURE.md` and `ironhorse-text/src/lib.rs` now describe Number spelling as well as CESU-8. The PR's own test comments name the code symbol instead of "the standing findings branch" (commit `c634b1e06`).
- **Code points:** the PR adds no `…`, `×` or `−` characters.
- **Commit grouping:** the earlier `style(...)` commits and the two fix-then-correction pairs had already been folded.

**What I did:**
- Newer fuzz commits had brought back two correction commits: `c9c0d95d9`, a rustfmt `style` commit, and `b60c602f9`, which fixed up the `fd8517d5f3071227` and `e773681b6d831dc1` locks after they landed.
- I folded each into the commit it corrects and dropped both, so the change to the file contents is empty.
- I pushed with `safe-push-pr-head.sh --mode rewrite`, which moved the head from `7fdaff6d0` to `c9accbf5d`.
- The PR stays draft.

**Left as is:**
- Six older VM finding tests from the base branch still cite an input sha256 without asserting it, and one of them, `finding_67a52af412f03a7b`, still mentions "the standing findings branch". They are outside this PR's diff, so I didn't touch them.
- I didn't act on the comment-only suggestions, such as recording the value kind on the IronHorse side and removing the duplicated one-line wrappers.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 248 tokens (17008731 cached reads)
- Output: 70816 tokens
- Cost: $10.977369299999996
- Wall-clock: 7296s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
