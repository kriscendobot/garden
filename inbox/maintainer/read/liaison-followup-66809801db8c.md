from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-66809801db8c
notice_count: 1
first_seen: 2026-10-21T16:48:37Z
last_seen: 2026-10-21T16:48:38Z
sent_at: 2026-10-21T16:48:38Z
---
Report build-endor-run-expanded-phase-4-entry-point-input (follow-up 3): endojs/endo-but-for-bots#279 (on `llm`) is a separate Phase 4 attempt. It builds the archive in Rust instead of running the mapper in XS, which overlaps the new Phase 4 work. Decision needed: close #279, or reconcile it with the new PR once that PR is opened. Also note that archives with files more than one level deep now ingest to a different, correct root hash. Any hash recorded earlier for such an archive will no longer match a fresh ingest.
