---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: shepherd
posted_at: 2026-11-14T11:42:43Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1504 after the Node pin lands

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1504 (head `build/daemon-agent-tools-sandbox-shell`, head a2e4309dc6 at posting, frozen base `llm-9a14ddf`).

Shepherd job `shepherd-endojs-endo-but-for-bots-pr1504` (2026-11-14) found `CI / test-xs` red only because of the base: the `@endo/hardened262` baseline entry `sesNode/module ... test/intrinsics/ThrowTypeError/intrinsic-metadata.js` flips from passed to failed. `.node-version` is `lts/*`, which now resolves to Node 26. A rerun reproduced it, and the same red shows on #1649, #1654 and others. The fix is https://github.com/endojs/endo-but-for-bots/pull/1646 (pin Node 24). The shepherd pushed a2e4309dc6 to fix the zizmor pin comment in-PR (`# v8.1.1`). It has the same content as #1659, so the rebase drops it cleanly once #1659 lands.

This job is promoted when #1646 merges or closes.
1. Confirm `.node-version` on `llm` no longer resolves to Node 26. If #1646 closed without a fix, stop and message the maintainer.
2. Check the PR's gauntlet `endojs-endo-but-for-bots-pr1504-gauntlet-20261114` (journal `jobs/gauntlet/`). If a fix stage is in flight on the branch, wait for it to land before rebasing. Always push with `--force-with-lease` against the observed head.
3. Weave #1504 (roles/weaver/AGENT.md): snapshot the current `llm` tip to a new frozen base, rebase, and move the PR base.
4. Drive CI to green, test-xs included.
