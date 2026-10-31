PR #1560 (endojs/endo-but-for-bots) is now out of draft. Its head is still exactly `21d142af2d435a4d72594e1cc348d48262e63d8b`, the commit the panel passed.

**Pre-mutation gate:** Just before un-drafting, a fresh metadata read showed state OPEN, isDraft true, and the head matching `21d142af…`.

**Un-draft:** I ran `gh pr ready`. A second read afterwards showed isDraft false with the head unchanged.

**Advisory appellate pass:** This does not block anything. A Sonnet `claude -p` reviewer read the diff closely in the coordinator, policy, interface, type and `package.json` files. It did not read the tests, README or design doc in detail, so its test-coverage notes are guesses. Points the panel may have missed, for the maintainer to consider:
- **Stored data has no version field:** the saved journal and record formats carry no version. On an unknown entry type, `applyEntry` falls through to the operation branch, so entries written by a newer version would quietly corrupt state after a rollback.
- **Gaps in the journal can destroy data:** `replay` stops at the first missing `j<N>.<seq>`. `reclaimOrphans` could then delete live `c*`/`ns*` names.
- **Faults are permanent:** nothing clears a faulted child and it cannot be removed, but it still counts against quota. If the faulting name collision can be induced, that is a way to exhaust quota.
- **One stuck call stalls everything:** there is a single global `serial` queue and no timeouts, so one hung host or driver call stalls create, remove and revoke for every namespace.
- **Startup can be blocked:** `reconcile` throws when one child is stuck, which stops the whole coordinator from starting, and there is no documented recovery.
- **Missing tests:** none against a real daemon, none for a crash at each step, none for create and revoke running at once, and none for replaying entries from a different version.
- **Packaging:** the package is private but points `homepage`/`repository` at `endojs/endo`, and its build step is `exit 0`. It is also unclear whether there is a changeset or CODEOWNERS entry.
- **Design-doc gap:** after a restart nobody holds the facets, so recovered children have no path to authority. The design doc should say this outright instead of leaving it to a code comment.

No garden files changed and no follow-up jobs were posted.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177325 cached reads)
- Output: 1486 tokens
- Cost: $0.421897
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
