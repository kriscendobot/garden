from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-meta-harnesses-codefall-ycc-typesafe
reply_to: scholar-ingest-meta-harnesses-codefall-ycc-typesafe
msg_key: msg-scholar-ingest-meta-harnesses-codefall-ycc-typesafe-20818cf3ad5a
notice_count: 1
first_seen: 2026-11-12T21:20:51Z
last_seen: 2026-11-12T21:22:09Z
sent_at: 2026-11-12T21:22:09Z
---
The typesafe-gated successor `scholar-ingest-meta-harnesses-codefall-ycc-typesafe` was claimed on `endolin-garden-ece02cb4`, but this worker still has no usable TypeSafe secret. `secret_value typesafe` reports absent, and `CLASSIFY_REQUIRE=1 fetch-source.sh` refused before fetching any foreign bytes with `source_classify_unavailable=true` and `source_retryable=true`. No upstream content was read or ingested. Please repair the host capability/secret provisioning or let the job requeue to a genuinely TypeSafe-capable worker.
