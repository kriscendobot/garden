---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-16T04:34:14Z
---
refs: endojs-endo-but-for-bots-pr671-review-3fa7398f-retro, endojs/endo-but-for-bots#671:review:4690597350:retro

# Review-retrospective — endojs/endo-but-for-bots #671 review 4690597350 (prosecutor)

Wore the prosecutor role over kriskowal's CHANGES_REQUESTED review on #671. The
retro-relevant comment (discussion_r3575900598) is "Avoid abbreviation." on the
`fetchImpl` parameter in the new `registry-node-backend.js`.

**Verdict: MISS** (category `naming`), recorded at
`review-misses/misses/endojs-endo-but-for-bots-pr671-review-3fa7398f.md`. Joins the
`avoid-name-abbreviations` cluster → count=4, prs={650,609,671}, **recurrence=1**
(the cluster was `closed`; recording reopened it).

**Grounds.** `fetchImpl` is a plainly-abbreviated identifier in freshly-authored
panelled code; `impl` is literally on the deployed `spell-out-identifiers.sh`
gate's blocklist (verified: it fails when scanned directly). The gate + stylist
never-abbreviate brief deployed to this PR's host (endolin-garden2-5bcdff64) at
2026-07-11 02:11Z; the 19-seat panel ran ~12.5h later (14:42Z) with the check in
force and still let it through.

**Why it recurred (real cause).** The `fetchImpl` line was authored ~3h BEFORE the
gate existed. The pre-push gate scans only NEWLY-ADDED diff lines, so on every
later push the unchanged pre-existing line is invisible to it — a structural
added-lines-only blind spot. That left the probabilistic stylist seat as the sole
net for pre-existing lines, and it missed this one identifier.

**Threshold call: HELD, escalated (no second improvement round auto-dispatched).**
Per skills/review-retrospective § 6, a recurrence into a closed cluster escalates
to the maintainer rather than autopiloting a second round. Messaged kriskowal (via
the liaison) laying out the added-lines-only blind spot and the three fix options
(widen the gate to whole-file scan vs. accept the stylist seat as sole net for
pre-existing lines vs. treat as expected pre-deployment fallout) — his judgment
call. The gate is not broken for the lines it is designed to see.

Self-improvement: none warranted this job; the retro loop and store writer
behaved exactly as designed and the discrimination was well-grounded in the PR's
deploy/panel timeline.
