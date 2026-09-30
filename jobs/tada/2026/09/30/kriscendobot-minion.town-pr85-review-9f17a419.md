---
handed-off: kriscendobot-minion.town-pr85-fix-ocap-publish-authority
deliverable-complete: false
---
I've handed the work on kriskowal's review of kriscendobot/minion.town#85 (review 5360873327) to a new fixer job, `kriscendobot-minion.town-pr85-fix-ocap-publish-authority`. The review itself is not fixed yet; that job owns it.

**What the review asks:** it is CHANGES_REQUESTED with no inline comments, so there is one ask. The PR lets only the clip's recorded owner publish or upgrade it, by checking `record.owner === owner` in `publish.ts`. kriskowal says that goes against the object-capability (ocap) model: "if you have to ask who is acting, you have failed." The right to publish or upgrade should instead be a capability that can be handed to someone else or given in a narrower form. The owner check shows up in the PR body's "Authorization (deliberate)" section, the MCP `upgrade` tool description, code comments, and tests such as "rejects an owner who does not own the clip".

**What I did:**
- The recheck preflight said to proceed: no one had already addressed this review.
- I posted the fixer job at mentor tier with minion fallback. It is in `jobs/todo/` on origin/journal2 as commit `bf960793`, which I confirmed with a fresh clone. The fixer is told to:
  1. Find every check on the publish/upgrade path that decides based on who the caller is.
  2. Make upgrade authority something a caller holds, which can be passed on or narrowed (for example upgrade-only, or upgrade plus unpublish), using minion.town's existing daemon guest powers and pet names. `owner` stays only for accounting.
  3. Update the code, the tool descriptions, the tests (a caller without the capability is rejected, plus a test for passing it on and narrowing it) and the PR body's Authorization section.
  4. If moving the whole publish/unpublish lifecycle over needs a bigger design decision, post a designer job for that.
  5. Reply to the review on the PR and verify locally before pushing.
- The first post was dropped as a duplicate because this review job already holds the review's identity key. I reposted with the sub-identity `kriscendobot/minion.town#85:review:5360873327:fix`.

Nothing changed on main2. I made no commits and no PR edits.

**Follow-up:** the fixer job needs to be claimed and finished. After that, #85's gauntlet should re-run.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-review-9f17a419.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (766749 cached reads)
- Output: 4471 tokens
- Cost: $0.6573138
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
