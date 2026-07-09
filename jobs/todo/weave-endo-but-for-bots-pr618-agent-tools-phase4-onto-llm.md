---
role: weaver
---

Weave endojs/endo-but-for-bots PR #618 ("feat(daemon-agent-tools): Phase 4 — dynamic capability tool discovery + form provisioning", head `builder/daemon-agent-tools-phase4-integration`, base `llm`, bot identity): the PR is CONFLICTING/DIRTY (last rebased 2026-07-06, before landed #614's file-tool makers moved `llm`). Rebase onto current `llm`, reconcile the `@endo/agent-tools/discover.js` + Lal/Fae wiring against the now-merged #614 makers, and restore it to MERGEABLE so M3's agent coding-capability pillar (the daemon-agent-tools Phase 4 wiring) can advance to review.
