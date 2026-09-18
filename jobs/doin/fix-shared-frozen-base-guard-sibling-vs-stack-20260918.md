---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix the shared-frozen-base guard in `scripts/jobs/gardening/ci-wait-merge.sh`: it
conflates SIBLINGS ON A SHARED PIN with a DEPENDENCY STACK, and blocks a safe,
single-PR unfreeze that harms nothing.

MAINTAINER RULING (kriskowal, 2026-09-18), which is the spec for this change:

  "It's unclear to me why this is a problem. My expectation is that the conductor
   will rebase the pull request on llm proper then merge, leaving the other pull
   requests on the same base pin alone until their next rebase or advancement of
   their base pin."

## The defect

`unfreeze_base_if_frozen()` counts OPEN PRs on the frozen base:

    count="$("$GH" pr list -R "$repo" --search "base:$base is:open" --json number --jq 'length')"
    if [ "$count" -gt 1 ]; then ... alert_maintainer ...; return 10; fi

and refuses whenever more than one PR shares the pin. But the unfreeze it is
guarding is a single line:

    "$GH" pr edit "$pr" -R "$repo" --base "$live"

That retargets ONLY that PR. It does not move, rewrite, or delete the frozen branch,
so every other PR on the pin keeps its base byte-for-byte unchanged.

The alert text asserts a consequence that does not follow: "Forwarding #$pr to live
'$live' alone would fork the stack off the shared base." That is true for a genuine
STACK — PRs based on one another's HEADS, where retargeting a lower PR orphans its
dependents — and false for SIBLINGS that merely share a pinned base. The predicate
measures "how many PRs share this base", which cannot distinguish the two.

## Grounding incident

endojs/endo-but-for-bots#1304 was approved by kriskowal at its exact head
(69943c50ae, 2026-09-18T14:19:47Z, "@kriscendobot Conduct."), CI green
(17 pass / 15 skip / 0 fail), mergeable and clean. Conduct stalled anyway at
`return 10` because `llm-387ea66` is shared by 7 open PRs (#1304, #1303, #1301,
#1299, #1298, #1100, #695). The stalling conductor then did BY HAND the analysis the
guard should do automatically, and found the seven are siblings: "none bases on
another's head." So an approved, green, mergeable PR sat blocked on a false premise,
and the maintainer had to adjudicate a non-question.

## Task

1. Make the predicate distinguish a STACK from SIBLINGS. A PR is a dependent iff its
   base ref is another open PR's HEAD ref (not merely the same frozen base). Block
   only when retargeting would actually orphan a dependent; otherwise proceed.
2. Keep a guard for the case that IS dangerous. Do not simply delete the check —
   a real stack still must not be force-forked, and the "not stranded silently, not
   force-forked" property is worth keeping. Say precisely which case still blocks.
3. Fix the alert text so it states the true consequence. The current wording asserts
   stack-forking for a case where nothing happens to the other PRs.
4. Consider whether a sibling-count is still worth REPORTING (informationally) even
   when it does not block — "you are forwarding one of 7 PRs off this pin" is useful
   context for the conductor's completion summary without being a stop.
5. Regression tests, in `scripts/jobs/test/ci-wait-merge-test.sh`, pinning BOTH
   directions: siblings on a shared pin unfreeze without blocking; a genuine
   dependent stack still blocks.

## Note

`endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918` is proceeding in
parallel under an explicit maintainer authorization, so #1304 is not waiting on this
fix. The other six PRs on `llm-387ea66` will hit this same guard on their own
conduct runs, which is why it is worth fixing rather than authorizing case by case.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-18T17:28:19Z
