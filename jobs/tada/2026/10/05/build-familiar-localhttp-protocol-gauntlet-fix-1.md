# Gauntlet FIX round 1: endojs/endo-but-for-bots#1426

I applied the panel's round-1 items in one follow-up commit, `5f9d47573d`, on `feat/familiar-security-warning-banner` (it fast-forwards from `d9acaed022` and was pushed with `safe-push-pr-head.sh`). CI is green: all 32 checks passed and `ci-wait-merge --no-merge` returned 0. One item was not done: the coverage-auditor asked for unit tests of the two `deliverSecurityWarnings` call sites in `electron-main.js`, and they are still not tested.

**What changed**
- **locksmith:** warnings now go only to the Chat page. `deliverSecurityWarnings` checks the page URL on each load and sends only to a `file:` page or the loopback (`127.0.0.1`) Vite dev server. A `localhttp:` weblet loaded into the same window no longer receives them. The new check is `isChatPageUrl` in `packages/familiar/src/security-warnings.js`.
- **integrator:**
  - The banner's z-index went from 9998 to 10000, so it now shows above the reconnect overlay (9999).
  - `securityWarningBanner.mount()` is now called after the Application Error view replaces the page body. That was the one replacement site still missing it.
- **corner-prober:**
  - The banner now remembers every warning it has shown. A dismissal is no longer undone when an empty payload arrives between two sends of the same warnings.
  - New test `packages/familiar/test/preload-security-warnings.test.js` runs `preload.mjs` against a stand-in for `electron`. It covers a subscriber that registers after a warning arrived, one that registers before any warning, and several subscribers getting later warnings after the replay.
- **typist:** the banner test now uses a top-of-file `/** @import { ExecutionContext } from 'ava' */`.
- **changeset-auditor / releaser:** added `.changeset/familiar-security-warning-banner.md` (`@endo/chat` minor, `@endo/familiar` patch). The packager seat said no changeset was needed because both packages are private, but the repo's config versions private packages too, so I added one.
- **pruner:** removed the comment in `main.js` that restated the code. In the PR body I replaced the per-file bullets and the test counts with a short prose description.
- **assessor:** updated the design doc's out-of-date code sample to show the replaying preload and `deliverSecurityWarnings`.
- I added tests for the Chat-page URL check and the banner's position above the overlay. Locally, all 10 familiar tests and 9 chat-banner tests pass, `tsc` is clean for both packages, and eslint shows only warnings that were already there.

**Not addressed**
- **coverage-auditor:** the two `deliverSecurityWarnings` call sites in `electron-main.js` are still not unit-tested. That file imports Electron and runs `main()` when it loads, so testing it means restructuring it. The delivery logic itself is fully unit-tested, and the PR body now says the call sites are untested.
- **integrator (comment-only):** sibling design docs still refer to `preload.js` instead of `preload.mjs`. That was already wrong before this PR; I left it for a follow-up.
- The change has still not been run in a live Electron window.

Next step: the driver re-posts the panel for round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1945253 cached reads)
- Output: 14859 tokens
- Cost: $1.3172306000000003
- Wall-clock: 924s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
