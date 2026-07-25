role: builder
Fix the garden container API-key handoff to the lingering systemd --user manager. The launcher correctly passes ANTHROPIC_API_KEY and MOONSHOT_API_KEY into the container/PID 1, but user@<uid>.service starts via PAM with a fresh environment, so user units receive neither key even while interactive shells do. Implement a boot-time, allowlist-only, tmpfs-only handoff (for example a systemd user environment generator seeded by entrypoint.sh) that never persists secret values in the bind-mounted home, repository, unit files, or logs. Cover both API keys, add regression tests, correct misleading launcher/runbook comments, and verify a recreated container exposes presence through systemctl --user show-environment without printing values. This is garden repository work; push main2 directly per repository convention.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-25T00:19:11Z
