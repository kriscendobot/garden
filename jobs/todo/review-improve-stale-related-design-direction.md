---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# review-improve: stale related-design direction

Cluster `review-misses/clusters/stale-related-design-direction.md` crossed the
single-major severity floor with one member:
`review-misses/misses/kriscendobot-minion.town-pr48-review-b8fd1e6b.md`.

On kriscendobot/minion.town PR 48, the build and four code-panel rounds proceeded
after the maintainer had already requested a fresh architecture on related design
PR 47. The build asserted that its serving slice was independent without
reconciling the current PR 47 review. The panels then reviewed local correctness
but never caught that the implementation seam had become stale. The maintainer
closed PR 48 for reconstruction after PR 47.

Deliver BOTH halves below. A completion that delivers only one is incomplete.

## (a) Prevention

Make current related-design state a hard build-preparation input. Strengthen the
narrowest producing artifacts, including `skills/design-dependency-walk/SKILL.md`
and the builder path that consumes it, so a build cannot declare a slice
independent based only on a design document or stale report. It must discover
related open design PRs, re-fetch their current reviews and head state, and either
show that the proposed implementation still composes with every outstanding
maintainer direction or stop/redirect behind the dependency. Prefer a
deterministic helper at the build/panel boundary for the discoverable state and
leave only the semantic composition judgment to the agent.

## (b) Durable review-cycle sensing

Add a durable check before a code panel can clear or repeatedly re-panel an
implementation whose declared or discoverable related design PR has newer
changes-requested direction. Prefer a deterministic panel-stage check that
compares timestamps and current review state, records the related PR evidence,
and forces the integrator lens when semantic judgment remains. If the full signal
cannot be mechanized, amend `roles/jurors/integrator/AGENT.md` with an explicit
current-related-design reconciliation check and add a matching panel-hints probe
in the same commit. The check must fire toward review, not silently infer
independence.

## Re-litigation test

Demonstrate the new prevention and sensing against the historical member. Use
the real PR 47 and PR 48 timestamps and relationship: PR 47 review 4955373305 was
submitted at 2026-08-17T23:22:53Z; PR 48's first commit followed at
2026-08-18T00:38:55Z; all four PR 48 panel rounds came later. Name the exact
build-time check that would have stopped or redirected PR 48 and the exact
panel-time check that would have prevented each later round from clearing the
dependency question. Include a negative control where an unrelated or satisfied
design PR does not block the build.

Close the cluster only after both halves and this test land:

```
scripts/jobs/review-miss-record.sh cluster-status stale-related-design-direction closed \
  --improved-by "<commits/files changed>"
```

Self-improvement: nothing this time.
