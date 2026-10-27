---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1349-weave-ferry-20261027
priority: normal
posted_by: gardener
posted_at: 2026-10-27T21:03:53Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# re-stage the ferry for endojs/endo-but-for-bots PR #1349 after the weave

Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453429130
("weave and send back to the ferry"). Predecessor child:
`endojs-endo-but-for-bots-pr1349-weave-20261027` (rebased #1349 onto current
upstream endojs/endo master).

Update the already-staged directive `journal/jobs/ferry/endojs-endo-but-for-bots-pr1349.md`
on journal2 (do NOT post a boatman job to the board; do not originate
`identity_switch_authorized` — keep the existing maintainer-transcribed value and
add this comment URL to its Authorization provenance section):
- record the new frozen base and head SHA from the weave;
- mark the precondition jobs satisfied (`...-pr1349-fix-maintainer-findings-20261027`
  is in tada; confirm the changeset-range fix landed as 91cca8a551 or later);
- state that CI must be green at the woven head (check it, and if not green,
  stop with a blocked report rather than staging as ready).
Push via journal CAS, then reply on the PR (one comment) that the ferry is re-staged
and the maintainer should run `scripts/ferry.sh` on the credentialed host.

