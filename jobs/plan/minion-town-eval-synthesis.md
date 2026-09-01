---
gate: blocked
blocked_on: minion-town-eval-campaign
priority: normal
role: designer
handler-timeout: 10800
posted_by: design-minion-town-eval-campaign
posted_at: 2026-09-01T19:38:13Z
---

# Synthesis: minion.town guest-surface documentation findings → design

You are the converging step of the `minion-town-eval-campaign` orchestration.
This job was parked `blocked_on` the orchestration record itself: the unblock
watcher promoted you because `jobs/tada/minion-town-eval-campaign.md` (the
orchestration's outcome summary) now exists. All eight evaluations are
terminal — some may have failed; a failed evaluation is evidence, not a gap
in your inputs.

## Inputs

Read, from the journal's `jobs/tada/`:

- `minion-town-eval-campaign.md` — the outcome summary with per-child
  dispositions; treat it as your index and note any child marked failed.
- The eight child reports: `minion-town-eval-static-publish`,
  `minion-town-eval-namestore-durability`,
  `minion-town-eval-odometer-counter`, `minion-town-eval-guestbook-tally`,
  `minion-town-eval-sandbox-boundary`, `minion-town-eval-site-lifecycle`,
  `minion-town-eval-mail-pair`, `minion-town-eval-error-probes` (each
  `.md`). Each carries the campaign's mandated three-part
  documentation-quality section; those sections are your raw material.

## The work

1. **Synthesize across the whole set**, not per report: what the tool
   surface makes clear from schemas alone; what is a genuine documentation
   gap (multiple reports tripped on it — cite them); what is a missing
   capability rather than a documentation problem (e.g. if the dynamic-state
   or two-guest evaluations found the surface cannot express the task at
   all); and what the error-message catalog says about errors as a
   documentation channel. Distinguish "the description was wrong" from "the
   description was silent" from "the capability does not exist."
2. **Author a design** proposing concrete, evidence-backed improvements —
   better tool descriptions/schemas, missing capabilities worth adding,
   specific error-message rewrites — aimed at `kriscendobot/minion.town`,
   `endojs/endo` (via the garden's fork conventions), or both, whichever the
   findings actually implicate. Wear the designer role:
   `roles/designer/AGENT.md` and the garden's usual design-to-PR conventions
   govern where the design lands and how its PR is opened. Every
   recommendation must cite the evaluation evidence (child report + the
   verbatim observation) that supports it; propose nothing the campaign did
   not observe.
3. If any child's findings amount to a reusable operational recipe (as the
   campaign's precursor produced `skills/minion-town-mcp-playwright-login`),
   note candidate garden skills in the design's appendix — do not author
   them here.

## Definition of done

The synthesis is complete when the design PR(s) against the implicated
repo(s) are OPEN (not merged) and your completion report links them. If the
campaign's evidence genuinely supports no change — every finding already
clear, every gap already known — say so explicitly with the citations, and
complete without a design PR; that conclusion also requires the evidence.
