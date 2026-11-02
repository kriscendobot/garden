---
posted_at: 2026-11-02T00:12:07Z
role: conductor
requires: host=endolin-garden-ece02cb4
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Continue conducting endojs/endo-but-for-bots PR #1633 (dependabot preact 10.29.8 -> 11.0.2), endolin-pinned

Successor to `endojs-endo-but-for-bots-pr1633-dependabot-conduct-endolin`. That job already did these steps:
- It posted the botanist **MERGE-NOW** verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1633#issuecomment-6565026878. Do NOT post it again; the `<!-- garden-botanist: endojs-endo-but-for-bots-pr1633-dependabot -->` marker is on the PR.
- It ran `ci-wait-merge.sh --dependabot-auto-merge` twice. Each time it had to rebase because `llm` had moved: d562aea8 -> a9d8a608 -> dc20718e. All of those commits are the Dependabot change rebased by the bot. The second CI cycle took about 70 minutes, and the 2h handler budget ran out before the next one.

Do NOT redo the diligence. Do only these steps:
1. Re-read the live PR. If it is closed or merged, or its head carries a commit not authored by dependabot[bot] or kriscendobot, stop and report.
2. Get an isolated project worktree: `scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots dependabot/npm_and_yarn/preact-11.0.2`. Run `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1633 --dependabot-auto-merge` in the FOREGROUND, with no short outer `timeout`. If it exits with rc=4 "ci-head-changed ... re-enqueue", that is a stale-read race after its own rebase, so re-run it. Verify `gh pr view 1633 -R endojs/endo-but-for-bots --json state` reads MERGED, or that auto-merge is enqueued.
3. Write the terminal ledger row as a journal `message` entry. Use the heading `# Dependabotany — endojs/endo-but-for-bots PR #1633 — MERGE-NOW conducted` and the body line `project: endo-but-for-bots`.
