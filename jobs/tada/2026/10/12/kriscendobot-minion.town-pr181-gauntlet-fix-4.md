Fix round 4 for kriscendobot/minion.town PR #181 is done: all three panel-4 must-fix items are fixed and pushed. CI is green on the new head `a95f956` (`ci-wait-merge.sh` returned 0; all 3 checks passed).

**What I fixed**, in one follow-up commit `a95f956` on `git-remote-served-clip`:

- **breaker — deeply nested HTML crashed the rewrite or froze the service.** I measured parse time growing faster than linearly with nesting depth (about 200 ms at 8,000 levels).
  - `html-rewrite.ts` now stops building the tree past a new `MAX_NESTING_DEPTH` of 512 and serves that document raw. Nested `<template>` elements count toward the depth, so they can't get around the limit.
  - The tree walk no longer uses recursion, so deep trees can't overflow the call stack.
  - Any error during parsing or walking now falls back to raw instead of failing the projection, which makes the "fails toward raw" claim true.
  - I bumped `REWRITE_RULES_VERSION` to `served-clip-rewrite-v2`, so the full sweep will re-project every partition.
- **saboteur — the whitespace trim was quadratic.** `stripAsciiWhitespace` used a regular expression that slowed down badly on long runs of spaces. It now scans by index and runs in linear time.
- **stylist — abbreviated names.** `servePartitionContent` now takes `request` and `response` instead of `req` and `res`. I left `serveEntry` and `notFound` as they were, since they existed before this PR.
- **should-fix (raised by assessor, breaker noted it) — stuck push marker.** In `git-http.ts`, if `runHttpBackend` throws before the git process starts, the push marker is now released once and the client gets a 500. Before, the marker stayed "in flight" until restart and the sweep re-projected that partition every 30 s.

**Tests:** I added three regression tests:
- 150,000-deep `<div>` and `<template>` documents are served raw, each in under 2 s.
- A document nested just under the limit is still rewritten.
- A 1 MiB run of whitespace inside an attribute is trimmed quickly.

The typecheck passes. Locally, the git-remote and gateway suites have one failure: the `capability.test.ts` test "propagates a git failure rather than reporting the ref absent" expects git to exit with 128 on a missing repository. This round doesn't touch that code, and the test passes in CI, so it is probably something about this host's environment. I haven't looked into it further.

**Not addressed** (all should-fix or comment-only, so they don't block this stage):
- **migrator:**
  - deploy-order and rollback notes for the new `content-roots` JSON format and the partition record kind;
  - the narrowed set of reserved publish prefixes.
- **saboteur:** a corrupt vhost record file permanently blocks its clip.
- **breaker:**
  - no total budget on HTML bytes rewritten per projection;
  - an old root can stay servable up to an hour past its retention period;
  - `destroy` can leave an orphaned vhost record when the served-state file is corrupt.
- **saboteur:** the design should say that purging a root can't revoke copies browsers already cached as immutable.

These are left for the next panel or the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2645350 cached reads)
- Output: 16556 tokens
- Cost: $1.513902
- Wall-clock: 1370s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
