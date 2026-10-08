Fix round 4 for endojs/endo-but-for-bots PR #1431 is pushed and CI is green (all 28 checks, 0 failed; `ci-wait-merge` exit code 0).

**What the panel asked for:** the round-4 panel review asked for changes, with two must-fix items, both from the novice seat:
1. Out-of-date text was left as the main statement of the design, with "Superseded" and "Revised" notes stuck on top of it.
2. The Revision section only reached the adopted fix after about 100 lines of evidence.

**What I changed** in `designs/hardened-text-codecs-shim.md`, as one follow-up commit `ecf10b2d31` pushed with `safe-push-pr-head.sh`:
- **Must-fix 1:** I rewrote the problem statement and the "Lockdown sequencing" section in place so they describe how the design works now. That includes the extra step on SES-for-XS that runs when the module loads. I removed the "Superseded" and "Revised" notes. The banner at the top now just points to the Revision section for the history and evidence.
- **Must-fix 2:** the Revision section now opens with a short summary of the fix before the failure chain, the measurements and the rejected alternatives.
- **Smaller should-fix items:**
  - Test plan item 9 is now one assertion per bullet.
  - Item 9 also asserts that each replacement's own keys are exactly `length`, `name` and `prototype` (critic seat).
  - Every `§` cross-reference now reads "the section …" (pedant seat).

**Left for later or for the maintainer** (all should-fix or comment-only, so none of them blocks):
- **Decomplector:** split the shared helper into a stateless function that builds the constructor and a separate installer for the codecs.
- **Ergonomist:**
  - The error messages should point users to the docs.
  - The "secure mode" prefix on the "called without `new`" error is inconsistent between the codecs and `SharedURL`.
- **Skeptic:**
  - State plainly what the design assumes about code holding references from before `lockdown()`.
  - Check that Node's own users of the codecs (`fs`, `StringDecoder`) still work once the prototype's `constructor` points at the replacement.
- **Critic and skeptic:** ship the codec release together with the `URL`/`URLSearchParams` follow-up, since the codec change alone doesn't stop `lockdown()` throwing on affected Chromium.
- **Novice:** the "Why the global binding is replaced" and idempotence paragraphs, and test item 7, are still dense.

I didn't re-run the panel; the driver posts panel round 5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1255164 cached reads)
- Output: 12706 tokens
- Cost: $1.1908968
- Wall-clock: 730s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
