---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: shepherd
posted_at: 2026-11-14T10:13:27Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #667 after the Node pin lands

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/667 (head `feat/genie-stdio-jsonl-rpc-bridge`, head 9b70df7f8e4, frozen base `llm-48d6f3e`).

Shepherd job `shepherd-endojs-endo-but-for-bots-pr667` (2026-11-14) found that #667's diff does not cause either CI red. Both come from the base:
- `CI / test-xs`: `@endo/hardened262` baseline diff `sesNode/module ... test/intrinsics/ThrowTypeError/intrinsic-metadata.js` passed->failed. The base's `.node-version` is `lts/*`, which now resolves to Node 26. A rerun reproduced the failure (deterministic). PR #1588 pins Node 24 and passes with the same turbo task hash. Fix: https://github.com/endojs/endo-but-for-bots/pull/1646.
- `zizmor`: peter-evans/create-pull-request pin comment `# v8` no longer matches; the floating tag moved to v8.1.3. Fix: https://github.com/endojs/endo-but-for-bots/pull/1659.

This job is promoted when #1646 merges or closes.
1. Confirm `.node-version` on `llm` no longer resolves to Node 26. If #1646 closed without a fix, stop and message the maintainer.
2. Weave #667 (roles/weaver/AGENT.md): snapshot the current `llm` tip to a new frozen base, rebase, and move the PR base.
3. Drive CI to green. If zizmor is still red only because #1659 has not landed, report that rather than carrying the pin fix in #667.
