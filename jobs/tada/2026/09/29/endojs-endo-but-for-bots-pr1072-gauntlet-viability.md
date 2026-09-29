State unchanged — same PR facts as before. Re-confirming the viability finding.

## Viability report — endojs/endo-but-for-bots PR #1072

**PR state:** OPEN, draft, unmerged.

**Deciding question:** Does the current `llm` tip still emit the two-hint (`tcp:host`/`tcp:port`) shape this PR replaces with a single `tcp:url` hint, and does the maintainer still want this change landed?

**Evidence:**
- Current `llm` HEAD (`1706e63247fb2c23b767f24fa1bd4b35d575089e`) still has `packages/ocapn-noise/src/transports/tcp.js` returning `hints: { host, port }` separately — the aberration this PR fixes is unfixed on base. Premise still holds.
- PR's `baseRefOid` equals current `llm` tip exactly — a maintainer-directed pinned-base snapshot (`llm-1706e63`), not stale.
- Review thread: kriskowal drove CHANGES_REQUESTED → response → retcon → weave → retcon → gauntlet resume, with the standing instruction *"Please move the base to a current pinned base and then rebase. Retcon, resume the gauntlet..."* — a live, current directive to proceed.
- `gh pr checks`: all applicable jobs pass; no CI failures on the current head.
- No competing/superseding implementation found on `llm`.

This is a read-only viability gate; no code or PR state changes were needed or made. This report reconfirms the same finding as the prior two attempts, this time with the gauntlet marker line placed before the completion signal so the signal is the true final line.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 26 tokens (846712 cached reads)
- Output: 4601 tokens
- Cost: $1.1501860000000002
- Wall-clock: 63s

<!-- garden-usage-end -->
