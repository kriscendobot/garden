---
role: fixer
---

Garden infra fix in scripts/jobs/ensure-project-worktree.sh: the branch fetch
(`git --git-dir="$bare" fetch --quiet origin "+refs/heads/${branch}:refs/heads/${branch}" 2>/dev/null || true`)
swallows all failures, so a transient network/auth failure silently delivers a
worktree at a stale local ref with no warning. Observed 2026-07-06 by job
design-daemon-agent-tools-reconcile-mount-git-capabilities: the helper checked
out endojs/endo-but-for-bots@llm at 68246ad92 (8 weeks stale, missing the very
design docs the job named) while origin/llm was at 113228924; a manual
`git fetch origin llm` in the worktree succeeded moments later. Fix in an
isolated main2 worktree: after the fetch, verify the local refs/heads/$branch
against `git ls-remote origin refs/heads/$branch`; when they diverge (or the
fetch failed and the remote has the branch), retry once and otherwise die (or
at minimum emit a prominent stderr staleness warning naming both SHAs) instead
of silently handing a gardener an old tree. Keep the legitimate no-op case (a
detached ref/sha that exists on neither side) working. Push HEAD:main2 with a
rebase CAS loop.
