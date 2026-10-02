# Gauntlet FIX round 1: endojs/endo-but-for-bots#1414

I applied the round-1 panel fixes to the design doc and pushed them to the PR head, moving it from `a1a1b8a264` to `1ad8b493aa` with `safe-push-pr-head.sh`. CI is green: `ci-wait-merge.sh` returned rc 0 with 28 checks and 0 failures.

**Must-fix items** (in `designs/daemon-guest-delegated-host-channel-confinement.md`):
- **floot was missing from the survey.** floot's `host-powers` kind copies `@agent` into session guests on purpose, and its admin presets depend on that. I added floot to the problem statement, the survey table, the migration table, the phasing and the test plan.
  - Phase 4 now refuses a host formula in a guest's pet store whether it arrives through `introducedNames` or through a later `copy`, `move` or `storeValue`. The old wording only blocked `introducedNames`, which would have missed floot.
  - Open Question 3 now asks what the explicit opt-in (for example `@host-unattenuated`) should look like. Simply refusing would remove a feature floot already ships.
- **Guest-side identifier calls in jaine and claude-sandbox.** These calls are on the `llm` base, not the #1404 head the design was surveyed against. #1404's head already rewrites them, and its `EndoGuest` interface has none of those methods. The doc now says so, so they are not a third gap. It also records the exact grep used for the survey.
- **`makeChannel` bypassed the guest facet.** Every provisioner method that returns a capability, the makers included, now routes through `guestFacetFor`. The test plan checks that `makeChannel` returns a facet without `ids`.

**Should-fix items, also done:**
- I traced `capId`: floot's `container-mounts.js` creates it with `identify` and saves it so mounts survive a daemon restart. The design now has floot pin the mount under a pet name and save that path instead. The mount-bridge parameter is renamed `capId` → `mountPath`.
- The "every identifier use" claim is narrowed to "every surveyed use".
- A refused special name now throws from `maybeLookup` too, so a refusal can't be mistaken for a missing name.
- A new test fails if any `HostInterface` method is in neither the exposed nor the withheld list, so new host methods must be classified before they ship.
- The doc now defines the daemon terms and the five packages up front, and explains `postInternal`, "caplet" and `llm` where they appear.
- Prose fixes: "cancelling" → "canceling", the arrow in the Related section is now plain ASCII `->`, "Method Partition" heading capitalized, and the pronoun in the problem statement made explicit.
- I removed the redundant `## Status` section.

**PR body:** I removed the "This PR is design only." openers and updated the compatibility note for the wider Phase 4 refusal. I kept the Testing Considerations heading and replaced its text with a one-line pointer to the design's Test Plan, rather than deleting it as the pruner asked, because it is part of the standard PR template.

**Not done:** the decomplector's suggestion to derive the method lists from method signatures instead of keeping them by hand. The new completeness test covers the drift risk it raised.

The PR stays draft. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1488405 cached reads)
- Output: 12146 tokens
- Cost: $1.1460730000000001
- Wall-clock: 961s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
