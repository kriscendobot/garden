Both asks are fully resolved and corroborated with named artifacts. No further work is required — the deliverables already landed on the PR branch (and the routed sub-job `endojs-endo-but-for-bots-pr1304-eb58df65` is in `jobs/tada/`, not stranded).

## Completion report — review on endojs/endo-but-for-bots #1304 (review 5244218260, kriskowal, CHANGES_REQUESTED)

Re-derived from scratch after the reaper requeue. The review body ("A couple nits.") carries no separate ask beyond its two inline comments. Both are resolved and independently verified:

**Ask 1 — `packages/helpdown/src/make-help.js`** (comment 4043773957): "In 2026, this goes without saying. The comment is superfluous."
- **Resolved** by commit `0005176282f` — *"refactor(helpdown): drop the own-property-lookup explanatory comment"*. This commit is the current PR HEAD (`mergeable: true`).
- **Corroborated**: I read the file at HEAD; `help()` now goes straight to `if (Object.hasOwn(helpText, methodName)) {` with the explanatory block gone. The `Object.hasOwn`-over-`in` choice remains. Thread reply 4043877442 posted.

**Ask 2 — `packages/daemon/src/directory.js`** (comment 4043792331): "To what extent does it make sense to promote this complication into `@endo/platform`?"
- **Resolved** as a declarative design decision in inline reply 4043877549: keep it in the daemon for this slice — `@endo/platform` is scoped to daemon-agnostic host-platform seams, while this read-only view is coupled to daemon domain types (`NameHub`/`ReadableNameHub`, the exo guard) and the daemon liveness model; any generalizable pattern would belong nearer `@endo/exo`, and is best reassessed at the later #1125 slice with a second consumer. Offer to open a follow-up design issue left open to the maintainer.
- **Corroborated**: reply exists on-thread with full rationale; a question answered with a reasoned decision is a valid resolution.

No code change was needed from this attempt — the fix commit was already on the PR head and the design answer already posted. Nothing to commit/push to main2.

Follow-up (maintainer's option, not blocking): if kriskowal wants the "guarded read-only exo / capability-attenuation" generalization tracked rather than left in-thread, a follow-up design issue can be opened per the offer in reply 4043877549.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-review-96879182.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 58 tokens (1391378 cached reads)
- Output: 14629 tokens
- Cost: $2.272716
- Wall-clock: 275s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
