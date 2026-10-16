Clean stage for endojs/endo-but-for-bots#1484 ("design: HTTPS fragment locators replacing endo://"): nothing needed changing, and CI is green.

- **PR shape:** It's an open draft. The head branch is `endojs:design/https-fragment-locators` and the pinned base is `llm-61cd656`.
- **Changes:** It touches two docs files only: `designs/https-fragment-locators.md` (+667) and `designs/README.md` (+7).
- **Coverage pass:** There was nothing to run it on, because the PR touches no code packages and so leaves no dead code behind. I didn't create a project checkout and didn't push anything.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All 30 checks finished with none failing: 7 passed (lint, zizmor and the change detectors) and the rest were skipped by path filters, as expected for a docs-only diff.

Follow-ups: none from this stage; the gauntlet moves on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1484-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116790 cached reads)
- Output: 880 tokens
- Cost: $0.36720600000000003
- Wall-clock: 15s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
