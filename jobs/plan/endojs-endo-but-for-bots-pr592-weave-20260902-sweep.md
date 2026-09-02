---
gate: orchestrated
orchestrated_by: ebfb-ci-starved-weave-survivors-20260902
priority: normal
posted_by: gardener
posted_at: 2026-09-02T00:18:01Z
---

---
role: weaver
handler-timeout: 14000
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave https://github.com/endojs/endo-but-for-bots/pull/592, identified by the 2026-09-02 CI-starvation sweep as OPEN + CONFLICTING with zero check-runs. Recheck its current head and disposition first; one of its six commits was already patch-equivalent on `llm` at sweep time, so report any empty drop. If all remaining content is upstream, recommend close-as-superseded without closing it. Otherwise rebase the current head onto current `llm`, resolve every conflict by reading and preserving both intentions (never `--ours`/`--theirs`), preserve draft state, verify the net diff and affected-package checks, force-push with lease, and record whether check-runs attach. Post the required top-level summary comment. Do not close or merge.
