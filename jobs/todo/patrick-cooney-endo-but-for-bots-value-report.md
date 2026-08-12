---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots

# Follow-up report: Patrick Cooney's contribution VOLUME and VALUE, to substantiate payment

This builds directly on the completed report at
`jobs/tada/patrick-cooney-endo-but-for-bots-contributions-report.md` — read
it first and use its identity finding (`0xpatrickdev`, corroborating
evidence already established) and its inventory (113 attributable commits,
109 formally-reviewed PRs across 188 submitted reviews, the thematic
clusters) as your factual base. Do not re-derive the identity or re-run the
full discovery from scratch; extend it.

**This report will be used to justify a real payment decision.** Its job is
to substantiate with *evidence*, not to recommend a number or advocate a
position. Never invent, round favorably, or omit an inconvenient data point.
Where data is incomplete or ambiguous (as the prior report already flagged
for force-pushed/unreachable history), say so plainly rather than filling
the gap with a guess.

## What to add, beyond the existing inventory

1. **Volume, quantified.** For his directly-authored and bot-transported
   commits: total lines added/removed (`git log --numstat` or the GitHub API
   equivalent, summed), broken out by the same thematic clusters the prior
   report already established (mount/Git-capability spine, LAL/FAE/Genie/
   agent tools, SES/Compartments, Endor/registry, OCapN, CI/hygiene). Time
   span of activity (first to most recent contribution date) — sustained
   long-term involvement vs. a short burst materially changes how volume
   should read.

2. **Comparative standing.** Compute, for `endojs/endo-but-for-bots` as a
   whole: the top reviewers by submitted-review count and the top
   committers by commit count (or lines changed) across ALL contributors —
   not just Patrick — and show explicitly where he ranks and what fraction
   of the repo's total review/commit activity he accounts for (e.g. "reviewed
   X% of the repo's Y total merged PRs"). A relative ranking is far more
   defensible for a payment decision than an absolute count with no
   context.

3. **Criticality / dependency weight.** For the mount/Git-capability spine
   the prior report already identified as his most foundational cluster
   (`#327`, `#339`, `#364`-`#371`): how much of the repo's later work
   (count PRs, or name the subsystems) actually builds on top of it? Distinct
   from volume — this is about how load-bearing the work is, which a raw
   commit count does not capture. Do the same, more briefly, for any other
   cluster that looks similarly foundational.

4. **Nature of the review authority.** The prior report characterized his
   188 reviews as showing "broad maintainer or technical-lead authority."
   Substantiate that claim concretely: cite specific examples (a handful of
   representative review comments, quoted or closely paraphrased, with
   PR links) that demonstrate gatekeeping judgment (blocking merge until a
   security/authority-boundary concern was fixed, redirecting an architecture,
   catching a correctness issue others missed) rather than rubber-stamp
   approval. Distinguish substantive reviews from light/procedural ones if
   the data supports that distinction.

## What NOT to do

- Do not propose or estimate a dollar figure, rate, or payment amount — that
  is the maintainer's decision, not this report's.
- Do not editorialize beyond what the evidence shows ("Patrick is clearly the
  most valuable contributor" is not a claim this report should make; "Patrick
  accounts for X% of reviews and authored the load-bearing Y subsystem" is).

## Deliverable

A journal report (same convention as the prior one — lands in
`jobs/tada/`, not a PR), explicitly cross-linked to the prior report rather
than duplicating its content. State plainly, in your own completion report,
the journal path and a one-line summary of the strongest evidence found.
