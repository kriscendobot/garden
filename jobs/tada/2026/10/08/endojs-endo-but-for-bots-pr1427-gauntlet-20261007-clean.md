Clean stage for endojs/endo-but-for-bots PR #1427 is done: it was a no-op, and I pushed nothing.

- **The change:** the PR edits one line in `.github/workflows/ci.yml`. It corrects the version comment on the `dorny/paths-filter` pin from `# v3` to `# v3.0.3`; the pinned SHA stays the same.
- **Coverage:** the PR touches no packages, so there was nothing to add and no orphaned code to remove. I didn't set up a project checkout.
- **CI:** all 15 checks are green at the current head `1b1ead43c8e1`. That includes lint, build, zizmor, cover, every test, test262, hermes and XS cell, check-action-pins and viable-release. CI was already finished when I checked, so I didn't run the wait script.
- **PR state:** open and not a draft (head `endojs:fix/zizmor-paths-filter-pin-comment`, base `master-6ee3fda`).

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1427-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (112790 cached reads)
- Output: 773 tokens
- Cost: $0.35097
- Wall-clock: 11s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
