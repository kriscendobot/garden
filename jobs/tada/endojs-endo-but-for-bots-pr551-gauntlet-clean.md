This PR is design-docs-only (touches `designs/README.md` and `designs/parallel-sync-browser.md`, no code packages), and all CI checks are GREEN at the current head. There is no code for a coverage pass to touch and nothing to clean. This stage is a no-op.

## Report

**Job:** endojs-endo-but-for-bots-pr551-gauntlet-clean (gauntlet CLEAN stage)

**Idempotence check:** `gh pr view` shows PR #551 OPEN (draft), with all status checks SUCCESS at the current head:
- browser-tests ✅
- lint (CI docs-only) ✅
- build (mutual dependency versions) ✅
- zizmor (workflow security audit) ✅
- test (CI docs-only) ✅

**Nature of the change:** Design-only PR (+337/−1) adding `designs/parallel-sync-browser.md` and syncing `designs/README.md`. No source packages are touched, so there is no coverage pass to run and no orphaned dead code to remove.

**Action taken:** None required. CI is already terminal-GREEN and the PR is the correct shape. No follow-up commits pushed to the head branch.

**Follow-ups:** None. Un-drafting remains the maintainer's call per the designer flow.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr551-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91496 cached reads)
- Output: 1029 tokens
- Cost: $0.397463
- Wall-clock: 18s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
