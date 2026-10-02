Clean stage for endojs/endo-but-for-bots#1414 is done, with no changes needed. CI is green on the current head `a1a1b8a2`.

- **What the PR is:** "design(daemon): confinement for hosts delegated to a guest and channels a guest reads". It's a draft and open, from head `endojs:design/guest-delegated-host-channel-confinement` to base `llm-afc72ca`.
- **What it changes:** one design document, `designs/daemon-guest-delegated-host-channel-confinement.md` (+315/−0). It touches no code packages, so there was nothing to run a coverage pass on and no dead code to remove. I skipped the project checkout and made no pushes.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 28 checks reached a final state and none failed. Lint, zizmor and the four change-detection jobs passed. The other 22 jobs were skipped, because CI's change detection skips them for a docs-only change.

Follow-ups: none for this stage. The gauntlet moves on to panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (169003 cached reads)
- Output: 1112 tokens
- Cost: $0.39494460000000003
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
