---
ts: 2026-05-14T18:21:28Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: shepherd opens a no-changes PR on llm to diagnose CI failure

Dispatch root: `dispatches/shepherd--3ddcfe/`. Project worktree at `endojs/endo-but-for-bots@llm` (detached).

Maintainer report (2026-05-14): CI is failing on the `llm` branch. The maintainer suspects a mismatch in `SECURITY.md`. They want a no-changes PR (empty commit) that pokes CI on a fresh branch off `llm`, so the failure is reproduced in isolation (not entangled with any other PR's diff) and the failure mode is captured cleanly.

## Per-action authorization

Standing on endo-but-for-bots: push branches, open the PR, post the PR's own body, watch CI.

## Task

1. **Inspect the current `llm` head's CI state** before opening anything. `gh api repos/endojs/endo-but-for-bots/commits/llm/check-suites` and `gh api repos/endojs/endo-but-for-bots/commits/llm/status` give the picture. If CI is genuinely red on `llm`, note which jobs failed. (If it is somehow green, surface that and stop — the maintainer's report disagrees with observable state.)

2. **Create a fresh branch off `llm` with one empty commit.** Branch name: `ci/poke-llm-<short-id>` where `<short-id>` is the dispatch's 6-hex id (`3ddcfe`). Commit message: `ci: empty commit to surface llm CI failures (poke)`. Author + committer per the dispatch-prepare's pinned bot identity (the dispatch root's per-worktree git config is already set; no override needed).

3. **Open the PR** against `llm` as the base. Use `pr-formation` conventions for title and body, but the body is the minimal "poke CI to reproduce llm's current failure mode; no source changes" with the originating dispatch-root short-id. Title: `ci: empty-commit poke to reproduce llm CI failure`. Mark as draft (no review needed; this is diagnostic).

4. **Watch CI converge.** `gh pr checks <N> -R endojs/endo-but-for-bots --watch` until every check is either pass/fail/skipped. Note which jobs fail and capture their failure-message lines (the head-line of each red job; not the whole log).

5. **Diagnose the failure.** If the user's `SECURITY.md` mismatch hypothesis is correct, the failing job's log should name `SECURITY.md` (likely a link-check, content-sync, or workflow-validation check). Surface the specific complaint inline in the report.

6. **Do not auto-fix.** This dispatch is diagnostic, not corrective. Once the failure is captured, the report goes back to the liaison, who decides whether to dispatch a fixer or pass to the maintainer.

7. **Do not un-draft.** The PR is diagnostic; keep it in draft. If CI passes on `llm` (which would contradict the user's report), the PR can be closed without merging.

## Out of scope

- No fixer dispatch. The shepherd reports; the liaison routes the fix.
- No edit to `SECURITY.md` or any other source file.
- No comment on any other PR.
- No upstream `endojs/endo` interaction.

## Report

≤ 300 words:
- The PR URL.
- The CI conclusion summary (pass / fail per check; failing jobs by name).
- For each failed job: one-line failure header from its log.
- Best-effort interpretation: is the `SECURITY.md` mismatch the cause? If yes, what specifically (file content out of sync with master? broken link? policy version drift?). If no, what is the actual cause?
- One-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
