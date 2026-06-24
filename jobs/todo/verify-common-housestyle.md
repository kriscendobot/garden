# Verify v2 COMMON.md folds the 4 house-style rules; update the stale manifest note

The prune-v1-legacy job flagged that
[`designs/v1-migration-manifest.md`](designs/v1-migration-manifest.md) is **stale**
on one point: it says v2 `roles/COMMON.md` is "not yet written," but COMMON.md is
now authored (~215 lines). Several v1 house-style **skills** were classified
"keep until COMMON.md absorbs them." Confirm the absorption, then the manifest and
those v1 skills can be settled.

## Task

1. Read `roles/COMMON.md` on `main2` and confirm it genuinely folds in the four
   v1 house-style rules — **em-dash-style**, **no-latin-shorthand**,
   **relative-paths**, and **test-title-spec-spelling**. For each, verify the rule
   is actually stated (not merely implied) in COMMON.md, since COMMON.md is the
   standing instruction every dispatched subagent reads first.
2. **If any of the four is missing or weaker than the v1 skill**, fold the
   missing substance into `roles/COMMON.md` (consult the v1 skill bodies under
   `/home/kris/v1/skills/<name>/SKILL.md` for the canonical wording). Keep it
   terse and consistent with COMMON.md's existing voice.
3. **Update the stale manifest note** in `designs/v1-migration-manifest.md`:
   correct the "COMMON.md not yet written" statement, and record that these four
   house-style skills are now absorbed (so a future prune can drop the v1 copies).
   Do **not** delete the v1 copies in this job — just mark them droppable.

## Deliverable

A confirmation (per rule: present / folded-in-now) plus the corrected manifest,
committed to `main2` under the bot identity. Report the SHA and a one-line
per-rule status. If a write is blocked, report the diagnosis and the exact
ready-to-apply change rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
