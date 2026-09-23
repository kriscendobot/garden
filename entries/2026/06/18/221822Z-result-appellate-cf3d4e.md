---
ts: 2026-06-18T22:18:22Z
kind: result
role: appellate
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/221301Z-result-justice-563085.md
---

# Appellate review: PR #290 post-justice r2

**PR**: endojs/endo-but-for-bots#290 `refactor(lal): adopt pi-based harness + memory internals`
**Source verdict**: justice 563085 r2 (2026-06-18T22:13:01Z)
**Aggregated verdict**: 0 must-fix-loop, 2 summary-fix, 0 follow-up, 19 acknowledge

## Items considered

**Follow-up items in ledger (1)**:

| Item | Source | Round |
|---|---|---|
| `resolveModelString` URL-parse gap (adversarial `LAL_HOST`) | saboteur | r1 |

**Acknowledge items (19)**: assessor x4, typist x2, stylist x1, packager x2, prover x1, saboteur x1, corner-prober x1, scribe x1, releaser x1, breaker x1, changeset-auditor x2, integrator x1, fast-checker x1, gateway x1.

## Appeal decisions

### Follow-up: `resolveModelString` URL-parse gap (saboteur, r1)

Three-question audit:
- Small? Yes. Narrowing one function to parse the URL and match on `hostname` rather than raw `includes`.
- In-context? Yes. `resolveModelString` is in `packages/lal/agent.js`, a file the PR directly introduces.
- Loss-tracking risk? Low. The item is in the durable per-PR follow-up ledger, which the steward revisits at merge. The ledger is the correct tracking surface.

Decision: **no promotion**. Two-of-three (small + in-context), but loss-tracking risk is low because the ledger is the designed durable surface for this class of item. Conservative bias applies; deferral stands.

### Acknowledge items

All 19 acknowledge items were reviewed. The two typist findings (loose `@returns {AsyncGenerator<object>}` on private `runAgentRound`; `resolveWaiting` typed `((value?: any) => void) | null` rather than `(() => void) | null`) are small and in-context, but both were explicitly tagged low-risk by the juror, both are private-scope, and acknowledge items carry no ledger entry. Despite the absence of a durable ledger entry, the conservative bias applies: the juror correctly assessed these as low-impact; promoting them to summary-fix would add noise to the fixer's bundle without material benefit.

All remaining acknowledge items are confirmatory (no work implied). No appeal candidates.

## Proposal list

**No promotions proposed.** All deferred items reviewed; conservative bias applied throughout.

Items confirmed silent (not appealed):
- Follow-up: `resolveModelString` URL-parse gap (saboteur, r1) -- ledger-tracked; deferral stands.
- Acknowledge (19 total): all confirmatory or low-risk private-scope observations; none meet small + in-context + loss-tracking threshold.

## Summary-fix job

The existing summary-fix job at `journal/jobs/open/20260618T221430Z--79bb38--lal-pi-290-readme-genie-refs.md` is unmodified. It contains 3 README items (archivist + integrator note bundled by justice). No amendments needed.

## Next stage

`next: fixer` -- claim the summary-fix job and address the 3 README genie-reference items in PR #290. No un-draft needed (PR was not in draft state at any point).

Self-improvement: nothing this time.
