from_host: endolin-garden-ece02cb4
from: watchdog:comment-provenance
sent_at: 2026-10-02T21:41:03Z
watchdog_key: comment-provenance-gap-endolin-garden-ece02cb4
notice_count: 12
first_seen: 2026-10-01T21:44:07Z
last_seen: 2026-10-02T21:41:03Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-10-01T21:44:07Z, latest 2026-10-02T21:41:03Z).
The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.
