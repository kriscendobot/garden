Clean stage for endojs/endo-but-for-bots PR #1360 is done, with no changes needed. It passed at the idempotence check in step 1.

- **PR:** "docs(designs): capability URL locators — endo store --locator and the https fragment form". It is still a draft and still open. The head is `endojs:design/capability-url-locators` at `fb5bc7ae31`.
- **Coverage pass:** Not needed. The PR only changes one file, `designs/capability-url-locators.md`, so there is no code to test and nothing it could have left unused. I didn't check out the project and didn't push anything.
- **CI:** `ci-wait-merge.sh ... --no-merge` returned rc=0: 28 checks, 0 failed, CI GREEN. Lint, zizmor and the change-detection jobs passed, and the other 22 checks were skipped as not applicable to a docs-only change.
- **Follow-ups:** None from this stage. The gauntlet moves on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164838 cached reads)
- Output: 940 tokens
- Cost: $0.3784796
- Wall-clock: 17s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
