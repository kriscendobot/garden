role: fixer
Fix the deployed Kimi K3 Mystic handler compatibility with official Kimi Code 0.29.1. Live canaries kimi-k3-canary-20260723-c and -d both fail because scripts/jobs/handlers/mystic-kimi.sh invokes `kimi --prompt ... --yolo`; Kimi Code reports `Cannot combine --prompt with --yolo.` Prompt mode is already noninteractive. Remove the incompatible permission flag from fresh and resume invocations, add a regression that uses a fake CLI rejecting both --prompt+--auto and --prompt+--yolo, run the Mystic/worker-spine/completion/routing tests, push main2 directly, and report deployment readiness. Do not consume or print live credentials and do not requeue live canaries from the development worktree.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 13
  worker_kind: gardener
  claimed_at: 2026-07-25T00:21:59Z
