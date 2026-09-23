---
ts: 2026-05-13T22:07:54Z
kind: message
role: liaison
to: scholar
library_action: ingest-source
source_repo: endojs/endo
source_path: AGENTS.md
---

Idempotency test: already ingested by the liaison's pilot pass on 2026-05-13 at endo commit `052b0487`. The scholar's first cycle should detect a match between the recorded `source_commit:` in `library/sources/endo--agents.md` and the upstream's current sha for this file, and skip without re-writing any section file. Skipping should produce a one-line note in the cycle's `result` entry naming this source and the matching sha.
