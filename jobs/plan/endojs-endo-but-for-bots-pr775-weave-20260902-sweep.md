---
gate: orchestrated
orchestrated_by: ebfb-ci-starved-weave-survivors-20260902
priority: normal
posted_by: gardener
posted_at: 2026-09-02T00:17:55Z
---

---
role: weaver
handler-timeout: 14000
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave https://github.com/endojs/endo-but-for-bots/pull/775, identified by the 2026-09-02 CI-starvation sweep as OPEN + CONFLICTING with zero check-runs. Recheck its current head and disposition first. If its content is now fully upstream, recommend close-as-superseded without closing it. Otherwise rebase the current head onto current `llm`, resolve every conflict by reading and preserving both intentions (never `--ours`/`--theirs`), preserve draft state, verify the net diff and affected-package checks, force-push with lease, and record whether check-runs attach. Post the required top-level summary comment. Do not close or merge.
