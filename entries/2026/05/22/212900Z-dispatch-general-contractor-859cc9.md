---
ts: 2026-05-22T21:29:00Z
kind: dispatch
role: weaver
project: endo-but-for-bots
to: weaver
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 316
    role: target
refs:
  - entries/2026/05/22/212707Z-result-cleaner-919e16.md
---

# Dispatch: weaver 859cc9 — rebase #316 (Node 22.22.3 pin) past zizmor hardening (PR #354)

Dispatch root: `dispatches/weaver--859cc9/`. Project worktree on `endojs/endo-but-for-bots@chore/familiar-lts-node-pin`.

Cleaner 919e16 (see `entries/2026/05/22/212707Z-result-cleaner-919e16.md`) found PR #316 CONFLICTING against current `llm`. Single-file conflict in `.github/workflows/familiar-release.yml` where PR #354 (zizmor hardening: permissions block, concurrency group, `YARN_ENABLE_SCRIPTS`, `persist-credentials: false`, `package-manager-cache: false`) restructures the same workflow #316 edits for its Node pin bump.

## Task

Rebase `chore/familiar-lts-node-pin` onto current `origin/llm`. Resolve the `familiar-release.yml` conflict by **threading the Node-pin bump through the zizmor-hardened shape**:

- The zizmor work landed permissions, concurrency, env, and persist-credentials/cache-poisoning defenses. Preserve all of those.
- The Node-pin bump replaces `v20.18.1` with `v22.22.3` at the workflow's invocation of `download-node.sh` (per the PR body's "passes `v22.22.3` to the `download-node.sh` step on each platform matrix entry").
- The resolution is: the new workflow file = zizmor-hardened shape PLUS the v22.22.3 string substituted in.

Per `garden/skills/frozen-base-branch/SKILL.md` (2026-05-22 convention): rebase against the project's roadmap branch `llm`; recreate the per-PR frozen-base snapshot if applicable. Force-push-with-lease to `chore/familiar-lts-node-pin`.

Verify post-rebase:
- The other four touched files (`download-node.mjs`, `download-node.sh`, `package.json`, `.changeset/familiar-lts-node-pin.md`) are unchanged from the pre-rebase shape (they don't intersect zizmor's surface).
- CI re-runs and converges to green on the new head.

## Per-action authorization

- Force-push-with-lease on `chore/familiar-lts-node-pin` (rebase requires this).
- Frozen-base branch push if convention applies.
- READ-ONLY everywhere else. No comments. Don't un-draft.

## Out of scope

- Don't broaden the Node-pin lockstep surface.
- Don't move to ready-for-review.

## Report

≤ 300 words:
1. Pre-rebase + post-rebase head SHAs.
2. Conflict-resolution shape (one paragraph naming the zizmor + Node-pin interleave).
3. Other-file integrity check (the four non-workflow files).
4. CI status post-push.
5. Slot-1 next-stage recommendation (likely cleaner-skip → barrister per the chore-shape shallow-coverage rule; cleaner already concluded that).
6. One-line `Self-improvement: ...`.

Write the report into `journal/entries/2026/05/22/<HHMMSS>Z-result-weaver-859cc9.md` and commit+push to origin journal before returning.
