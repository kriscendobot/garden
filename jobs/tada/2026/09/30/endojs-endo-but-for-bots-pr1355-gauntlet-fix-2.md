# Gauntlet fix round 2: endojs/endo-but-for-bots PR #1355

I applied the round-2 must-fix items, pushed them to the PR head, and CI is green (28 of 28 checks passed, 0 failed; `ci-wait-merge` rc=0).

**Push:** I pushed one follow-up commit to `design/hardened-url-shim-status-reconciliation` with `safe-push-pr-head.sh`, which advanced the head from `1be22af092` to `4f817eb792`. The only file changed is `designs/hardened-url-shim.md`.

**Panel items I fixed:**
- **pedant, must-fix:** I replaced every `§` with a plain markdown link: "the [Design](#design) section" and "(see [Status](#status))" in both Open-questions resolutions. `grep §` now returns nothing.
- **pedant, should-fix:** I rewrote the sentence with the unclear pronoun. It now says that without the pin, `new URL(...).constructor` reaches the powered constructor, "which carries" `createObjectURL`/`revokeObjectURL`.
- **ergonomist:** I checked the `*Taming` comparison against `packages/ses/src/lockdown.js` and corrected it. It now lists the existing exceptions, `overrideTaming` and `evalTaming`. It also drops the forward-looking "should not treat it as precedent" advice, which answers the novice's point that the section drifted from recording what shipped into giving guidance.
- **novice:** the Open question 2 reference is now a link. `%InitialDate%` and `%SharedDate%` are now explained ("how SES already names the powered and tamed `Date` constructors") and point to `permits.js`.
- **decomplector:** the Design section's paragraph that said "This is an open question" now starts with a "Resolved in the Status section" pointer and reads "This was an open question".
- **skeptic:** the Status section now records the Phase 3 audit. I grepped the repo and found the blob methods only in the shim, its tests, its types, and lockdown log text captured by a daemon test. The section also says the optional `new URL(` simplification sweep was not recorded as done. It also says honestly that test-plan item 9 (the XS smoke test) has no URL-specific file: `test:xs` only runs a bare `lockdown()`, which I checked.

**Copyeditor items I declined, with reasons:**
- **Item 1, README entry punctuation:** "added X, completed Y; description" follows the pattern the neighboring README entries already use (for example `patterns-diagnostic-feedback`: "added …, revised …; …"). Changing only this entry would make the list inconsistent.
- **Item 2, slash spacing:** the text already had the spaced form `%InitialDate%` / `%SharedDate%`. That phrase is now reworded as prose anyway.

**Follow-ups:** none from this stage. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (934615 cached reads)
- Output: 5796 tokens
- Cost: $0.765723
- Wall-clock: 874s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
