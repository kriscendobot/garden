model: gpt-5.6-terra
role: fixer
Fix and revalidate the Kimi K3 Mystic canary runtime in kriskowal/garden.

Observed live failure on both kimi-k3-canary-20260723-c and -d: scripts/jobs/gardener.sh line 481 calls reap_process_group, but the function is absent at runtime, so mystic/1 exits rc=1 immediately after the handler. Restore the helper in the shared worker spine/common library with its documented safety guards and add a regression that runs the real deployed call path, not only a sourced fixture. Re-run handler-orphan-reap, mystic-kimi-harness, worker-spine, completion, and routing tests.

Also audit and harden secret-safe Moonshot propagation against the established Anthropic path: garden passes ANTHROPIC_API_KEY via Docker -e at container creation; PID 1 -> systemd --user -> worker unit inheritance supplies it without embedding secrets in unit files. MOONSHOT_API_KEY should follow the same path, with deterministic presence-only diagnostics and documentation that existing containers require secret-safe recreation. Do not print, inspect, persist, or commit credential values.

After landing and deliberate deployment coordination, requeue exactly one reversible kimi-k3 canary, validate completion plus mystic/moonshot/kimi-k3 reputation scope, and return mystics to 0. Keep monks at 0 throughout. Preserve the failed canary evidence and use normal board/reaper contracts.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-24T07:13:45Z
