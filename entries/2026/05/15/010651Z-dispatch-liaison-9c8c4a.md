---
ts: 2026-05-15T01:06:51Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/225200Z-message-steward-7e3a91.md
  - entries/2026/05/15/003930Z-message-steward-95e217.md
  - entries/2026/05/15/010640Z-message-steward-c4d8e9.md
---

# Dispatch: gardener encodes the operational-flake-handling workflow as a steward discipline

Dispatch root: `dispatches/gardener--9c8c4a/`. Garden-meta only.

## Background

Three operational-flake-shaped discipline edits have accumulated since 2026-05-14T22Z:

1. **Shepherd-ignore broadcast** ([`225200Z-message-steward-7e3a91.md`](../../2026/05/14/225200Z-message-steward-7e3a91.md)): when an operational flake makes a CI check unreliable, the steward broadcasts to all shepherds that the check is pass-equivalent until resolved.
2. **Resilience-PR-pattern**: a follow-up builder dispatch authors a workflow-hardening PR (#82 iter I, #255 iter II for the Guile-interop case).
3. **Retirement message** ([`003930Z-message-steward-95e217.md`](../../2026/05/14/003930Z-message-steward-95e217.md)): when the resilience PR merges, the steward broadcasts retirement of the ignore.

But the retirement step is incomplete. Today the four PRs that had been protected by the ignore (#109, #253, #250, #243) still showed `test-ocapn-guile-interop = FAILURE` from pre-merge runs; their shepherds reasonably treated the FAILURE as gating once the ignore was retired. The maintainer flagged at 01:05Z that #109 was missed; the steward had to re-run the failed CI jobs manually ([`010640Z-message-steward-c4d8e9.md`](010640Z-message-steward-c4d8e9.md)).

The retirement was forward-looking only; the *existing* FAILUREs on protected PRs remained until the steward manually re-triggered them.

## The complete workflow to encode

```
1. Detect: operational flake recurs across multiple unrelated PRs.
2. Broadcast: steward writes a `message: steward → *` instructing shepherds to treat the check as pass-equivalent. Names the affected check + the operational signature.
3. Resilience PR: builder dispatched to harden the workflow. Branch + draft PR per the PR-creation flow.
4. Merge: resilience PR merges normally (cleaner → judge → fixer → un-draft → maintainer review → conductor).
5. Retire: steward writes a retirement `message: steward → *`. The retirement message MUST:
   a. Name the broadcast it retires (cite the prior message entry).
   b. Enumerate the open PRs whose failing-check signature matches the retired ignore-class.
   c. Re-run the failed CI jobs on each enumerated PR as part of the retirement transaction (not a separate cycle).
6. Validate retirement: if re-runs surface the same failure across the affected PRs, the resilience iteration was insufficient. The retirement is invalid; the steward issues a re-broadcast and a follow-up resilience dispatch.
```

Steward's framing: "Cumulatively they constitute a small workflow worth its own sub-section rather than scattered rules."

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/steward/AGENT.md` (especially § Standing monitors and the recently-added per-cycle disciplines), `roles/shepherd/AGENT.md`, `skills/pr-ci-watch/SKILL.md`, the three precipitating message entries above.

2. **Decide where the workflow lives.** Two options:
   - **Option A (recommended)**: a new sub-section in `roles/steward/AGENT.md`, e.g., *Operational-flake handling* between Standing monitors and PR-creation-flow scan. The sub-section enumerates the six-step workflow with the precipitating evidence as a notes-from-the-field row.
   - **Option B**: a new skill `skills/operational-flake-handling/SKILL.md` codifying the workflow + a one-paragraph pointer from `roles/steward/AGENT.md`.

3. **Author the workflow** per the six steps above. Each step gets a short paragraph + a worked example pointer (the Guile-interop case from today; cite all three message entries by path).

4. **Update `skills/pr-ci-watch/SKILL.md`** with a one-line shepherd-side rule: when a shepherd reads a `test-X = FAILURE` whose corresponding shepherd-ignore broadcast was retired but no re-run has fired since the retirement, the shepherd re-runs the job before treating the failure as gating. This protects against the gap even if the retirement message's step-5c is somehow skipped.

5. **Cross-reference**: the `roles/shepherd/AGENT.md` operating norms should pick up step 5c too (a one-line norm referencing the new sub-section/skill).

6. **Notes-from-the-field row** dated 2026-05-15 citing the three precipitating message entries.

## Out of scope

- No new operational-flake broadcast or retirement. The Guile-interop case is in its post-retirement state with the re-runs the steward already issued; further evolution is steward-issue-shaped, not gardener-shaped.
- No edit to `monitor-endo-but-for-bots/SKILL.md` (the per-event reactions are unchanged; this is a steward-discipline edit, not a monitor-reaction edit).

## Commits

- One commit per substantively-revised file (`roles/steward/AGENT.md` or a new skill, plus `skills/pr-ci-watch/SKILL.md`, plus `roles/shepherd/AGENT.md`).

Push at end. Journal result entry.

## Report

≤ 300 words: chosen home (A or B), files revised, the six-step workflow in one-line-per-step compressed form, one-line confirmation that the next retirement message will include step 5c, one-line `Self-improvement: ...`.
