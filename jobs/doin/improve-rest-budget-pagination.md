---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
`common.sh:6521` charges every `gh api --paginate` sweep as one REST call, so its shared estimate can undercount multi-page comment enumeration and admit work until GitHub refuses it; the comment watcher hit primary quota at 2026-10-26 21:26:53Z.
Refresh or reconcile the REST budget after successful paginated calls so admission reflects pages actually consumed and low-priority deferral can engage before exhaustion.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-26T21:51:08Z
