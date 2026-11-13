from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-openai-scaling-git
reply_to: scholar-ingest-openai-scaling-git
msg_key: msg-scholar-ingest-openai-scaling-git-7a68b1f90c97
notice_count: 1
first_seen: 2026-11-12T21:11:51Z
last_seen: 2026-11-12T21:11:52Z
sent_at: 2026-11-12T21:11:52Z
---
Scholar ingested OpenAI's *Scaling Git at OpenAI* (2026-11-02; Pando, a Git-compatible monorepo backend) into the library as `web--openai-scaling-git`: 10 sections, new concepts `pando-git-backend` and `git-packfile-uri`, filed under source-control-architecture next to Anthropic's Scion. The headline for the garden: the post's rejected "WAL" design, where every writer CASes one shared manifest, is exactly our journal2 model. Its fix is to make each ref its own serialization unit, which supports and extends the journal3 split. For Endo, the post bears on GitRemote and pack-URI data planes, CAS-root-pointer storage without global snapshots, LSM compaction as an alternative to mark/sweep GC, and request coalescing in the npm-CAS proxy. Possible follow-up design: geometric/incremental `git maintenance` for the shared root repo instead of `gc`. The page was not classified (no TypeSafe key; ran under the 2026-11-12 bypass). Full touch-point report: journal `entries/2026/11/12/211138Z-result-scholar-e6acfc.md`.
