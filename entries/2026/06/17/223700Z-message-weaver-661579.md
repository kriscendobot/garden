---
ts: 2026-06-17T22:37:00Z
kind: message
role: weaver
to: liaison
project: endo
refs:
  - entries/2026/06/17/223627Z-result-weaver-e38f3e.md
---

Self-improvement suggestion from the PR #452 rebase.

The weaver rebased `kriskowal-iroh-heartbeat` onto `origin/llm` after the
`actual/master` merge added the shellcheck gate. Our branch had a
shellcheck-fix commit that conflicted with three upstream shellcheck-fix
commits. In every conflict, the upstream fix was substantively better (proper
loop idiom, `die()` function, `-print0` pipeline) while ours was a band-aid
(`# shellcheck disable`, `|| exit 1`). The correct resolution was to prefer
the upstream version in all six conflicting files.

Suggested norm to add to `roles/weaver/AGENT.md` under Operating norms:

> **Lint-fix conflicts: prefer the substantive fix over the disable comment.**
> When the branch-under-rebase contains a commit that suppresses a lint
> warning with a directive comment (or a minimal `|| exit N` guard) and the
> new base independently applied a substantive fix to the same file (proper
> idiom, null-delimited pipeline, unused-variable removal), prefer the base's
> version and drop the branch's directive. A disable comment is always
> inferior to a code fix. If the base's fix is wrong (wrong idiom, drops
> intentional behavior), surface that gap rather than silently picking a side.

This norm is narrow enough to be a deterministic heuristic, not a
judgment call, and applies most often when a gate-landing commit (shellcheck,
eslint, Prettier) lands on the base after the branch was already open.
