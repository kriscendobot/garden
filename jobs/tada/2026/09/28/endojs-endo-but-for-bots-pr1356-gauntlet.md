gauntlet-status: not-viable
viability-result: overtaken
# gauntlet endojs-endo-but-for-bots-pr1356-gauntlet - not viable

the premise was overtaken. Deciding question: Is the hardened URL/URLSearchParams SES shim (endojs/endo#2635) still unimplemented where this master-based PR was meant to land it? No, so the answer to the question is no. Option: close as superseded.

## Viability report

I checked endojs/endo-but-for-bots PR #1356 and it has been overtaken: an equivalent implementation already merged upstream, so the gauntlet should not start. I spent no clean, panel, fix, CI-wait or un-draft budget and made no changes.

**PR facts:** #1356 "feat(ses): tame and permit URL and URLSearchParams" is OPEN, draft and unmerged. Its base is `master-6ee3fda`, which matches the fork's current `master` tip. Its head is `build/hardened-url-shim` @ `3655a3c3`. It was created 2026-09-27T22:21Z by the job `build-hardened-url-shim` and has no reviews or comments.

Deciding question: Is the hardened URL/URLSearchParams SES shim (endojs/endo#2635) still unimplemented where this master-based PR was meant to land it? No, so the answer to the question is no.

Evidence:
- **Merged upstream:** endojs/endo#3332 ("feat(ses): permit URL and URLSearchParams as a vetted shim (%InitialURL%/%SharedURL% split)") merged on 2026-08-21, merge commit `30147f5a`. Upstream `endojs/endo` master already has `packages/ses/src/tame-url-constructor.js`, and issue endojs/endo#2635 is CLOSED.
- **On `llm` too:** the fork's `llm` branch already has `tame-url-constructor.js` (URL permits were reconciled 2026-08-22). Only the fork's `master` lacks it, and that is because it lags upstream, not because the work is still needed.
- **Build job withdrawn:** the job that produced this PR was withdrawn at 2026-09-27T21:54Z with the reason "Upstream implementation merged as endojs/endo#3332 on 2026-08-21; duplicate implementation work is moot." #1356 was opened about 27 minutes later anyway, from a run that was already in flight.
- **Design already marked complete:** companion PR #1355 marks the hardened URL shim design Complete, citing endojs/endo#3332. It has the same author and time frame.
- **Silencing warnings handled elsewhere:** the lockdown warnings for the URL family are being silenced separately in #1281 on this fork and endojs/endo#3368 upstream.

Option: close as superseded

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1356-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (222008 cached reads)
- Output: 2275 tokens
- Cost: $0.4646696
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
