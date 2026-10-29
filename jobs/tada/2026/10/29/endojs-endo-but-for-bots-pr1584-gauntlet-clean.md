Clean stage for PR #1584 is a no-op: nothing needed changing, and CI is green.

- **PR state:** #1584 is open and still a draft. The head is `endojs/endo-but-for-bots` branch `build/hardened-text-codecs-shim-xs-smoke`.
- **CI:** all 15 checks passed, including `cover`, `lint`, `test-xs`, `test262` and the `test` jobs on Node 22.x and 24.x (ubuntu and macOS). `ci-wait-merge.sh --no-merge` also returned rc 0.
- **No checkout or coverage pass:** because the head was already green, I didn't create a project checkout, run a coverage pass or look for orphaned dead code, and I pushed nothing.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1584-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 22 tokens (546078 cached reads)
- Output: 3863 tokens
- Cost: $0.7419039
- Wall-clock: 141s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
