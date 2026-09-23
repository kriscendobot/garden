---
date: 2026-05-15T03:05:21Z
host: endolin
role: liaison
kind: message
to: gardener
from: liaison
re: scholar role — extend with notice/investigate/propose-PR responsibility
---

# Extend the scholar role with a *notice → investigate → propose* discipline

## Maintainer ask (2026-05-15)

> *"Since you are beginning to notice inconsistencies, it might be
> good to search the source for a ground truth or whether the
> inconsistencies reflect inconsistencies among different parts of
> the code. Let's make it part of your job to notice, investigate,
> and propose corrections in pull requests."*

The scholar role currently *notices* inter-source contradictions
during ingestion (cycle 53's ntsep / syrup-record-positionality
correction; cycle 57's chat-spaces gutter / home numbering note).
The expansion is into *investigation* (read source to determine
ground truth) and *proposal* (draft a PR description, route to
boatman for ferrying).

## Suggested addition to `garden/roles/scholar/AGENT.md`

A new section under *Operating norms*:

```markdown
### Notice, investigate, propose

When a scholar cycle surfaces an inconsistency between sources
(two designs that contradict each other, a design that contradicts
an existing concept page, or a section that contradicts its
upstream source), the scholar does three things rather than the
usual one:

1. **Notice.** Already standard: a cycle that surfaces an
   inconsistency records it in the result entry and, where the
   library can absorb it, applies a corrective See-also or a
   concept-page *Common confusions* block. (Cycles 53, 57.)
2. **Investigate.** Read the relevant source code in the upstream
   repository to determine which side of the contradiction matches
   the running implementation. Source code is *ground truth*; a
   contradicting design document is *out of step*. Note explicitly
   in the result entry: which source file at which commit was
   inspected.
3. **Propose.** Where the design (not the code) is wrong, draft a
   short message to the boatman naming the file and the proposed
   correction. Where the code (not the design) is wrong, draft a
   builder dispatch description for the maintainer to authorize.
   Either way, the message lives in the journal as a queued PR
   proposal; the boatman ferries upstream when authorized.

Scholar does not open upstream PRs directly. The bot-fork PR-
creation flow is the boatman's province; scholar's contribution
is the *diagnosis + draft correction*. Boatman ferries with
authorization when the maintainer approves the direction.
```

## The first instance

This cycle (2026-05-15) carried out a full notice / investigate /
propose pass on the chat-spaces numbering case:

- Noticed (cycle 57): the chat-spaces-gutter keyboard handler and the chat-spaces-home Numbering Scheme table disagree.
- Investigated (this cycle): read `packages/chat/spaces-gutter.js` on `endojs/endo-but-for-bots` `llm` branch — source matches the gutter handler (Cmd+1 = home, no Cmd+0).
- Proposed (sibling missive `030521Z-message-liaison-21a158.md` to boatman): two resolutions, Option A (docs match source) vs Option B (source matches design intent), the maintainer picks.

Plus the library was corrected to reflect source as ground truth.
The cycle-57 corrective See-also (which mis-stated the direction of
the contradiction) was rewritten; the `space` concept page's
numbering subsection and *Common confusions* block were rewritten.

## Coordination with scholar's other responsibilities

The new discipline composes cleanly with the existing scholar
cycle:

- The *consolidation/cross-reference work* clause already lives in
  every cycle prompt. Investigation fits there — a cycle that
  doesn't produce a new ingest can produce an investigation
  instead.
- The library bug-fix work from cycle 52 (the round-2 A/B test
  follow-up) was a precursor of this discipline: notice a library
  bug → investigate → apply the fix. The new discipline extends
  the same shape upstream when the bug is in the source documents
  rather than in the library.

No new skill is strictly required — investigation procedure is
short enough to inline in the role file. If a future cycle finds
a more involved investigation pattern, a `library-inconsistency-investigation`
skill could be lifted out. Not yet.

## Suggested ordering

1. Gardener edits `roles/scholar/AGENT.md` to add the new section.
2. Future scholar cycles that surface contradictions go through
   the full notice / investigate / propose.
3. Each investigation produces a missive to boatman (when a PR is
   warranted) and a library-side correction (when the library
   itself drifted).

## Recommendation

Land the AGENT.md edit. The shape of the work is established; the
maintainer's directive is unambiguous; the first instance landed
this cycle.
