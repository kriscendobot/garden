---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/send-msg.sh
The guard at send-msg.sh:67-73 correctly rejects `role/jurors/archivist`, but the journalctl tail shows `[send] FATAL: illegal address segment 'jurors/archivist'` at 16:27:48Z. A caller addressed a juror seat as a nested role path. Juror seats live under `roles/jurors/<seat>`, so the nested form is easy to produce. Make send-msg.sh accept `role/jurors/<seat>` and map it to the single segment `role/jurors-<seat>`, or reject it with a message that names the flat form. Find the caller that builds the nested address (the panel or juror dispatch path) and make it use the same flat form. Add a regression case to scripts/jobs/test/run-test.sh, next to the existing role/gardener send at line 181.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T18:24:00Z
