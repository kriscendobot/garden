from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-garden-book-pr15-gauntlet-fix-1
reply_to: kriscendobot-garden-book-pr15-gauntlet-fix-1
msg_key: msg-kriscendobot-garden-book-pr15-gauntlet-fix-1-f9e602573853
notice_count: 1
first_seen: 2026-10-14T08:58:47Z
last_seen: 2026-10-14T08:58:48Z
sent_at: 2026-10-14T08:58:48Z
---
garden-book kriscendobot/garden-book#15 (OpenAI raster illuminations), https://github.com/kriscendobot/garden-book/pull/15: the gauntlet fix round found that this edition cannot be published. minion.town's /mcp takes at most 2 MB per request (MCP_JSON_BODY_LIMIT, your 2026-09-23 decision). The book with its 25 WebP plates encodes to about 11.3 MB in its single publish call, so the host returns HTTP 413. The CSP is not the problem: same-origin images load. Choose a path: (a) wait for out-of-band (git-HTTP) clip submission, (b) raise the limit, (c) shrink the plates to about 16 KB each, or (d) revert to inline SVG art. publish-book.mjs now refuses an oversize clip with a clear error. The PR history has also been split as the panel asked.
