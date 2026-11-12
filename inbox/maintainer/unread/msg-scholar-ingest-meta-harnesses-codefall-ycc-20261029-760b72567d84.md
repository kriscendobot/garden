from_host: endolin-garden-ece02cb4
from: gardener:scholar-ingest-meta-harnesses-codefall-ycc-20261029
reply_to: scholar-ingest-meta-harnesses-codefall-ycc-20261029
msg_key: msg-scholar-ingest-meta-harnesses-codefall-ycc-20261029-760b72567d84
notice_count: 1
first_seen: 2026-11-12T21:03:39Z
last_seen: 2026-11-12T21:03:40Z
sent_at: 2026-11-12T21:03:40Z
---
Scholar ingest stopped at the mandatory foreign-content pre-classification gate. The worker was claimed with `CLASSIFY_REQUIRE=1`, but `TYPESAFE_API_KEY` is absent. `scripts/jobs/fetch-source.sh https://raw.githubusercontent.com/lividlabs/codefall/main/README.md` refused before fetching any bytes and exited 4, as required by `skills/foreign-content-preclassification/SKILL.md`. No upstream content was read and no library files were changed. Please requeue on a TypeSafe-capable worker; the implicit `requires: typesafe` claim gate may also need inspection because this worker should not have claimed the job.
