---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr604-review-f2d21a00
verdict: not-a-miss
category: new-direction
pr: 604
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/604#pullrequestreview-4629268314
identity: endojs/endo-but-for-bots#604:review:4629268314:retro
producing_role: none-externally-authored-pr-garden-reviewed-later-cleanly
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kumavis's review 4629268314 on the @endo/privacy-cards PR, and concludes it
  could not have — the sibling review 4629268296 was already dismissed by a peer
  on identical grounds, which explicitly flagged that "the sibling review
  4629268314 is the same shape (a reply confirming the pause/resume-mutex fix)."
  Three dispositive facts from the PR's actual history. First, the garden did NOT
  author this PR: it was authored by @kumavis (via Claude Code, head branch
  claude/privacy-api-daemon-formula-5cpy3w), so the prosecutor loop's premise —
  maintainer feedback on a garden work product the garden's review should have
  caught — does not apply. Second, the retro'd surface is not maintainer feedback
  indicting the garden at all: review 4629268314 carries an EMPTY body and a
  single inline comment (id 3522923247 at account.js:306) that is @kumavis's own
  reply to a Copilot-bot finding, declaratively CONFIRMING an already-landed fix
  ("Confirmed and fixed in 13a59695: setOwnCardState (pause/resume) is now
  serialized through the mutation mutex…") that closed a resume-vs-revoke race on
  card state. Third, and decisively, the race was found by the COPILOT reviewer
  and fixed by kumavis in commit 13a59695 BEFORE the garden panel ran — the
  primary job (endojs-endo-but-for-bots-pr604-review-f2d21a00, now in tada/)
  independently verified that 13a59695 is an ancestor of head (status ahead,
  behind_by:0), that setOwnCardState IS wrapped in mutate(async () => {…}) at
  head with both pauseCard/resumeCard routing through it, and that the regression
  test "a resume racing revocation cannot undo it" exists at account.test.js:417.
  The garden gauntlet/panel (kriscendobot review 4629912929, posted 16:12) thus
  reviewed the ALREADY-FIXED code and independently verified the capability-
  security core sound (budget-escrow invariant holds, no guest-reachable budget
  escape, confinement and crash-safety intact) while surfacing its own six
  distinct should-fix items — so there was no prior garden review that failed to
  catch this race and nothing for a seat or gate to have sensed. This is a
  maintainer-authored confirmation of a Copilot finding on externally-authored
  code — new direction / non-garden surface — not a garden review-process miss.
  Recorded as a durable dismissal so the same comment is never re-litigated. No
  cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #604 review 4629268314 (retro)

kumavis's review 4629268314 on the @endo/privacy-cards PR has an empty body and
one inline comment that is his own reply confirming an already-landed fix
(13a59695, serializing setOwnCardState pause/resume through the mutation mutex to
close a resume-vs-revoke race) to a Copilot-bot finding. Not a garden
review-process miss: the garden did not author this PR (@kumavis did, via Claude
Code), and the surface is a maintainer confirmation of a Copilot finding, not
feedback indicting the garden. The race was caught by Copilot and fixed by kumavis
in 13a59695 before the garden panel even ran (16:12); the panel, when it ran,
reviewed the already-fixed code, independently verified the budget invariant and
crash-safety sound, and surfaced its own distinct findings. Same shape as the
already-dismissed sibling review 4629268296 (consumedCents overdraw undercount).
Maintainer confirmation of an external reviewer's finding on externally-authored
code — new direction, not a miss. See comment_url for the verbatim review.
