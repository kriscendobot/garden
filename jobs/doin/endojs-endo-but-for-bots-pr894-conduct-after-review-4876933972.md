---
role: conductor
handler-budget-role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize approved endojs/endo-but-for-bots PR #894

A trusted maintainer approved https://github.com/endojs/endo-but-for-bots/pull/894 in review https://github.com/endojs/endo-but-for-bots/pull/894#pullrequestreview-4876933972.

The review body was empty. Its only inline ask requested the design rename. Commit a7e5ffa48155c28c379d52375c0d4e0f531d6761 renames designs/cbors.md to designs/cbor-frame.md and updates every repository reference. The inline resolution is https://github.com/endojs/endo-but-for-bots/pull/894#discussion_r3730716843, and the required top-level completion summary is https://github.com/endojs/endo-but-for-bots/pull/894#issuecomment-5298717379.

At dispatch time the PR is OPEN, draft, MERGEABLE/CLEAN at head a7e5ffa48155c28c379d52375c0d4e0f531d6761, and every check is terminal-success. The previously cancelled docs-only lint check was rerun successfully at https://github.com/endojs/endo-but-for-bots/actions/runs/31122398122.

Task: re-fetch live state, require approval, mergeability, and terminal-green checks on the current head, un-draft if still draft, and merge. The conductor owns the merge method. This is a bot repository. Never merge agoric-sdk or endojs/endo upstream. If any gate has regressed, do not force it; report the gated outcome honestly.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T22:19:13Z
