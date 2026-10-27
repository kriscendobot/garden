Viability check for endojs/endo-but-for-bots#1349, "feat(ses): hardened text codecs shim". The PR passes: it has not been superseded, and the problem it fixes still exists.

**PR facts:** The PR is OPEN, not merged and not a draft, and GitHub reports it MERGEABLE. The base is the frozen `master-6ee3fda`. The head is `b43f86c0d3`, pushed 2026-10-27T18:12Z. CI was green (16/16) on the previous head, `f66740e9ba`. It depends on #1425, which is still open and unmerged.

Deciding question: Is the problem from endojs/endo#3369 still unfixed on current base code, with no newer implementation landed or chosen in place of this PR? (The problem: lockdown fails on Chromium hosts before version 138, where the `TextEncoder`/`TextDecoder` constructors carry restricted `caller`/`arguments` properties.) **Yes.**

Evidence:
- **The problem is still open.** endojs/endo#3369 is OPEN. It is a regression from endojs/endo#3322 (merged 2026-07-22), which permitted the codecs as universal intrinsics. Neither upstream `endojs/endo` master nor the fork's `master` or `llm` branch has `packages/ses/src/tame-text-codecs.js`. The newest commits touching `lockdown.js` on those branches are about Temporal and URL permits, not codec taming.
- **The competing fix has not landed.** The alternative is endojs/endo#3371, from naugtur: a permits tweak that allows a null `caller`/`arguments` descriptor. It is OPEN, still needs review, and has had no activity since 2026-10-05.
- **naugtur is working with this PR's approach, not replacing it.** On 2026-10-09, after opening #3371, they left review comment r4229750056 on #1349 asking for the taming to apply only when it is needed. Today's head `b43f86c0d3` does exactly that: it wraps a codec constructor only when it has an own `arguments` property.
- **The PR is active.** The maintainer (kriskowal) requested changes on 2026-10-08 with "minor findings only", and the follow-up commits through today answer the review and panel findings.

#3371 is still a live alternative. If upstream merges it, the Chromium workaround in #1349 could become unnecessary, but nothing has displaced the PR yet. The other parts of #1349 (the XS compartment intrinsics change, docs, and tests) aren't covered by #3371 either way.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-conditional-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (250312 cached reads)
- Output: 2242 tokens
- Cost: $0.5167584
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
