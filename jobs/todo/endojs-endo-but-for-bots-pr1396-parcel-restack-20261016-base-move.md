---
role: shepherd
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-16T05:09:17Z cleared=none -->

---
role: shepherd
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Move endojs/endo-but-for-bots PR #1396 to its frozen Parcel base

This is the first serial child of
`endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split`.

The source restack is already complete. Do not redo it and do not change project
source. The PR head was force-pushed as
`build/sturdyref-captp-construct` at
`609821f7118d0633132a5df973ae1f789f696066`; its intended frozen base is
`build/sturdyref-captp-wire-6f3185b`, which points to
`6f3185b487c9ac92974533e9f50054d544db0f26`.

Using the bot credentials available on this required host:

1. Change https://github.com/endojs/endo-but-for-bots/pull/1396 to base branch
   `build/sturdyref-captp-wire-6f3185b` (`gh pr edit` or the REST API).
2. Read the PR back from GitHub and confirm the base ref/SHA and head ref/SHA.
3. Confirm that the PR comparison contains only the one rebased #1396 commit,
   rather than any commits already carried by the frozen base. Record the commit
   and file-level comparison evidence in the completion report.

If the gated outcome cannot be achieved, finish with the orchestrated-failure
signal. If every fleet-available check is complete and the sole remaining barrier
is interactive maintainer login/MFA, use the orchestrated-auth-unavailable signal
instead.
