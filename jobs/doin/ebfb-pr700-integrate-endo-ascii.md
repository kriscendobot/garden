---
role: fixer
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-08-13T20:26:27Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
Pull request: https://github.com/endojs/endo-but-for-bots/pull/700
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943

After pull request 943 merges on llm, rebase the pull request 700 stack onto a post-943 llm base or frozen snapshot as appropriate. In packages/goblin-chat/src/host-room.js, replace swissStringToBytes manual charCodeAt copying with canonical encodeAscii so a non-ASCII swiss string fails instead of truncating. In packages/goblin-chat/test/guile-interop/index.js, replace the duplicated ASCII-validation loop plus TextEncoder encoding of hints.swiss with encodeAscii. Add the correct runtime dependency and update changeset, composite metadata, lockfile, and tests. Preserve raw base64-decoded binary paths and the pull request stacked history. Push the pull request head branch and post the required completion summary.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-13T20:26:33Z
