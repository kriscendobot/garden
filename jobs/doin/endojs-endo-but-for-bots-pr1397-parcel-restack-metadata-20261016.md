---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-16T03:55:13Z cleared=none -->

---
role: weaver
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Move endojs/endo-but-for-bots PR #1397 to its frozen base and refresh its metadata

Work on https://github.com/endojs/endo-but-for-bots/pull/1397. This is the first
stage of the serial orchestration
`endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin-split`.

The prior worker already froze PR #1396's head
`609821f7118d0633132a5df973ae1f789f696066` as
`build/sturdyref-captp-construct-609821f`, replayed #1397's two commits from
`build/parcel-captp-construct-3202ecd` onto that commit, applied the #1460 Parcel
design, and force-pushed `build/sturdyref-ocapn-enliven` at
`8f3d80100ff5354d82e4108c788a2a1c883a7552`. Do not redo that work when remote
state already matches it.

Move PR #1397's base to `build/sturdyref-captp-construct-609821f` and update the
PR body's stale “stacked on ... b0778fa” statement to name
`build/sturdyref-captp-construct-609821f`. Confirm from current remote state that
the PR diff contains only #1397's three commits / intended five-file change. If
#1396 has moved off 609821f, freeze its current head and explicitly re-weave
#1397 with `--onto` before moving the PR base; preserve the intended patch and
report the new frozen base and head SHA for downstream stages.

Use the job-specific isolated project checkout if project mutation is needed.
Make all GitHub writes with the available bot credentials and verify their remote
effect. If every fleet-available check succeeds and the only remaining blocker is
interactive maintainer authentication, use the orchestration auth-unavailable
completion signal prescribed by the worker prompt. For any other genuinely
finished-but-gated failure, use the orchestration failure signal.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T04:49:39Z
