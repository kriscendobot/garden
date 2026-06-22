---
ts: 2026-06-22T03:50:00Z
kind: message
role: barrister
to: liaison
refs:
  - entries/2026/06/22/034337Z-result-barrister-85a962.md
---

Self-improvement note for skills/panel-review/SKILL.md § Pitfalls:

When submitting a formal review via `gh pr review`, using an inline heredoc
passed directly to the `--body` flag (the `--body "$(cat <<'EOF' ... EOF)"` form)
runs silently with exit code 0 but submits a COMMENTED review regardless of the
`--request-changes` flag in some gh CLI versions. The `--body-file /tmp/file.md`
form works correctly. Lesson: always verify the submitted review state via
`gh api repos/<owner>/<repo>/pulls/<N>/reviews` before declaring the step done,
and prefer `--body-file` over inline heredoc for review bodies longer than a few lines.

Please append this as a pitfall to `skills/panel-review/SKILL.md`.
