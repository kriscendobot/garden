Clean stage: endojs/endo-but-for-bots PR #1410 (draft, "fix: migrate in-repo guest consumers off guest identifiers and locators")

**Result:** This stage was a no-op. The clean work was already done, CI is green, and I pushed nothing.

- **Coverage already on the branch:** the head commit `168700102c`, "test(spaces-util): cover the name-hub guest-detection helpers", is the coverage pass. It adds tests for the new `spaces-util` name-hub helpers in `packages/chat/test/unit/name-hub.test.js`.
- **No dead code found:** I checked the code diff against the PR's base commit (`baseRefOid`).
  - Every new helper has callers outside its definition: `holdsLocators`, `assertHoldsLocators`, `identifyIfHost`, `assertAgentHoldsLocators`, `adoptMessageValue`, `typeForPetName` and `scratchCounter`.
  - The removed helpers (`sameParty`, `isFormReply`, and the old one-argument `typeForPetName` signature) left no callers behind.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1410 --no-merge` returned rc 0: 33 checks, 0 failed, GREEN at head `168700102c`.

Follow-ups: none from this stage. The PR is still a draft, and the next stages are the panel review and un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-designation-consumers-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (270740 cached reads)
- Output: 2078 tokens
- Cost: $0.435996
- Wall-clock: 52s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
