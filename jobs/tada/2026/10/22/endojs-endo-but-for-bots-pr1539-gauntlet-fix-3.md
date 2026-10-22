Fix round 3 is done for endojs/endo-but-for-bots#1539: I fixed the one finding from the pre-pass, pushed it, and CI came back green.

- **Finding:** the `typist-friendly-code-points` check failed on `designs/fs-interface-consolidation.md:320`, which contained a U+2192 arrow (`→`).
- **Why it was still there:** the previous fix commit, `7092e7adf` ("type ASCII arrows in consolidation design"), changed only two of the arrows in the file and missed line 320.
- **Fix:** I replaced every remaining `→` in that file with `->`, on lines 134, 320, 350 and 375–382. No `→` is left in the file. This is the same whole-file rewrite the check's own `--fix` mode does.
- **Push:** committed as `8d46bcca0` ("docs(fs): type ASCII arrows throughout consolidation design") and pushed to `kriscendobot/endo-but-for-bots:docs/fs-interface-consolidation-status` with `safe-push-pr-head.sh --mode advance`, moving the branch forward from `7092e7adf`.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1539 --no-merge` returned 0: all 30 checks passed, none failed.

Nothing else to follow up here; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1539-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (808683 cached reads)
- Output: 3933 tokens
- Cost: $0.6117005999999999
- Wall-clock: 960s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
