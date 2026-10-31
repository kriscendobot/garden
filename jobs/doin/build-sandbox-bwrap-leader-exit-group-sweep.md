---
posted_at: 2026-10-31T13:57:38Z
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Open a standalone PR on endojs/endo-but-for-bots against a fresh frozen snapshot of `llm` that carries only the bwrap driver fix `17c61dd8e409e4a8aba931b54ea6292b631c1c66` ("fix(sandbox): sweep the bwrap process group when the leader exits", currently riding inside PR #1504). Optionally include #1566's cleanup-diagnostics commit `2696934af6` if it applies cleanly.

Why: `packages/sandbox/test/bwrap.test.js` "bwrap timeout and repeated cancellation reap process groups" fails intermittently on ubuntu-26.04 CI ("process group N survived bounded cleanup") on unrelated PRs: #1571 (run 41171740768), daemon-worker-import-from-mount-phase-three (run 41195268283), feat/lal-subscription-oauth (run 41177911274), and build/daemon-agent-tools-sandbox-shell (run 41148036031). The #1504 shepherd (journal tada 2026-10-31 endojs-endo-but-for-bots-pr1504-shepherd-20261031) diagnosed a real orphaned inner-bwrap race on `llm` and recommended splitting the fix into its own PR. Once it merges, red PRs on older frozen bases (starting with #1571) need a weave.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T14:02:37Z
