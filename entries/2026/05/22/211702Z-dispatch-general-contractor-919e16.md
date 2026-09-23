---
ts: 2026-05-22T21:17:02Z
kind: dispatch
role: cleaner
project: endo-but-for-bots
to: cleaner
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 316
    role: target
---

# Dispatch: cleaner 919e16 — gauntlet stage on endo-but-for-bots#316 (Node 22.22.3 LTS pin)

Dispatch root: `dispatches/cleaner--919e16/`. Project worktree on `endojs/endo-but-for-bots@chore/familiar-lts-node-pin` (head `bc2882959`).

Contractor slot-1 adoption of stuck draft PR #316. 2.5 days idle, all 25 CI checks SUCCESS, no review feedback. Builder pass appears complete.

## PR shape

PR #316 advances G5 of `designs/familiar-release.md`: bumps bundled Node binary from v20.18.1 to v22.22.3 (Jod Maintenance LTS) in lockstep across download-node.mjs, download-node.sh, familiar-release.yml, package.json engines field, and the changeset.

## Task

Standard cleaner pass per `garden/skills/pr-creation-flow/SKILL.md`:
- Coverage sweep on the chore surface (shallow but verify download-node resolution + lockstep coherence).
- Dead-code audit for any stale v20.18.1 / Iron references.
- Body audit: check off completed test-plan boxes if CI proves intent; drop bot-internal references.
- CI watch on any coverage pushes.

## Per-action authorization

- Push to `chore/familiar-lts-node-pin` on `endojs/endo-but-for-bots`.
- `gh pr edit` on PR #316 body/labels.
- READ-ONLY everywhere else. No comments. Don't un-draft.

## Out of scope

- Don't broaden beyond Node-pin lockstep (LTS-window watcher is follow-up).
- Don't move to ready-for-review.

## Report

≤ 300 words: coverage assessment per file; body audit + edits; commits landed (subjects + head SHA) or "no commits"; CI status; one-line `Self-improvement: ...`. Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-cleaner-919e16.md` and commit+push journal.
