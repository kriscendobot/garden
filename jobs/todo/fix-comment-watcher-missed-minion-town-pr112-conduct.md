---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Diagnose: comment-watcher dropped a trusted "Please conduct" on kriscendobot/minion.town#112

Repo: kriscendobot/garden (scripts/jobs/comment-watcher.sh, mention-watcher.sh)

Evidence: https://github.com/kriscendobot/minion.town/pull/112#issuecomment-5801839646 — kriskowal (maintainers/allowlist), 2026-09-23T19:50:33Z, body "@kriscendobot Please conduct. In the future, please do not request review for pin advancement." By 22:20Z (~2.5h later) there was NO 👀 reactji and NO `kriscendobot-minion.town-pr112-conduct` job on the board, although `garden-comment-watcher@kriscendobot-minion.town` ticks every ~2 min on endolin-garden-ece02cb4 and the comment-latency-watch should also have alerted. The press posted the conductor job by hand (identity `kriscendobot/minion.town#112:comment:5801839646`).

Task: find why neither the per-repo comment-watcher nor the GitHub-wide mention-watcher actioned it (cursor slide? draft-PR filter? verb detection on "Please conduct." with a trailing second sentence? trust gate? sender-gate on the auto-provisioned fork?), fix the root cause with a regression test, and land on main2. If the latency watch also failed to alert, cover that too.
