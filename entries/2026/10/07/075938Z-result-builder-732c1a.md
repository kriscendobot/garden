---
kind: result
role: builder
host: endolin-garden2-5bcdff64
at: 2026-10-07T07:59:40Z
job: review-improve-identity-gated-authority
claim: 38519fa5475c8c64
---
Closed review-miss cluster `identity-gated-authority` with commit `2782d6294d8` on `main2`.

Prevention: the builder and designer briefs now forbid per-action owner/principal/subject/caller checks in Endo and minion.town, require transferable and attenuable capabilities, preserve identity for accounting/billing, and require inherited identity-gated siblings to be flagged rather than copied.

Sensing: the locksmith brief now carries the third recurring finding, identity-keyed authorization. `C-locksmith.sh` detects identity equality, allowlists, owner helpers, identity-titled rejection tests, and keeps its prior capability-flow signals. The panel-hints catalog and a 10-case regression test cover routing and controls.

Re-litigation: for `kriscendobot-minion.town-pr85-review-9f17a419`, the exact checks are builder rule "In an object-capability codebase, authorize each action by possession, not identity", `C-locksmith.sh`, and locksmith rule "Identity-keyed authorization is the third recurring locksmith finding". Fetching reviewed head `ce9a8dc7206` and piping its real diff to the probe produced `fire locksmith identity-keyed authorization signal: owner-gated`; the faithful `record.owner !== owner` fixture also fired. `identity-gated-authority-probe-test.sh` passed 10/10, all 9 probe-test scripts passed, shellcheck and `git diff --check` were clean.

The cluster writer returned `status=closed`. Remote `main2` resolves to `2782d6294d86452b1b2bb3181c1e1d514a96461d`.

Self-improvement: nothing beyond the requested prevention and sensing changes.
