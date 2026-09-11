---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
handler-timeout: 7200

Repo: kriscendobot/minion.town

Two DRAFT PRs are built on the now-superseded "caller-supplied weblet powers"
model that the register-by-directory-id -> formula-id-origin evolution replaced:

  - https://github.com/kriscendobot/minion.town/pull/33
    (feat/weblet-user-powers-reference — guest-facet powers-pet-name resolver
    for the old weblet_publish tool; draft, unreviewed, last pushed 2026-08-23)
  - https://github.com/kriscendobot/minion.town/pull/69
    (fix(gateway): retire legacy clip powers resolution — draft, updated
    2026-09-05; plausibly the units 4-5 "retire the powers resolver" execution)

Sibling context already settled: https://github.com/kriscendobot/minion.town/pull/63
was CLOSED as superseded on maintainer direction ("Please close. This is evolving
further"), pointing at https://github.com/kriscendobot/minion.town/pull/88 and
https://github.com/kriscendobot/minion.town/pull/89 as the current model.

MAINTAINER DIRECTIVE (2026-09-11): choose ONE of #33 / #69 as the surviving
strand and close the other as superseded. Borrow the best ideas from BOTH
branches into the survivor, consistent with the review feedback each has received
so far and with the landed formula-id-origin / register-by-id clip model. Rebase
the survivor onto the current model. Note the supersession explicitly in the
surviving PR's body and in the closing comment on the other.

Procedure:
1. Read both PRs end to end, including every review thread and comment, plus the
   current clip model as landed (and as described in #88 / #89).
2. Decide which branch is the better substrate. Justify the choice in the PR body.
3. Salvage from the loser anything still load-bearing under the current model
   (the #33 report specifically calls out its guest-scoped `identify` and
   private-retention negative-isolation tests as possible salvage).
4. Rebase the survivor onto the current model; resolve conflicts.
5. Close the other PR as superseded, linking the survivor.
6. Report which survived, what was salvaged, and what was dropped.

Skills: skills/conflict-resolution, skills/review-feedback-followup-commits,
skills/rebase-before-followup, skills/fully-qualified-github-urls.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-11T22:47:56Z
