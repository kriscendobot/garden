**Viability report: kriscendobot/minion.town PR #221**

The PR is open, a draft, and not merged. It is titled "design: recursively attenuated DynamoDB capabilities". Its base is `main-68c3960` and its head is `7eca8b82`, which adds one file, `designs/recursive-dynamodb-capabilities.md`. It was opened about 10 minutes before this check and has no reviews or comments yet.

Deciding question: Does the repo already have a recursive DynamoDB partitioning and attenuation mechanism, or a design for one, on current `main` or in another PR, that would make this design redundant or remove the need kriskowal described?

Answer: No. The need still holds and nothing has replaced this PR.

Evidence:
- **Motivating review still applies.** In the #144 review (discussion_r4332668779), kriskowal asked for a job to build recursive partitioning and attenuation of DynamoDB if no such mechanism exists, or a follow-up design if building it would be a big digression. This PR is that design. #190, the guest-coupons design, merged and asks for no such thing.
- **Base is current.** Comparing `main-68c3960...main` shows `main` is 0 commits ahead, so no newer base history has landed.
- **No existing design.** `designs/` on `main` has no DynamoDB or attenuation design. The closest files are `guest-coupons.md` and the `*-capability.md` designs.
- **No competing PR.** A search for "dynamodb" across all PR states turns up nothing that implements or designs recursive attenuation. #126 covers persistence, and #199, #218 and #210 are feature PRs that would use the mechanism, not replace it.
- **Nothing upstream.** A code search for `exo-dynamodb` across the endojs org returns nothing, so the proposed `@endo/exo-dynamodb` package does not exist yet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175246 cached reads)
- Output: 1321 tokens
- Cost: $0.4105732
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
