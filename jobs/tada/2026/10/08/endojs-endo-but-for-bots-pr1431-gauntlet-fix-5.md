## Fix round 5 for endojs/endo-but-for-bots PR #1431: fix pushed, CI green

**Panel-5 verdict:** review `5450894500` on head `ecf10b2d31`. The only must-fix came from the pedant seat: capitalize the independent clause after the colon in "Summary of the remedy:" (Chicago 6.60). The decomplector also requested changes on a should-fix: keep the shared maker pure.

**What I changed:** one follow-up commit, `8fc7ac258b`, to `designs/hardened-text-codecs-shim.md` (+21/−8). It went up with `safe-push-pr-head.sh` as a fast-forward from `ecf10b2d31` to `8fc7ac258b`.
- **Must-fix:** the summary now reads "Summary of the remedy: Before the intrinsics collector samples…".
- **Decomplector:** `encapsulateHostConstructor` is now described as pure. It builds the delegator, sets `length`, `name` and `prototype`, repoints `constructor`, and returns the delegator. It never touches `globalThis`, which matches how `SharedURL` returns its value through `addIntrinsics`. The codec taming in `tame-text-codecs.js` now does the global install and owns the idempotence `WeakSet`. I updated the idempotence paragraph to match.
- **Ergonomist:** the frozen-prototype `TypeError` message now names a second SES copy loaded after `lockdown()` as a likely cause.

I did not apply the other should-fix and comment-only items, which are design-scope questions. They include:
- shipping alongside the follow-up for endojs/endo#3369;
- headless-shell versus full-Chrome evidence;
- moving the background section earlier and splitting the Revision section;
- the stale Phases section.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 28 checks, 0 failed, GREEN.

**Next:** I did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (884146 cached reads)
- Output: 4310 tokens
- Cost: $0.7213412
- Wall-clock: 802s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
