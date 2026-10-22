---
orchestration-failed: true
---
PR #1391 was not merged: the merge script refused because the PR's base is a snapshot of a still-open parent PR, not the live trunk. It has already alerted the maintainer.

**PR state when checked:** open, still a draft, mergeable and clean. kriskowal's approval ("@kriscendobot conduct", 2026-10-22T06:34Z) is still in effect. The head is `3c39e7d2`.

**Why it can't merge:** the base is `build/sturdyref-shim-first-wins-dbd2b00`, a frozen copy of the head branch of parent PR #774 ("feat(parcel): add the first-wins Parcel shim and open API"). #774 is still open and based on `llm-863a995`. A PR on a snapshot of a branch other than the trunk can never be merged as it stands: the changes would land on the snapshot and on neither live branch.

**What I ran:**
- Created the isolated project checkout for this job. It needed a second attempt with `GARDEN_REPO_GIT_TIMEOUT=900` because the first hit the known 120s checkout limit on oros.
- Ran `ci-wait-merge.sh endojs/endo-but-for-bots 1391` from that checkout. It refused before changing anything: `unfreeze-blocked … reason=nontrunk-frozen-base live=build/sturdyref-shim-first-wins → alerted maintainer, NOT merging` (exit 1).
- I did not take the PR out of draft, push, rebase, or merge.

**Stall reason:** `merge blocked: nontrunk-frozen-base`. The maintainer needs to pick one of:
1. Land parent #774 first, then have a weaver restack #1391 onto `llm`.
2. Retarget #1391 to `llm`.
3. Retarget #1391 to the live `build/sturdyref-shim-first-wins` branch.

Once the base is the live trunk, the approval still stands and a new conduct job can merge it. I did not post that job or any other follow-up.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (362490 cached reads)
- Output: 2683 tokens
- Cost: $0.5405260000000001
- Wall-clock: 676s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
