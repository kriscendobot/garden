## PR #1349 viability check: proceed

**What I did:** I read the PR, its discussion and reviews, and its prerequisite (#1425). Upstream on `endojs/endo` I checked issues #3322 and #3369, the master branch, and any competing PRs. I didn't run clean, panel, fix, CI-wait or un-draft.

**Deciding question:** Is upstream `endojs/endo` #3369 (on Chromium 120–137, `lockdown()` fails because of undeletable `caller`/`arguments` on the codec constructors) still unfixed on upstream master, with no merged fix that replaces this PR, while the maintainer still wants this change? **Answer: yes.**

**Evidence:**
- **PR state:** open, not a draft, not merged. The head is `fe74338e19` and the base is `master-ebc7904`, a frozen snapshot of upstream `endojs/endo` master. The latest bot follow-up (head `fe74338e19`) handles panel review 5675072198.
- **Premise still holds:** upstream issue endojs/endo#3369 is still **OPEN**. Upstream master has neither `packages/ses/src/tame-text-codecs.js` nor `encapsulate-host-constructor.js`. The recent commits on upstream `lockdown.js` (URL permits, Temporal, and others) don't touch the codec `caller`/`arguments` problem. #3322 (merged 2026-07-22), which permitted TextEncoder/TextDecoder, is what exposed the bug, so the need is still there.
- **Not superseded:**
  - The only competing fix upstream is endojs/endo#3371 by naugtur, which permits the bogus `caller`/`arguments` descriptors. It is unmerged, still waiting for review, and has had no activity since 2026-10-05.
  - The related #3372 is closed without merging.
  - This PR already took on naugtur's conditional-taming request (r4229750056): it only encapsulates a constructor whose `caller` or `arguments` is an own, non-configurable property.
- **Maintainer intent is current:**
  - kriskowal asked for "weave and send back to the ferry". The bot re-wove the PR onto `master-ebc7904` and re-staged the ferry.
  - kriskowal had earlier said "Please ferry upstream."
- **Prerequisite:** #1425 is still open, but the PR says that work is already folded into its head (commits `d2818fc044`…`4a3453fa2c`), so it doesn't block the gauntlet.

**Changes:** none, apart from this report.

**Follow-ups:** none from this stage. The gauntlet can start.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (196024 cached reads)
- Output: 2097 tokens
- Cost: $0.5145288
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
