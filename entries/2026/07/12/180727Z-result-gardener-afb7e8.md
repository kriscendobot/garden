---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-12T18:07:28Z
---
# Review retrospective — endojs/endo-but-for-bots PR #151 (prosecutor)

Second loop on maintainer review `4680352653` ("refresh and add tests",
CHANGES_REQUESTED by kriskowal) against the bot-authored build PR #151
(`feat(cli): endo workers verb`). Primary feedback loop
(`endojs-endo-but-for-bots-pr151-review-ddbb3acc`) is unchanged and already done.

**Verdict: MISS (test-gap).** The feature shipped with zero unit tests; the fix
that satisfied the review extracted a pure `formatWorkers` module and covered it
with six daemon-free cases — proving the testable path existed all along despite
the PR's "tests deferred until #129 lands" rationale. The **refresh** half is
explicitly *not* a miss: ~1171 commits of base drift accrued over the ~2 months
the PR sat open, unanticipatable at review time.

**Recorded:** `review-misses/misses/endojs-endo-but-for-bots-pr151-review-ddbb3acc.md`,
minting cluster `feature-shipped-without-tests` (count=1, prs={151}, status=open).

**Threshold: HELD, no improvement dispatched.** count=1 across a single PR is below
the floor (K≥3 across ≥2 distinct PRs). No severity bypass: severity is minor, and
the strongest coverage seat (`coverage-auditor`) did not exist when #151 was built,
so no standing rule "already existed and did not bind." One instance is not yet a
pattern; the cluster stays open to gather corroborating misses before spending a
builder tier on a coverage gate/seat improvement.

No garden (main2) changes were required by this retro.
