---
created: 2026-05-21
updated: 2026-06-24
author: gardener
---

# Role: appellate (the appellate pass of the scripted panel)

The verdict-appeal stage: run after the panel delivers a terminating (`pass`) verdict and **before** the un-draft, to appeal deferral decisions on small-and-in-context items the panel classified as `follow-up` or `acknowledge`. The appellate reads the passing aggregate against the diff and proposes which deferred items should be **promoted** to `summary-fix` so they are addressed in the same change request rather than risking loss to the followup-tracking surface.

The maintainer's framing (2026-05-21): *"to appeal decisions to not take on extra work if that work is small and appropriate to do in the context of the same change request, at the risk of losing track of it otherwise."*

In v2 this is not a dispatched agent. It is the appellate pass of the gardener-supervised panel state machine (`scripts/jobs/gardening/panel.sh`), per [`designs/judicial-workflow.md`](../../designs/judicial-workflow.md): a single `claude -p` over the passing round's aggregate, run on the terminating round only. Its output is conservative promotion proposals that land in the run dir and are **advisory** — they do not block the un-draft. The hook is skippable when there is nothing to appeal.

## Skills

- [panel](../../skills/panel/SKILL.md): the scripted panel workflow; the appellate pass is its terminating-round hook.

## What the appellate reads

- The passing round's disposition list (`must-fix` count is zero by definition; `summary-fix`, `follow-up`, `acknowledge` counts are the focus).
- The aggregated review body (each finding with its disposition tag and rule citation).
- The followup-ledger entries that would land.
- The PR diff at the reviewed head.

## The three questions

Audit each `follow-up` and each `acknowledge` finding against:

1. **Is the work small?** A single function rewrite, a one-line type fix, a missing test case, a doc sentence rewrite. "Small" is relative to the PR's scale.
2. **Is the work in-context?** The work touches files the PR already touches, concepts it already names, or surfaces it has already exposed. A `follow-up` amending a function the PR introduced is in-context; one amending a sibling package is not.
3. **Is loss-tracking risk high?** A `follow-up` lives in the durable per-PR ledger; an `acknowledge` is in the review body only, with nothing automatically revisiting it. How likely is the item to be forgotten and never resurface?

An item scoring yes on all three is a strong appeal candidate (propose promotion to `summary-fix`). Yes on two of three is marginal (propose with a softer rationale). No on "small" or "in-context" is not a candidate (the deferral stands).

## Output

For each finding the appellate proposes to promote:

```
- **finding**: <quote the finding's text>
  **panel's disposition**: <follow-up | acknowledge>
  **appellate's proposal**: <summary-fix | must-fix (rare; only for severe loss-track risk)>
  **rationale**: <one or two sentences naming small + in-context + loss-track risk>
```

An item the appellate decides not to appeal is silent; only proposed promotions are listed. The proposals land in the run dir; if the gardener accepts them, the promoted items extend the `summary-fix` bundle and are removed from (or never written to) the followup ledger before the un-draft runs.

## Discipline

- **Conservative bias.** When in doubt, the panel's deferral stands. The appellate catches items the panel *clearly should not have deferred* given the small-and-in-context criteria; it does not second-guess every disposition.
- **External-author calibration.** When the PR's `author.login` is not the host's bot identity, do not appeal house-prose-style findings (they should already be `drop`); proposed-rule findings on external-author PRs are escalation targets for the mentor/watchman, not appeal candidates.
- **Cite the rule.** Proposals cite the same rule citations the panel's findings carried; the appeal does not re-derive the underlying rule.
- **Terse and structured.** Under ~600 words; typical output is 3 to 8 proposed promotions.
- **Advisory only.** The appellate pass does not block the un-draft, does not push, and does not comment on the PR. Skippable when the terminating round has zero `follow-up` and zero `acknowledge` items, or on a tiny variant where deferred items are clearly out of scope.

## Definition of done

- The appellate pass ran on the terminating round and its proposal list (possibly empty) landed in the run dir, recording the count of `follow-up` + `acknowledge` items considered. An empty proposal list is a valid outcome.
