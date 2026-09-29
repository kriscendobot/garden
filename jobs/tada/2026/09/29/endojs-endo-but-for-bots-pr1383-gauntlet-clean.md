Clean stage report for endojs/endo-but-for-bots#1383 (docs(designs): daemon lifecycle idempotency), head `414af7744b69`, draft, base `llm-7ff30af`.

- **Idempotence check:** the PR only touches `designs/README.md` and `designs/daemon-lifecycle-idempotency.md`, which are design docs with no code. There were no touched packages to run a coverage pass on and no dead code to remove, so I didn't create a project checkout or push anything.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1383 --no-merge` returned rc=0, with all 28 checks finished and none failed (CI GREEN). lint, zizmor and the change-detection checks passed. The code jobs were skipped because the change is docs-only.
- **Changes:** none. This stage was a no-op.
- **Follow-ups:** none. The gauntlet can go on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (108165 cached reads)
- Output: 922 tokens
- Cost: $0.338857
- Wall-clock: 14s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
