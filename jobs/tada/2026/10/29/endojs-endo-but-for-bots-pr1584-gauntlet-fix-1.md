The panel-1 must-fix item for endojs/endo-but-for-bots#1584 is fixed and pushed, and CI is green: 15 of 15 checks passed (`ci-wait-merge.sh` returned rc 0).

**What I did:**
- **Must-fix (`prefer-endo-primitives`, `packages/ses/test/_xs.js`):** I marked the file exempt instead of switching it to `@endo/bytes`. This test exists to check the host `TextEncoder`/`TextDecoder` that SES hardens on XS: it asserts that compartments share those exact constructors and that they are frozen. Using `@endo/bytes` would skip the very constructors under test. The new comment on lines 2–3 is `// prefer-endo-primitives-exempt: …` and says why. Prettier reports the file is clean.
- **Pruner advisory (non-blocking, `packages/ses/test/_xs-missing-text-codecs.js:1`):** I left that comment as it is. It explains something you can't see from the code: lockdown runs only once per realm, which is why this case needs its own xst script.
- **Commit:** `6ff4138d1a` ("test(ses): exempt the XS host-codec fixture from prefer-endo-primitives"). It went onto the PR head `build/hardened-text-codecs-shim-xs-smoke` as a follow-up commit through `safe-push-pr-head.sh`, moving the head forward from `73c30564f6`.

**Follow-ups:** none from this stage. The driver will re-post panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1584-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (427844 cached reads)
- Output: 2488 tokens
- Cost: $0.5441608
- Wall-clock: 528s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
