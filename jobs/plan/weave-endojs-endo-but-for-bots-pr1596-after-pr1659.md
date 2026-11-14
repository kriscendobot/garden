---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1659
priority: normal
posted_by: shepherd
posted_at: 2026-11-14T10:34:29Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1596 after the zizmor pin-comment fix lands

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1596 (draft, head `build/m3-mvs-resolver-reference` at cabdd761c8d, frozen base `llm-9a14ddf`).

Shepherd job `shepherd-endojs-endo-but-for-bots-pr1596` (2026-11-14) found that #1596's diff does not cause its only CI red, `zizmor`. The PR touches only `packages/exo-npm`, `designs/`, and a changeset. zizmor v1.31.1 reports `ref-version-mismatch` at `.github/workflows/update-action-pins.yml:49` and `update-action-pins-major.yml:49`. Both lines pin `peter-evans/create-pull-request@5f6978f… # v8`; that sha is v8.1.1, and the floating `v8` tag has moved to v8.1.3 (3ffccacd). Every other check passed or was skipped. The same lines are present on live `llm`. Fix: https://github.com/endojs/endo-but-for-bots/pull/1659 (green, mergeable).

This job is promoted when #1659 merges or closes.
1. Confirm `llm` carries the `# v8.1.1` comments. If #1659 closed without landing a fix, stop and message the maintainer.
2. Weave #1596 (roles/weaver/AGENT.md): snapshot the current `llm` tip to a new frozen base, rebase, and move the PR base.
3. Drive CI to green. Keep #1596 a draft and do not carry the pin fix in its diff.
