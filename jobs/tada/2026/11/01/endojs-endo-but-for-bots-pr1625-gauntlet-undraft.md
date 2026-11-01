I un-drafted endojs/endo-but-for-bots#1625 ("feat(exo-agent-factory): coordinator facet for durable facet formulas"). It is now ready for review, on the same head the panel passed.

**Head check:** Right before un-drafting I fetched fresh metadata: the PR was open, still a draft, and its head was exactly `a796cae574f9e48a78f9219de09d8c18fefe96ab`, the head the panel covered. I then ran `gh pr ready`. Checking again afterwards showed `isDraft=false` and the same head.

**Advisory appellate pass:** A light `claude -p` review of the 315-line diff found these possible gaps. It reviewed the diff only, without the full `coordinator.js`, so each one needs confirming. None of them blocked the un-draft:
- **Possible permanent false "removed":** `lifecycleFor` returns an inert lifecycle when a key is below `nextSequence` but missing from `operations`. If a create is still in flight or was rolled back, a formula revived in that window would be told it was removed and never recover. Worth confirming that the sequence bump happens after the operation is registered.
- **Loose key parsing:** the parser accepts non-canonical keys such as `"01.0"`, which also come back inert. `boundFacet` takes `M.number()` where `M.nat()` would reject bad input at the guard.
- **Unattenuated facet on the public return:** `coordinatorFacet` and the unguarded `boundFacet` are returned next to `rootFacet` and can reach any namespace's facet. Only a comment keeps them private.
- **Weak guards:** the remotable return guards don't enforce their labels, and the inert iterator's guard is looser than the live one's.
- **Test gaps:** the revoked-id-never-reissued claim is tested across only one restart, and no test covers revoked parents or faulted-but-reserved operations.
- **Minor:** each call creates a new inert exo, so its identity isn't stable.

These could become a follow-up fix job if the maintainer wants them looked at during review. I didn't change anything in the garden repo.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1625-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178145 cached reads)
- Output: 1461 tokens
- Cost: $0.42148099999999994
- Wall-clock: 52s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
