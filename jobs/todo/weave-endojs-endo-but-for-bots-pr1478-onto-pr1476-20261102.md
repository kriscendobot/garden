---
role: weaver
tier: mentor
arc: minion-town-mcp-ocapn
posted_at: 2026-11-02T00:08:36Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-02T03:22:57Z cleared=none -->

---
role: weaver
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Weave endojs/endo-but-for-bots#1478 onto #1476's current head

PR: https://github.com/endojs/endo-but-for-bots/pull/1478 (draft; Phase 2 of the ocapn-noise session-reconnect stack; stacked on #1476).

The preceding orchestration child rewove #1476 (head `build/ocapn-noise-session-reconnect-heartbeat`) onto a fresh `llm` snapshot. Now pin #1478's merge base: snapshot #1476's CURRENT head to a new frozen `build/ocapn-noise-session-reconnect-heartbeat-<short-sha>`, rebase ONLY #1478's own commits (those in `build/ocapn-noise-session-reconnect-heartbeat-9175a5b..build/ocapn-noise-session-queue`, 19 commits, head e8222fc4b5) onto it with `git rebase --onto`, resolve conflicts, force-push `build/ocapn-noise-session-queue`, and move the PR's base field to the new snapshot (skills/frozen-base-branch, skills/stacked-pr-build).

Expect conflicts in `packages/ocapn-noise/src/network.js` and its tests: #1476 gained 10 commits after the 9175a5b snapshot (notably 181f7dcf1f "close the session when its transport fails", cc884de175 "absorb heartbeats in the session reader"), and #1478 reworks the same write path (`fail`/`enqueue`/`drain` outbound queue). Keep the behavior of both sides, and keep #1478's diff limited to its own work.

Watch CI to green: `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1478 --no-merge`. The old red (bwrap sandbox tests from the stale base) should be gone; investigate any red that remains. Leave the PR draft and do not touch #1481–#1483 (they are based on frozen snapshots of the old #1478 head; they need their own weave later). Report the new head SHA.

