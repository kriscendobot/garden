Diagnosed the `test-xs` failure as an intended baseline advance: Ironhorse now exposes coherent iterator prototype chains, method metadata, and Map/Set iterator tags.

Local targeted Hardened262 reporting on `4a9fa13a6e` confirmed all six strict/sloppy cases pass. Commit `88da905fe82c` updated the four Ironhorse baseline files while work was in progress, matching the reproduced result exactly, so no duplicate push was needed.

CI is green on current head `3938b6d165f`: 27/27 checks passed, including `test-xs` at https://github.com/endojs/endo-but-for-bots/actions/runs/33476090185/job/99755601485.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1103-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1423s

<!-- garden-usage-end -->
