from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T20:34:14Z
doom_base: split-pr1125-into-stack
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T20:34:14Z
last_seen: 2026-09-17T20:34:14Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/split-pr1125-into-stack; it stays HELD until a human promotes it
(promote-plan.sh split-pr1125-into-stack) or removes it, so nothing is lost.
Original job base: split-pr1125-into-stack

--- original job body ---
---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Split endojs/endo-but-for-bots#1125 into a stack of PRs

Maintainer directive (kriskowal, review
https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5240765072,
CHANGES_REQUESTED, 2026-09-17): "the scroll-back for review has gotten too
deep for effective review." Split PR #1125 into a stack of smaller PRs, retire
the original, run each new PR through its own gauntlet + shepherd loop, and
divide/forward the original's receipt.

## 1. Determine the actual slices

Kriskowal named three candidate areas — treat these as a strong starting
point, not a rigid mandate ("please consider that there may be reasonable
slices"):
- read-only directory attenuation
- guests inviting further guests
- introducing special and pet names to freshly created guests and hosts

Read the full diff on #1125 and map each commit/hunk to one of these (or a
better boundary if the actual dependency structure of the changes suggests
one — e.g. if "guests inviting guests" genuinely depends on the pet-naming
work landing first, that's a real ordering constraint, not just a topic
label). Document your chosen slice boundaries and rationale — this is a
judgment call the eventual PR descriptions and your completion report should
make legible to a reviewer, even though it's not a separate design doc.

If the slices have a genuine dependency order (one needs another's code to
even compile/review sensibly), stack them accordingly — `stacked-pr-build`
(skills/stacked-pr-build/SKILL.md) is the closest existing convention for
building one PR on top of another in-flight PR's head, even though it's
documented for a different trigger (a dependency-triage verdict); reuse its
mechanics (merge the dep PR's head with `--no-ff`, open against the shared
implementation base) rather than reinventing the stacking procedure. If the
three areas are genuinely independent (no compile/review dependency between
them), three separate PRs against the same base is simpler and preferable —
don't manufacture a stack order where none is load-bearing.

## 2. Retire the original, open the replacements

- Close #1125 with a comment naming and linking each replacement PR.
- Open the new PR(s), each with a description explaining what it covers and
  (if stacked) what it depends on and why.
- Initiate a gauntlet AND a shepherd loop for EACH new PR — this is
  per-PR follow-on work; since the PR numbers don't exist until you create
  them, POST THE ORCHESTRATION YOURSELF once you know them (the standing
  multi-part-work pattern: `post-plan.sh --orchestrated --orchestrated-by`
  for each child gauntlet/shepherd job, then `post-orchestration.sh`) rather
  than leaving follow-on work implicit. Parallel across the independent new
  PRs unless a stack dependency makes one block on another's merge first.

## 3. Split and forward the receipt

Read `designs/pr-completion-receipts.md` before starting this part — the
existing receipt mechanism (`cost-by-pr.sh`, `receipt-watcher.sh`,
`pr-receipt.sh`) rolls up to **merged** PRs only today; #1125 is being
**closed**, not merged, which this design explicitly does not yet cover.
You will likely need to extend or work around that gap (the maintainer
anticipated this: "this may require some additional instructions for receipt
making") — don't silently skip the receipt because the automatic watcher
won't fire on a close.

Generate #1125's receipt (every engagement/job base attributed to it, per
the existing join logic in `cost-by-pr.sh`), then divide its line items
among the new PRs by which slice each item's underlying work actually maps
to (a job that built the pet-naming code goes to that slice's PR, etc. —
judgment call, same as the code-slicing above). Post the divided breakdown
as a comment (on #1125, referencing each new PR, or split across the new
PRs directly — your call on the clearest presentation) so each new PR's
own eventual receipt (when IT merges) can incorporate its forwarded share
rather than starting from zero.

## Report

Your completion report should name: the final slice boundaries and why,
links to #1125 (closed) and each replacement PR, the orchestration(s) posted
for their gauntlet+shepherd loops, and how the receipt was split (and
whether the receipt mechanism itself needed a workaround/extension — flag
that as a separate follow-up if it's more than a one-off judgment call for
this PR).
