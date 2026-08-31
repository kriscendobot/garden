---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-31T09:22:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resolve the approved PR 1083 live-base conflict

Repository: endojs/endo-but-for-bots; PR: https://github.com/endojs/endo-but-for-bots/pull/1083.

The first conductor attempt rebased against live llm at 8f4525ca956 and failed closed on a non-lockfile conflict in designs/README.md. Wear the weaver role: use an isolated project worktree, rebase the bot-owned head design/npm-registry-as-directory-tree onto the current live llm, resolve the design-index conflict by preserving both the PR design entry and independent live-base entries, run all locally applicable verification, and publish with the safe lease/CAS discipline. Do not alter design substance beyond what the conflict requires. Leave the PR open for the conductor.

Maintainer approval remains effective unless dismissed or superseded by a later CHANGES_REQUESTED review. Do not mutate or merge endojs/endo upstream.
