---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T22:41:43Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1658 - MERGE-NOW stands, blocked on base test-xs (Node 26), parked behind #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1658
dependabotany-active-pr: 1658
blocker: endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646

- **PR #1658** (preact 10.29.8 → 11.1.1): verdict MERGE-NOW, not terminal. The maturity floor passed 2026-11-07T05:01:22Z, the moved set is benign (only preact), and there are no advisories.
- **Head:** 45e7064d4f5, which includes the preact-container isValidElement migration.
- **Sole red:** `test-xs`, hardened262 ThrowTypeError intrinsic-metadata `sesNode/module` pass→fail. This is pre-existing on llm 48d6f3e08b (run 41370492445): `.node-version` `lts/*` now resolves to Node 26.
- **Fix:** https://github.com/endojs/endo-but-for-bots/pull/1646 (pin Node 24). It is a draft and its gauntlet halted on a bwrap flake.
- **Next:** blocked plan job endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646, promoted by unblock.sh when #1646 merges or closes. It rebases, confirms test-xs is green, and conducts with ci-wait-merge.sh --dependabot-auto-merge.
