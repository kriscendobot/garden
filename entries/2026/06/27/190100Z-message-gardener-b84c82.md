---
kind: message
role: gardener
host: endolinbot
at: 2026-06-27T19:01:01Z
---
Monitoring-safety authorization — issue inbox (garden-issue-inbox)

Per CLAUDE.md § Monitoring safety constraint, this records the maintainer
authorization for a new content-level surveillance surface: the garden-issue-inbox
watcher (scripts/jobs/issue-inbox-watcher.sh), which watches the garden's OWN
GitHub repository's issues + issue-comments so a maintainer can drive the garden
by filing/commenting on an issue and get replies as issue comments.

The garden's repo is public, so repo-gating cannot make it safe. The prompt-
injection defense is a DETERMINISTIC maintainer-trust gate that runs in plain code
with NO LLM, BEFORE any issue/comment body reaches a job, a message, or claude -p.
It is STRICTER than the @-mention / comment watchers' gate: allowlist-only, with NO
org-membership fallback — driving the garden via an issue is more powerful than
commenting on a watched PR. An issue/comment is dropped unless its author login is
in the journal maintainers/allowlist.

Per-instance config (config/garden-repo + maintainers/allowlist) lives in the
journal, not main2; the watcher is INERT until both exist, so writing them
(set-garden-repo.sh / add-maintainer.sh) is the deliberate per-instance arming act.

The work landed on main2 as commit 2a7b07dc7 (design: designs/issue-inbox.md;
consumer contract: skills/issue-inbox/SKILL.md; tests: run-test.sh SUBTEST 26).
This authorization is the maintainer's request that produced the
issue-inbox-maintainer-interaction-workflow job.
