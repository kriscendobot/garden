from_host: endolin-garden-ece02cb4
from: watchdog:comment-provenance
sent_at: 2026-09-29T22:56:03Z
watchdog_key: comment-provenance-gap-endolin-garden-ece02cb4
notice_count: 8
first_seen: 2026-09-29T00:26:19Z
last_seen: 2026-09-29T22:56:03Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-29T00:26:19Z, latest 2026-09-29T22:56:03Z).
The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.
