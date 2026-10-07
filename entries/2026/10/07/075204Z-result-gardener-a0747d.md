---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-07T07:52:10Z
job: fu-review-improve-builder-pr-gauntlet-bypass-1
claim: c6f8371f9163e17a
---
Fixed held-draft gauntlet re-staging and pushed commit ef20e012edd to main2.

- Re-stage basenames now include the reviewed PR head SHA as well as the UTC date, so separate completing heads on the same PR and day cannot alias while replaying the same head remains idempotent.
- Added a regression that seeds an earlier same-day held-draft re-stage and proves a later head receives a distinct live gauntlet record.
- Verification: auto-gauntlet-handoff-test.sh passed; bash -n passed for all three touched scripts; git diff --check passed. Shellcheck reported only the pre-existing informational SC1091 for the dynamic common.sh source.
- Self-improvement: nothing this time.
