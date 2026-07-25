model: gpt-5.6-terra
role: fixer
Fix the garden container API-key handoff to the lingering systemd --user manager. Docker passes ANTHROPIC_API_KEY and MOONSHOT_API_KEY into PID 1, but user@<uid>.service starts via PAM with a fresh environment, so user units receive neither key. Implement a boot-time, allowlist-only, tmpfs-only handoff such as a systemd user environment generator seeded by entrypoint.sh; never persist secret values in the bind-mounted home, repository, units, or logs. Cover both keys, add regression tests, correct launcher/runbook claims, push main2 directly, and report deploy readiness. Do not inspect live credential values.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-25T00:26:00Z
