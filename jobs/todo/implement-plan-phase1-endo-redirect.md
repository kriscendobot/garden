# Plan-in-journal Phase 1 + Phase 4: endo redirect + retire the sync discipline

Follow-on to implement-plan-in-journal (garden#4, designs/plan-in-journal.md).
Phase 0 + Phase 2 (bulletin/foreman) landed: the plan is now journal2 state under
journal/plan/ (141 endo records as the source of truth, generated README, validator,
renderer folded into the bulletin loop, foreman cut over).

Do Phase 1 + Phase 4 (the endo side):
- **Phase 1:** generate `endojs/endo-but-for-bots:llm` `designs/README.md` as a
  NON-AUTHORITATIVE redirect — a courtesy pointer for human readers to journal/plan/,
  generated from the journal records (a short header + a link + the table), clearly
  marked "generated; do not edit; source of truth is the garden journal plan." Add a
  small generator (scripts/jobs/plan/render-endo-redirect.sh) and decide whether the
  weekly job regenerates it. Kept INDEFINITELY per the design.
- **Phase 4:** replace the synchronization section of endo `designs/CLAUDE.md` with a
  pointer to journal/plan/ and the reconciler (the manual table-sync discipline is
  retired). Endo designs/ narrative is now mirrored from the journal record bodies.

Bounds: bot identity; endo-but-for-bots is a bot-pushable fork (push to its `llm`
branch directly, no PR needed for the redirect/courtesy file per the design). Verify
the redirect renders from the records and matches the live roadmap. Report SHAs.
