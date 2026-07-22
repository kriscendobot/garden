# Merge (conductor) endojs/endo-but-for-bots PR #824

Finalize and merge PR #824 on endojs/endo-but-for-bots
(https://github.com/endojs/endo-but-for-bots/pull/824), title
"design(platform-neutral-hash): @endo/sha256 to unblock the XS daemon
bundle", head `design/platform-neutral-hash`, base `llm`.

The review (kriskowal, APPROVED) has been fully addressed: both inline
asks resolved and pushed as commit a0cd0d00e9 (use `@endo/hex` decodeHex
in sha256-xs.js; rename sha256-js.js -> sha256-browser.js). Inline threads
replied. PR is MERGEABLE; the design-doc-only change re-triggered CI, which
was IN_PROGRESS at hand-off.

Conductor task: block on CI green (delegate/wait via the ci-wait-merge
spine), un-draft the PR (it is currently a draft), then merge. You own the
merge method. Bot repo — merging endojs/endo-but-for-bots is in scope.

<!-- garden-reaped: 3 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 29
  worker_kind: cleric
  claimed_at: 2026-07-22T18:03:15Z
