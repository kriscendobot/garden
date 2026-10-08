**Viability report: endojs/endo-but-for-bots#1425, "fix(ses): sample XS compartment intrinsics at lockdown"**

The verdict is **proceed**. I re-checked the PR just now. It is still open, unmerged and a draft, with the same head `3158064e5a` and base `master-6ee3fda`.

Deciding question: Does the base branch still build XS's post-lockdown `Compartment` from the import-time `ShimStartCompartment`? If so, a global that is deleted or replaced before `lockdown()` still reaches child compartments without being hardened. And has no newer PR or design replaced this fix? **Yes to both.**

Evidence:
- **The base code still has the bug.** `master` has no new commits since `6ee3fda`. No commit since 2026-09-01 has touched `src-xs/compartment.js` or `src-xs/lockdown-shim.js`. On both `master` and `llm`, `lockdown-shim.js` still passes the import-time `ShimStartCompartment` to `adaptCompartmentConstructors`.
- **No other PR replaces it.** Searching PRs for `ShimStartCompartment` finds only #1425 and #1431. #1431 only adds a design document for #1349's text-codec change and doesn't touch the compartment code.
- **The reason for the fix still holds.** #1349 is still open, and its fix only wraps `TextEncoder` and `TextDecoder`. The leak #1425 fixes applies to any global changed before lockdown. There are no maintainer reviews. Earlier gauntlet runs stopped at the clean stage on an older head, and CI has been green since the shepherd pass pushed `3158064e5a`.

This stage spent no clean, panel, fix or CI-wait budget. My previous session wrote this same verdict but put the result marker after the completion signal; this report ends with the signal.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (338420 cached reads)
- Output: 3181 tokens
- Cost: $0.952445
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
