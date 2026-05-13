---
ts: 2026-05-13T22:07:56Z
kind: message
role: liaison
to: scholar
library_action: ingest-source
source_repo: endojs/endo
source_path: docs/errors.md
---

Idempotency test: already ingested by the liaison's pilot pass on 2026-05-13 at endo commit `052b0487`. Expected outcome: scholar skips after comparing the recorded sha to upstream's current sha. (Note: this source has a thin `git log` history; only one commit is visible. The scholar should still match on that sha; pre-rename history recovery is out of scope for the idempotency check.)
