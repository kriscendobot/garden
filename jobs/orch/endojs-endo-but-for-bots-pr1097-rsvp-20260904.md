---
order: serial
children: endojs-endo-but-for-bots-pr1097-pin-base-20260904 endojs-endo-but-for-bots-pr1097-drop-base64-20260904 endojs-endo-but-for-bots-pr1097-rename-info-types-20260904
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-04T08:53:24Z
---

# Orchestrate the @kriskowal review response for endojs/endo-but-for-bots PR #1097

Drives the CHANGES_REQUESTED review (pullrequestreview-5069647283) to resolution as
three claim-sized serial stages, decomposing the doomed monolith
`endojs-endo-but-for-bots-pr1097-fix-review` (which overran its 7200s handler budget
running all four asks in one claim; the watchdog remedy was "split into claim-sized
stages"). Serial + halt-on-failure so a failed/parked rebase surfaces rather than the
downstream fixers running on a broken base.

1. pin-base (weaver): move the merge base forward off frozen `llm-939acda` and rebase;
   messages the maintainer if it is a curated reconstruction rather than a mechanical rebase.
2. drop-base64 (fixer): remove every base64 streaming facility now that byte arrays are passable.
3. rename-info-types (fixer): rename getInfo()->info(), expand `unknown` design-doc return
   types, reply on both review threads, leave PR ready for re-review.
