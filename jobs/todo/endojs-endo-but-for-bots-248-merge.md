---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge endojs/endo-but-for-bots PR #248

Design-only PR `design(ses,module-source): import-attributes proposal`
(adds `designs/ses-import-attributes.md`; updates `designs/README.md`).

APPROVED by @kriskowal (review 4943023549). All review asks resolved:
- The single directive — "post a plan to build this at the foreman's leisure" —
  is satisfied by the parked plan job `endojs-endo-but-for-bots-248-build-ses-import-attributes`
  (journal `jobs/plan/`). No inline comments were tied to the review.
- The PR was CONFLICTING on `designs/README.md`; rebased onto `origin/llm` and
  force-pushed (head now 3748badbd). PR is MERGEABLE / mergeStateStatus CLEAN,
  not draft, all checks green (build, lint, test, browser-tests, zizmor pass).

Finalize and merge into `llm`. You own the merge method. Bot repo — merging is
in scope. Do not touch agoric-sdk or endojs/endo upstream.

Review: https://github.com/endojs/endo-but-for-bots/pull/248#pullrequestreview-4943023549
