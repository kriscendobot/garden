---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
handler-timeout: 7200

Repo: kriscendobot/minion.town

Two open DRAFT PRs implement the IDENTICAL Part-B slice (garbage collection of
orphaned clip content), created about seven minutes apart on 2026-09-04 and
diverging only in naming and grouping:

  - https://github.com/kriscendobot/minion.town/pull/92
    "Garbage collect orphaned clip content safely"
    head build/clip-content-store-gc, base main, +914/-27 across 19 files,
    created 2026-09-04T23:11:48Z, untouched since.
  - https://github.com/kriscendobot/minion.town/pull/93
    "feat(gateway): collect orphaned clip content"
    head feat/clip-content-store-gc, base main-b83741a (pinned), +2263/-55
    across 25 files, created 2026-09-04T23:18:02Z. Carries the design doc
    designs/clip-formula-id-origin-and-content-gc.md, and has been through
    gauntlet fix-3 with panel must-fix items applied.

A panel raised this duplication as a BLOCKING must-fix on #93 that no code change
can clear: the finding is that two PRs claim one slice, not that either is wrong.

MAINTAINER DIRECTIVE (2026-09-12): choose ONE of #92 / #93 as the authoritative
surviving strand and close the other as superseded. Borrow the best ideas from
BOTH branches into the survivor, consistent with the review feedback each has
received so far and with the landed formula-id-origin / register-by-id clip
model. Note the supersession explicitly in the surviving PR's body and in the
closing comment on the other, so the panel finding is discharged on the record.

Procedure:
1. Read both PRs end to end, including every review thread, panel finding, and
   comment. #93's banked panel work is evidence, not to be discarded silently.
2. Decide which branch is the better substrate and justify the choice in the PR
   body. Weigh #93's applied panel fixes and design doc against #92's much
   smaller, more reviewable diff.
3. Salvage from the loser anything the survivor lacks.
4. Rebase the survivor; resolve conflicts.
5. Close the other PR as superseded, linking the survivor.
6. Report which survived, what was salvaged, and what was dropped.

Skills: skills/conflict-resolution, skills/review-feedback-followup-commits,
skills/rebase-before-followup, skills/fully-qualified-github-urls.
