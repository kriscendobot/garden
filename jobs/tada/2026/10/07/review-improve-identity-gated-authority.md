Completed and pushed commit `2782d6294d8` to `main2`; closed review-miss cluster `identity-gated-authority`.

- Added builder and designer rules requiring transferable, attenuable capabilities for per-action authorization. Identity remains valid for authentication, accounting, and billing; existing identity-gated siblings must be flagged, not copied.
- Added the locksmith finding: “Identity-keyed authorization is the third recurring locksmith finding.”
- Extended `C-locksmith.sh` to detect identity equality, caller allowlists, owner helpers, and identity-titled rejection tests.
- Added a 10-case regression test and panel-routing coverage.

Re-litigation for `kriscendobot-minion.town-pr85-review-9f17a419`:

- Builder check: “In an object-capability codebase, authorize each action by possession, not identity.”
- Probe: `skills/panel-hints/probes/C-locksmith.sh`.
- Seat check: “Identity-keyed authorization is the third recurring locksmith finding.”
- The fetched historical `ce9a8dc7206` diff produced `fire locksmith identity-keyed authorization signal: owner-gated`; the faithful `record.owner !== owner` fixture also fired.
- All 10 probe-test scripts passed; ShellCheck and `git diff --check` completed cleanly.

Follow-ups: none.

Self-improvement: nothing beyond the requested prevention and sensing changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-identity-gated-authority.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 466s

<!-- garden-usage-end -->
