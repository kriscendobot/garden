---
role: weaver
tier: mentor
handler-timeout: 14000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-02T03:31:03Z cleared=none -->

---
role: weaver
handler-timeout: 14000
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave https://github.com/endojs/endo-but-for-bots/pull/266, identified by the 2026-09-02 CI-starvation sweep as OPEN + CONFLICTING with zero check-runs. A gauntlet panel was active when the sweep began, so re-resolve the current head and avoid racing another live mutation. Recheck disposition first; if fully upstream, recommend close-as-superseded without closing it. Otherwise rebase the current head onto current `llm`, resolve every conflict by reading and preserving both intentions (never `--ours`/`--theirs`), preserve draft state, verify the net diff and relevant checks, force-push with lease, and record whether check-runs attach. Post the required top-level summary comment. Do not close or merge.
