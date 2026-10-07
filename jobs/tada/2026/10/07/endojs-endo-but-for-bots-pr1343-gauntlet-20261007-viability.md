**Viability report: endojs/endo-but-for-bots PR #1343** ("feat(daemon): endow retained guest special names")

**PR facts:** The PR is open and not merged or a draft. The head is `eaa3fd3534d99647fdc7286e05a55403a5815e67`. The base is `feat/daemon-provisioning-grants-5feadae`, a frozen snapshot of #1042's head at `5feadaeac0`.

**Deciding question:** Does `origin/llm`, or any newer PR, already give `provideGuest` a single `@`-partitioned `endowments` map with pet-name-path values and a default indelible `@main` worker?

**Answer: no.** The PR has not been superseded, and its premise still holds.

**Evidence:**
- **Not on `llm`.** On the current tip (`f1e306582`, 2026-10-06), `packages/daemon/src/host.js` and `types.d.ts` have no `provideGuest` `endowments` option and no `endowSpecialNames`. The `@main` default exists only in the host's own built-in specials. None of the recent `llm` commits (the guest-socket and ironhorse work) implements guest endowments.
- **#1343 is the chosen implementation.** The design-only #1102 was closed in its favor on 2026-09-29. Searching for competing PRs turned up only follow-ups:
  - #1390 (pet-name-path-only, draft) lists "Refs: #1343" and was spawned from kriskowal's review on this PR.
  - #1404 (guests use no identifiers or locators, draft) carries out the same "hide formula identifiers from guests" direction that motivated this PR.
- **The motivating need still holds.** kriskowal asked to steer guests away from formula identifiers when injecting names (review 2026-09-28) and asked for pet-name-path values (review 2026-09-30). Commit `eaa3fd3534` delivers both, and kriskowal approved that exact head twice (2026-10-01 "Please conduct", and again on 2026-10-05).
- **Open issue for the merge step, not this gate:** the base is a frozen snapshot of the still-draft #1042. A merge as-is would land on that snapshot and never reach `llm`. On 2026-10-05 the bot asked the maintainer to pick (a) retarget to `llm` (which also lands #1042's commits), (b) retarget to #1042's live branch, or (c) merge #1042 first, then weave this PR onto `llm`. There is no reply yet. The conductor and un-draft stages need that answer before merging. It does not affect whether the PR is still wanted.

I spent no clean, panel, fix, or CI budget and made no changes to the PR or the garden.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (348487 cached reads)
- Output: 2574 tokens
- Cost: $0.5119454
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
