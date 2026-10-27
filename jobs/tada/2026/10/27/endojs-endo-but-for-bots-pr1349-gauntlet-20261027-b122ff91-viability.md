Viability report: endojs/endo-but-for-bots PR #1349, "fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors"

**Deciding question:** Is upstream `endojs/endo` still missing a fix for lockdown failing on undeletable `caller`/`arguments` on host `TextEncoder`/`TextDecoder` (endojs/endo#3369), with no newer fix or design that replaces this PR's approach of swapping in SES-owned constructors? **Yes.**

**Evidence:**
- **PR state:** open, unmerged and not a draft. Head is `b122ff91ef`, base is `master-ebc7904`, a frozen snapshot of upstream `endojs/endo` `master` taken today. The weave left only this PR's 23 files and the bot reported 16/16 CI checks green on that head.
- **Motivating issue still open:** endojs/endo#3369, "lockdown() fails on undeletable caller/arguments, reachable since TextEncoder was permitted in 2.3.0", is still open.
  - A reviewer there, mhofman, rejected tolerating the properties ("not acceptable from an ocap pov") and said the repair "would have to replace the class altogether". That is what this PR does.
  - Another reviewer, naugtur, called it a MetaMask release blocker. They tested this PR's fix, it worked, and they proposed pulling it into LavaMoat.
- **Competing upstream fixes have not displaced it:**
  - endojs/endo#3372 (a narrow tolerance in `cauterizeProperty`) was closed without merging on 2026-10-15.
  - endojs/endo#3371 (a permits tweak) is still open, has had no activity since 2026-10-05, and still needs review.
  - Upstream `master`'s `packages/ses/src` contains none of this PR's files (`tame-text-codecs.js`, `encapsulate-host-constructor.js`).
- **What the weave absorbed:** upstream landed #3322, which permits the codecs as universal intrinsics. That PR is a prerequisite, not a replacement. It is what made the bug reachable, and the weave already folded it in.
- **The maintainer still wants it:** kriskowal asked today, 2026-10-27, to "weave and send back to the ferry", after an earlier "Please ferry upstream". The weave is done and the ferry directive is staged again.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-b122ff91-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (388610 cached reads)
- Output: 2772 tokens
- Cost: $0.59133
- Wall-clock: 71s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
