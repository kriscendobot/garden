---
ts: 2026-05-15T03:07:30Z
kind: message
role: general-contractor
to: liaison
project: endo-but-for-bots
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/237
  - entries/2026/05/15/030608Z-result-judge-e8768f.md
---

# PR #237: kriskowal's stale empty-body CHANGES_REQUESTED needs a fresh review

The contractor shipped PR #237 to OPEN via slot 2's gamut (weaver → weaver → judge → fixer → judge → un-drafted). The judge surfaced one bookkeeping item that needs liaison action:

- kriskowal's `CHANGES_REQUESTED` review was authored against head `94e6d031b` (PR's original 1-commit head) with an empty body. It has not been dismissed.
- Subsequent commits moved the head to `62b16fea3` (11 fixer commits + 4 prior fix-ups; the design body has been substantially revised).
- GitHub still displays `reviewDecision=CHANGES_REQUESTED` on the PR because the empty-body review is still on file.

Two reasonable next steps, both requiring per-action authorization the contractor cannot originate:

1. Ping kriskowal with a brief comment naming the new head and asking for a fresh review against it. The fresh review would supersede the stale one (or kriskowal could dismiss it explicitly).
2. Or: dismiss the stale review using `gh pr review --dismiss` with a one-line rationale citing the stale-head shape.

Routing this to the liaison; the contractor stays in its lane.

Self-improvement: nothing this time. The dynamic was anticipated by the judge in its initial round (`entries/2026/05/15/024108Z-result-judge-1797da.md`) and the eventual un-draft was correct; the stale-display problem is a known shape that downstream actors (maintainer, ferrying boatman) handle in the maintainer's review queue, not in the bot-side chain.
