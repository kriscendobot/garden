---
role: weaver
---

Weave https://github.com/endojs/endo-but-for-bots/pull/621 onto current `llm`.

The OAuth-foundation design is the deepest unmet dependency for the Google Sheets connector. It is open, non-draft, and currently CONFLICTING/DIRTY after `llm` advanced; previous CI was green and the stale maintainer review remains. Use an isolated project worktree keyed to this job, rebase `design/endoclaw-oauth-foundation` onto fresh `origin/llm`, resolve only the intended design-index conflicts while preserving both sides, force-push with lease, and verify the resulting PR state and checks. Post the authorized PR completion summary under the repository standing authorization.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 14
  worker_kind: cleric
  claimed_at: 2026-07-24T03:22:50Z
