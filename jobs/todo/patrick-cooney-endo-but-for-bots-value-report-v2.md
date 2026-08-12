---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots

# Redo: Patrick Cooney contribution VALUE report — the prior attempt under-delivered

A prior job (`jobs/tada/patrick-cooney-endo-but-for-bots-value-report.md`)
was given this exact brief and returned a 7-line completion summary instead
of the actual detailed report. It found real, useful numbers — 105 content
commits at +27,636/−4,327 lines, 27.47% of all merged PRs reviewed, 37
later-merged PRs building on the mount/Git-capability spine, one previously
undisclosed blind-spot commit on `#311` — but did not write the substantiating
detail behind any of them. **Read that report first**, and also
`jobs/tada/patrick-cooney-endo-but-for-bots-contributions-report.md` (the
original inventory) — reuse their numbers and citations rather than
re-deriving from scratch, but this time WRITE THE FULL REPORT.

**This report will be used to justify a real payment decision.** Substantiate
with evidence; never invent, round favorably, or omit an inconvenient data
point; say plainly where data is incomplete rather than guessing.

## Format requirement — this is what broke last time

**Your `tada` completion report IS the deliverable.** Write the full report
body directly into it, the same way
`jobs/tada/patrick-cooney-endo-but-for-bots-contributions-report.md` did
(that file is ~260 lines of substantive content, not a summary of content
that exists elsewhere). A short "I found X, Y, Z, done" completion note is
not acceptable here — if your own report reads like a summary rather than
the analysis itself, you have not finished the job.

## Required content, in full, in the tada body

1. **Volume, quantified and broken out.** The +27,636/−4,327 line total,
   split by the same thematic clusters the first report established (mount/
   Git-capability spine, LAL/FAE/Genie/agent tools, SES/Compartments, Endor/
   registry, OCapN, CI/hygiene). Time span of activity (first to most recent
   contribution date).
2. **Comparative standing, as an actual table.** Top reviewers by
   submitted-review count and top committers by commit count/lines changed
   across ALL contributors to `endojs/endo-but-for-bots` — not just the
   27.47% headline figure, show who else is on that list and where Patrick
   ranks among them (rank 1? rank 3? out of how many total reviewers?).
3. **Criticality / dependency weight, narrated.** The "37 later-merged PRs
   build on the mount/Git-capability spine" finding needs to be shown, not
   just asserted: name a representative sample of those 37 (or all of them
   if that's not unreasonably long), grouped by what they built (which
   subsystems depend on the spine).
4. **Representative gatekeeping reviews, quoted.** At least 5-8 concrete
   examples across the 188 submitted reviews, each with the PR link and a
   short quote or close paraphrase, chosen specifically to demonstrate
   substantive gatekeeping judgment (blocked a merge over a security/
   authority-boundary concern, redirected an architecture, caught a
   correctness issue) as distinct from light/procedural approvals.
5. **The `#311` blind-spot finding**, explained — what it is, why it was
   missed by the first pass, and its bearing (if any) on the completeness of
   the volume figures above.

## What NOT to do (unchanged from the original brief)

- Do not propose or estimate a dollar figure, rate, or payment amount.
- Do not editorialize beyond what the evidence shows.

## Definition of done

Your own `tada` report contains the full analysis above, inline, at a length
proportionate to the content (expect multiple hundred lines, not a handful) —
not a pointer to work you did but didn't write down.
