**Viability: proceed.** PR #1349 has not been overtaken, so the gauntlet may begin.

Deciding question: Is lockdown's failure on the undeletable Chromium 120–137 codec `caller`/`arguments` properties (endojs/endo#3369) still unfixed upstream and in the fork, with no other implementation of this PR's encapsulation landed or preferred?

Answer: yes. The need still holds and nothing has replaced the PR.

Evidence:
- **PR state:** #1349 is OPEN, not merged and not draft. Head is `2262b4bafa`, base is the frozen `master-ebc7904`, and it was last updated 2026-10-29T00:23Z.
- **The bug is still open upstream:** endojs/endo#3369 ("lockdown() fails on undeletable caller/arguments, reachable since TextEncoder was permitted in 2.3.0") is open. The issue itself withdraws the fix it first proposed, a descriptor check, because that check can't distinguish these WebIDL properties from a sloppy function's live ones.
- **The rival upstream fix is stalled:** endojs/endo#3371 ("Permit bogus caller and arguments…") is open with no reviews and takes that withdrawn approach. It does not replace this PR's encapsulation design.
- **Not landed anywhere:** `packages/ses/src/tame-text-codecs.js` and `packages/ses/src/encapsulate-host-constructor.js` exist on none of endojs/endo master, endo-but-for-bots `llm`, or endo-but-for-bots `master`.
- **The premise still applies:** endojs/endo#3322, which permitted TextEncoder/TextDecoder as universal intrinsics, merged on 2026-07-22. That is the change that exposed the Chromium failure this PR handles.
- **The maintainer wants it:** kriskowal reviewed on 2026-10-27, "@kriscendobot Please ferry upstream." Recent panel rounds pass or have only comment-level findings.
- **The overlap is planned, not a replacement:** endojs/endo-but-for-bots#1425 makes the same XS compartment-intrinsics change and is still an open draft. The PR body already says whichever lands first, the other drops the duplicate.

Follow-up the next stages should know about: a question to the maintainer is still unanswered (comment of 2026-10-28T20:19Z). The dependency-check workflow is red on `ubuntu-latest` because Graphviz there lacks `tred`. The Ubuntu 24.04 runner pin that fixes it was split out into endojs/endo-but-for-bots#1582, as requested. kriskowal needs to say whether the ferry should treat that red check as expected, or whether #1582 should land in the frozen base first. That red check is not a reason to stop the gauntlet.

No code, PR, or job changes were made; this stage only gathered evidence.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261029-d8b86e15-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (255186 cached reads)
- Output: 2585 tokens
- Cost: $0.5444332
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
