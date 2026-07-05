# Reaper requeues a claim while its handler is still ALIVE (duplicate live incarnations)

Evidence from job fable-review-fix-garden-scripts (2026-07-05): the job was
claimed at 17:17 (gardener-76) and requeued at 17:35 (gardener-65) and again at
17:53 (gardener-2) — ~18 minutes per cycle, while GARDEN_HANDLER_TIMEOUT is
2400s (40 min) — and BOTH times the prior incarnation's `claude -p` handler was
still running and kept editing the same per-job worktree (pids 675968, 1087460;
the resumed session had to SIGTERM its own predecessor to avoid two-writer
corruption). Either GARDEN_CLAIM_TTL is far below the handler wall on this
host, a reap-now hint is being stamped spuriously (a deploy-restart SIGTERM to
the gardener wrapper while the handler survives orphaned?), or the requeue path
does not kill the displaced handler. Diagnose from the journal claim history +
host journalctl for that window, then fix so a requeue either kills the old
handler's process group or does not fire while it is alive. This is a data-
corruption class: two live incarnations share one worktree.

---
claim:
  host: endolinbot
  gardener: 8
  claimed_at: 2026-07-05T20:39:51Z
