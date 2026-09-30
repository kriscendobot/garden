The design for making every clip lifecycle action a capability is written up as draft PR [kriscendobot/minion.town#142](https://github.com/kriscendobot/minion.town/pull/142), file `designs/clip-lifecycle-capabilities.md`. An earlier claimant of this job had already written the design and opened that PR. I adopted it and added one commit rather than opening a second one.

**What I did:**
- **Found the existing PR.** It is draft, sits on the frozen base `main-33aac61`, and its only change is the design file. I checked it against the six points in the job and it covers all of them:
  1. `unpublish` becomes a right on a per-clip controller.
  2. Listing your clips is a listing of the guest's own pet-name store. A separate owner-keyed billing view is kept for accounting only.
  3. The controller is a daemon object held under a pet name. Why not the clip directory itself, and why not keep swiss numbers as the main form, are each argued in their own sections. The capability-URL locator work is linked.
  4. A migration plan for clips published before #85.
  5. Revocation with an opt-in revoker, and cleanup of all grants on unpublish.
  6. The per-guest `sites` facet is treated as the publish capability, and the pinned `owner` shrinks to an accounting tag.

  It also has an ownership map, a test plan and a diagram, and the diagram parses.
- **Filled one gap.** The existing draft never mentioned draft PR #88, which proposes that clip content never changes: an upgrade publishes a new clip at a fresh address and redirects to it. That changes what the "content" upgrade right means. Commit `0e2ccb8` adds a short note on how the two designs interact, plus open question 8: under #88, does "content" stay one right that follows the clip to its successor, or become a separate `succeed` right?
- **Cleaned up after myself.** Before I found #142, I briefly pushed a frozen-base branch `main-c54f507`; I deleted it. My own draft was discarded.

**Decisions for the maintainer:** eight open questions in § 9 of the design. The main ones:
- whether the controller object should be the main form, with swiss-number strings only as an optional export
- whether billing moves when a clip's controller is handed to someone else
- whether swiss numbers already issued under #85 keep working for a while or are migrated straight away
- the #88 question above

**Follow-ups:**
- #142 is left as a draft. The completion machinery should queue its design review.
- The design points 8 and 18 of the PR diff at #85 and #88, whose dispositions are still up to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-clip-lifecycle-capabilities.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1436854 cached reads)
- Output: 11515 tokens
- Cost: $1.1418068000000001
- Wall-clock: 147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
