All evidence gathered. Here's my viability assessment.

## Viability report — PR #1310 (endojs/endo-but-for-bots)

**PR state:** OPEN, unmerged, draft. Title: *feat(daemon): guest-native invitation acceptance (EndoGuest.accept)*. Head `856fe3f5`, base `llm-301e2ba` (`301e2ba…`).

**Deciding question:** Does current `llm` still lack a guest-native `EndoGuest.accept`, so #1310's acceptance half remains both needed and un-superseded?
→ **Yes.**

**Evidence:**
- The PR is OPEN and unmerged (`state=OPEN`, `mergedAt=null`); it enters the viability check rather than reporting closed/merged.
- The invite half it builds on — the #1125 successor stack #1304, #1306, #1305 — is all **merged** to `llm` (last, #1305, merged 2026-09-19T15:21:04Z). The PR body correctly claims the invite half shipped and acceptance was unowned.
- The PR's frozen base `llm-301e2ba` (`301e2ba…`) is **identical** to current `llm` HEAD (`compare` reports `ahead=0, behind=0, status=identical`). No newer base history has displaced it; the frozen base is still current.
- Current `llm` `guest.js` has **no `accept` method** (grep finds only invitation-locator comments, no `accept` binding/definition). This PR is the diff that introduces `const accept = async (invitationLocator, correspondentName) => …`, wires `acceptInvitation` from daemon-core, and converges `EndoHost.accept` onto the shared helper. The feature is genuinely unlanded elsewhere.
- Motivating premise still holds: the acceptance half closes the daemon gap for `kriscendobot/minion.town` invitation-only guest onboarding ("Guests must be able to invite and accept"); design PR #1116 remains open, and the invite/accept vocabulary is only half-shipped without this.

**Conclusion:** Neither superseded nor motivationally stale. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (249410 cached reads)
- Output: 3381 tokens
- Cost: $0.6141649999999998
- Wall-clock: 72s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
