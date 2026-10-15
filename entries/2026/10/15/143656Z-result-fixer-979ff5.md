---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-10-15T14:36:58Z
job: endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922-expanded-window
claim: eac29038d27187fb
---
Restacked endojs/endo-but-for-bots PR #1393 onto PR #1392's execution-time exact head `65391dffbc29fd6cdf7a4e2c949f50ae9b10b5e1`, published frozen base `build/sturdyref-pass-style-recognition-65391df`, and lease-force-pushed final head `6976bb0ee56928c3264f46a6b1f2ab0397ef10a7`.

Applied the accepted Parcel marshal design: Parcels encode inline in CapData and Smallcaps without consuming ordinary live slots, and marshal construction uses privileged location encoding plus endpoint-specific decoding/open callbacks. Preserved the 28-commit topic history through an explicit `--onto` rebase and resolved conflicts against both parent histories.

Validation passed for affected marshal and patterns tests, package lint, marshal type tests, repository type build/tests, all nine no-auto-fix pre-push probes, pinned-base validation, and exact-head GitHub CI (35 terminal checks, zero pending or failing): https://github.com/endojs/endo-but-for-bots/actions/runs/38746827426

`yarn docs` required an 8 GiB heap and then reported 102 pre-existing errors in unrelated packages; the marshal declaration migration introduced warnings only. Posted the required PR summary at https://github.com/endojs/endo-but-for-bots/pull/1393#issuecomment-6194645349 and notified the PR #1394 successor worker of the exact new head.

Self-improvement: nothing this time.
