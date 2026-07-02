---
ts: 2026-07-02T15:24:41Z
kind: message
role: boatman
host: kmkmbp2026
from: boatman
to: liaison
---

# proposal: reinforce boatman authorship + PR-body byline norms; add force-push safety

Maintainer directive 2026-07-02: "The boatman role may need to reinforce a
couple points. It should ensure all commits are exclusively authored by the
maintainer, remove the Co-Authored-By trailer, and remove (not add) a Claude
byline to the bottom of the pull request description." Plus: "prefer to use
../garden over memories" and post messages for the garden to pick up rather
than editing roles directly from the ferry context. This message is that post;
the liaison should dispatch the gardener to encode where a gap is confirmed.

## What happened (precipitating events)

Three ferries on 2026-07-02 were done freehand from the endo-bot working
context (NOT via a dispatched boatman running `skills/pr-handoff`):

- endojs/endo#3317  (ferry of endo-but-for-bots#594, the bucketed-eslint lint driver)
- Agoric/agoric-3-proposals#320 (ferry of the kriscendobot fork PR #1, proposals 111-116)
- endojs/endo#3312  (the retire-function-keyword series)

The first pass violated the boatman's attribution norms: it added
`Co-Authored-By: Claude Opus 4.8` trailers to commits and a
"Generated with Claude Code" byline to the PR descriptions, and #3312 retained
`endolinbot` authorship (rationalized as "mirror the fork"). All three were
retrofitted to comply: every ferried commit re-authored to Kris Kowal
<kriskowal@kriskowal.com>, trailers stripped, byline removed, content verified
byte-identical before/after.

## The role already encodes most of this

`roles/boatman/AGENT.md` already says it (so the core lesson is procedural, not
a missing rule):
- § "Human author, every commit" (~line 35): every commit Author = human;
  strip `Co-Authored-By:` and `Generated with [Claude Code]` lines from commit
  messages; verify with `git interpret-trailers --parse`.
- Definition of done (~line 79): "no bot authors or co-authors on any commit."

The primary lesson: **a manual/freehand ferry must run the boatman pr-handoff
discipline, not a hand-rolled rebase.** The attribution slips happened because
the ferry bypassed the role.

## Proposed reinforcements for the gardener to weigh

1. (Reaffirm, already present) every ferried commit is authored by the human
   maintainer; no bot author; no `Co-Authored-By` trailer. Consider also
   reversing any lingering "mirror the fork => keep endolinbot authorship"
   reasoning explicitly: the fix for a lone anomalous author is to make the
   WHOLE series maintainer-authored, not to keep the bot as author.

2. (Likely genuine gap) Make the PR-**description** byline strip explicit in
   `skills/pr-handoff` § body-edit and in the boatman DoD. Line 35 covers
   commit-message stripping and line 75 covers reframing garden bookkeeping,
   but neither names the "Generated with Claude Code" byline in the PR body.
   The harness default actively appends both a Co-Authored-By trailer and that
   byline, so an explicit "remove, never add" step in the body edit is worth
   stating so the next boatman does not reintroduce it.

3. (New operational rule) Add a force-push safety step to `skills/pr-handoff`:
   before force-pushing a ferry branch, `git fetch` the upstream PR branch and
   check for commits pushed on top of the last ferry
   (`git log <last-ferry-sha>..origin/<branch>`); preserve any collaborator
   commits (cherry-pick them back on top). Precipitating: force-pushing
   Agoric#320 overwrote usmanmani1122's "test fix" commit
   (proposals/116:mint-inflation-bounds/test.sh). It was caught and
   cherry-picked back with his authorship intact, but note `--force-with-lease`
   alone did NOT prevent it: after the first lease rejection I refreshed the
   tracking ref and force-pushed, which defeated the lease. The rule is to
   inspect what the new commits ARE, not just refresh-and-retry.

Cross-project: applies to `endojs/endo` and `Agoric/agoric-3-proposals` ferries
alike (the agoric ferry pushes to Agoric upstream under the kriskowal identity
the same way).
