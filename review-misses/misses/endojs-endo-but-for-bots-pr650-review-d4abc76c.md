---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr650-review-d4abc76c
verdict: miss
category: naming
pr: 650
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/650#pullrequestreview-4673371396
identity: endojs/endo-but-for-bots#650:review:4673371396:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr650-mount-revocation-caretaker-deny-patterns
missed_by: stylist
severity: minor
cluster: avoid-name-abbreviations
cluster_pattern: An abbreviated identifier in freshly-authored code (dir, Arg, subDir, Temp) that a panelled PR let through — the maintainer repeatedly asks names be spelled out in full; no code-panel naming seat or gate mechanically flags abbreviation.
---

# Miss: abbreviated identifier `makeTempRoot` in panelled new test code on #650

kriskowal's second review on #650 (review `4673371396`) was an **APPROVAL** that
bundled a merge directive with one inline naming ask; both paraphrased here
(verbatim untrusted text at `comment_url`):

1. **review body — a merge directive:** rebase, retcon, and conduct the PR onto
   `llm`, together with the recommended inline change below. This is normal
   garden-chain operation, not a review-process indictment (see grounds).
2. **inline on `packages/daemon/test/mount-revocation.test.js` — a naming ask:**
   spell out the abbreviation in the helper name `makeTempRoot`, renaming it
   `makeTemporaryRoot`. The primary loop (`…-pr650-review-d4abc76c`) applied the
   rename across all occurrences in that file.

## Grounds (miss — the naming ask, comment 2)

This is a second identifier-abbreviation ask on the **same** PR #650, one review
later than the `dir`→`directory` ask already recorded in
`…-pr650-review-35ff43ca`, and it satisfies the same miss test that record
established:

- **Garden-authored, freshly written code.** `makeTempRoot` is a helper the
  mount-revocation build authored in the new file
  `packages/daemon/test/mount-revocation.test.js`, not inherited legacy.
- **The code panel demonstrably ran.** The gauntlet report
  (`gauntlet-endo-but-for-bots-pr650-mount-revocation-caretaker-deny-patterns`)
  records the code panel running 19 seats — including the always-on `stylist`
  naming seat, which even edited this very file (removed decorative dividers) —
  yet let the abbreviation through.
- **A plain, unambiguous abbreviation.** `Temp` for `Temporary` carries no
  domain-vocabulary ambiguity; the maintainer's spell-it-out preference is
  consistent and long-standing (now four asks: `Arg` #592, `subDir` #127, `dir`
  #650, `Temp` #650).

The `stylist` seat brief reads for identifiers being "crisp and unambiguous" but
encodes no mechanical *never-abbreviate* check, so an abbreviated-but-unambiguous
local slips its lens — the exact sense-gap the `avoid-name-abbreviations` cluster
was opened to close. Genuine review miss, not new direction.

## Why comment 1 (the rebase/retcon/conduct directive) is NOT a miss

The review body is a merge instruction — rebase onto the drifted `llm` tip,
retcon into a single package commit, conduct to green-and-merge. That is the
standard finalization chain a maintainer runs on an otherwise-approved PR; nothing
about it indicts the review process for failing to anticipate it. The primary
job dispatched a conductor for exactly this. Recorded here so it is not separately
re-litigated; it mints no cluster.

## Threshold call recorded at this record's tail

Joining this miss bumps the `avoid-name-abbreviations` cluster to **count=2** but
its PR set stays **{650}** — both members are on the same PR. The floor (K≥3
misses across **≥2 distinct PRs**) is therefore still **not met**, and this is
precisely the "one messy PR masquerading as systemic" case the two-PR rule guards
against: two abbreviation nits on one PR are not yet a cross-PR pattern. The
severity bypass does not apply either — as the #592 and #650(`dir`) records
established, **no garden seat, skill, or gate encodes identifier-abbreviation
avoidance today**, so this is a *prevention gap to be created*, not a
sense-and-correct failure of a standing rule that already bound; and a lone
`Temp`→`Temporary` nit is `severity: minor`. Hold below the floor and accumulate.
A **second panelled abbreviation miss on a DIFFERENT PR** would give prs={650, …}
and trip the cluster for a `review-improve-avoid-name-abbreviations` dispatch.
