Fix round 1 for kriscendobot/minion.town PR #177 is pushed and CI is green.

**Panel input:** I worked from the round-1 panel review posted 2026-10-11T02:59Z. Its two must-fix items both came from the skeptic, and the other seats were comment-only or approve. I applied both must-fix items and the overlapping should-fix items in `designs/git-remote-served-clip.md`. The change is one follow-up commit, `d1ec29a`, pushed with `safe-push-pr-head.sh` (advance mode) on top of `33c8030`.

**Must-fix 1 — reverting a push does not stop a retained root from being served (§ 5.1):**
- The design now says that once a root is retained it is still served as immutable after a revert, until the 24 h / 16-root retention drops it. Browsers and caches that already fetched it keep it for a year.
- It sets out three cases: a root from another partition is refused by the `roots` check; an identical copy pushed elsewhere is harmless; a bad root pushed to this partition stays served until purged.
- It adds an operator subcommand, `purge-root <id> <root>`. It runs through the per-partition queue and refuses to purge the current root. A pushed secret must be rotated, not just reverted. § 6 now lists the subcommand.

**Must-fix 2 — the HTML rewrite and parser differences between parse5 and browsers (§ 5.1):**
- The rewrite is now described as a caching optimization, not a security boundary, and it falls back to the raw document rather than guessing.
- These documents are served raw with a warning: any document with a `<base>` element, and any document parse5 reports a parse error for.
- `<template>` and `<noscript>` contents are not rewritten, and a malformed `srcset` is left whole.
- Every raw fallback records a warning in the projection status.

**Should-fix items from the critic and skeptic (§ 4, § 5.1):**
- **Marker race:** each push now writes its own marker, and a projection clears only the markers it saw when it started. An earlier projection can no longer erase the crash evidence of a later push.
- **Tombstone ordering:** stated against in-flight projections, using the per-partition queue.
- **Retry cap:** a failure that will always recur retries at the 1 h cap until a new push.
- **Binding limit:** for frequent publishers the 16-root cap, not the 24 h horizon, is what actually limits how long a page can load old assets. For vitals that is about 4 h.

**Tests (§ 10):** added cases for the `<base>` and parse-error fallbacks, `<template>`/`<noscript>`, `srcset` edge forms, bytes outside the rewritten attributes staying identical, `purge-root`, and the marker race.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 (3 checks: `test`, `Claude harness` amd64 and arm64). My first run of it hit the 10-minute tool timeout and was moved to the background; I confirmed green with `gh pr checks` and a second foreground run.

**Not addressed:** the remaining should-fix and comment-only items from the novice, ergonomist, decomplector and pruner seats: a background glossary, field renames, `kind` semantics, a `.content` skip warning to the pusher, and trimming the PR body. Panel-2 may raise them again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1128616 cached reads)
- Output: 8017 tokens
- Cost: $0.9985432
- Wall-clock: 867s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
