**Completion report: endojs-endo-but-for-bots-pr1431-gauntlet-fix-6 (fix round 6)**

The panel's single must-fix item is applied and pushed, and CI is green (28/28 checks, `ci-wait-merge` rc 0).

**Must-fix applied (from the decomplector):** the design now depends on endojs/endo-but-for-bots#1425 and runs the codec taming exactly once, inside `lockdown()`. I did not fold #1425 in; it is still open, so it is listed as a prerequisite.

All changes are in `designs/hardened-text-codecs-shim.md`, commit `15dd235cc5`, pushed on top of `8fc7ac258b` with `safe-push-pr-head.sh` in advance mode:
- **Lockdown sequencing, step 1:** the taming is now a single application inside `lockdown()` on every engine, SES-for-XS included. The step cites #1425 as what makes that possible.
- **Revision section:** the "Why the global binding is replaced" paragraph and the idempotence/`WeakSet` paragraph are replaced by an **install rule**. One global write just before the collector samples is the rule for universal host WebIDL constructors, and the `URLSearchParams` follow-up uses it too (this also covers the decomplector's should-fix #2). A paragraph explains why the rule depends on #1425.
- **Unrepointable-prototype diagnostic:** this now covers every descriptor state that blocks repointing `constructor` (frozen; non-writable on a non-extensible prototype; non-writable and non-configurable). It throws a `TypeError` naming the constructor. This covers the skeptic's should-fix.
- **Test plan item 8:** "Double application" is replaced by "Unrepointable host prototype", which asserts the `TypeError` in each of those states.
- **Compatibility:** I removed the claim that importing SES-for-XS repoints `constructor` without `lockdown()`. The multi-copy bullet is now short and has no `WeakSet` discussion.
- **Dependencies table:** added a prerequisite row for endojs/endo-but-for-bots#1425.

**Not addressed:** the remaining should-fix items are left for later rounds or the maintainer:
- the partial-fix tracking gate for endojs/endo#3369
- cross-engine evidence for the unreachability walk
- the error-message spelling split with `SharedURL`
- putting the adopted remedy before the rejected alternatives

**Follow-up:** the design revision should not land before endojs/endo-but-for-bots#1425 merges.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1450060 cached reads)
- Output: 11770 tokens
- Cost: $1.1481400000000002
- Wall-clock: 925s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
