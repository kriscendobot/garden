---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1575
priority: normal
posted_by: producer
posted_at: 2026-11-04T05:04:46Z
---

---
role: weaver
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave the phase 2 gap PR onto llm after #1575 merges

Repo: endojs/endo-but-for-bots. Head `feature/api-key-provider-adapters-acceptance`, opened by job `build-api-key-agents-p2-provider-adapters-open-pr` against the frozen base `feature/api-key-provider-adapters-0b8d24a`.

1. Confirm https://github.com/endojs/endo-but-for-bots/pull/1575 actually MERGED. This job is promoted when it merges or closes. If it closed without merging, do not weave: message the maintainer.
2. Weave the gap PR onto a fresh frozen snapshot of `llm` and move its `base`. Only its own commit should remain: "fix(hosted-agent,lal): settle cut-short streams and report upstream refusals". Expect conflicts in `inference-provider-registry.js` and its test if #1575's fixups changed nearby lines during autosquash.
3. Run `hosted-agent`'s and `lal`'s tests, then push and report the new head.
