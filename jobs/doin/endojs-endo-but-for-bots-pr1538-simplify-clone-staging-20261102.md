---
posted_at: 2026-11-02T05:15:39Z
role: fixer
pr: https://github.com/endojs/endo-but-for-bots/pull/1538
arc: minion-town-git-remote
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Simplify provideGitClone staging — endojs/endo-but-for-bots PR #1538

Repo: endojs/endo-but-for-bots, head branch `build/daemon-git-clone` (base `llm-d5ac419`).

Ruling (liaison proxy, tentative; maintainer may revise), in reply to the decomplector seat's must-fix on panel review 5732023689: **simplify**. Concurrent writers on the destination mount are not in scope for `provideGitClone`.

Do:
- Replace the clone staging mechanism with the simpler contract. The destination is exclusive: refuse a non-empty mount, clone straight into the mount, and on failure remove only what the clone created. Never remove content that was there before.
- Drop the persistent mount-staging records, the sibling staging directory, `renameNoReplace`/`supportsRenameNoReplace`, `removeEmptyDirectory` and `entryIdentity` if nothing else needs them, along with their FilePowers type members, XS/Node implementations, tests and changeset lines. Keep XS refusing clone up front if the XS host still cannot support the simpler flow.
- State the exclusive-destination assumption in `designs/daemon-git-remotes.md` § Repository Bootstrap and `clone` and in the `provideGitClone` JSDoc in `packages/daemon/src/types.d.ts`. Remove the staging rationale, the precondition list, and the "simpler shapes considered" paragraph.
- Keep the other fix-round-2 changes: the bwrap init-kill → group-kill ordering, the git SIGKILL escalation, the changeset edits, and the floot changeset.
- Test the refuse-non-empty check and the failure cleanup, including that pre-existing content survives a failed clone.
- Push follow-up commits with scripts/jobs/gardening/safe-push-pr-head.sh and get CI green (scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1538 --no-merge).
- If the maintainer overrides with "keep staging", make no changes and report that.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T05:28:24Z
