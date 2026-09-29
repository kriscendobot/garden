## build-daemon-docker-selfhost: stopped without building

I did not build this job or open a PR. Building it would have made a duplicate PR, and it would go against the maintainer's stated direction.

**Why I stopped:**
- **Duplicate work.** Two PRs for this design are already open on `endojs/endo-but-for-bots`:
  - endojs/endo-but-for-bots#694 adds the Docker image and an authenticated remote gateway. It is based on `llm-f7932ed` and can be merged, but its gauntlet has been parked since 2026-07-11 after repeated failures.
  - endojs/endo-but-for-bots#608 adds the Docker self-hosting image and is based on `master-eecc683`.
  
  A third PR would duplicate them.
- **The maintainer declined this direction.** On 2026-07-09 kriskowal closed endojs/endo-but-for-bots#134, saying Docker self-hosting is "headed rapidly in another direction." The planned shape is now `@endo/gateway` and `@endo/mcp`, grown alongside the AWS deployment.
- **Why the job keeps coming back.** The job was promoted from a deferred plan. The design record it comes from, `journal/plan/designs/endo-but-for-bots/daemon-docker-selfhost.md`, is still marked `status: Not Started` (M3). As long as it stays that way, the fleet will keep creating this build job. This is a repeat: the reaper parked an earlier attempt on 2026-09-27, and a similar job was stopped on 2026-07-10.

**What I did:**
- Sent the maintainer inbox a note with the evidence and a decision to make.
- Added this recurrence to the memory note `endo-gateway-mcp-direction.md`.
- Made no commits to the garden or the project repo.

**Decision needed from the maintainer** (asked in the message):
- **(a)** Mark the design record Declined or Superseded and close endojs/endo-but-for-bots#608 and endojs/endo-but-for-bots#694. This stops the job from recurring.
- **(b)** Pick one of those two PRs to carry forward with "run the gauntlet #N".

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/694 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-docker-selfhost.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 16 tokens (435868 cached reads)
- Output: 3227 tokens
- Cost: $0.5794656
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
