---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/check-container-hardening.sh
The garden-container-hardening.service failed with systemd result='timeout' (started 06:17, killed at 06:19 after TimeoutStartSec=120) instead of exiting cleanly — a systemd-timeout kill isn't covered by the unit's SuccessExitStatus list, so self-heal-run.sh never got to hash a capture or spawn a diagnostic responder; the failure just surfaced as an opaque Failed unit.

Root cause: logged_in_gh_logins() and env_token_maintainer_login() call the REAL gh binary via real_gh_bin(), deliberately bypassing the fleet identity wrapper (scripts/jobs/bin/gh) so a leaked maintainer credential can't be masked by the wrapper's identity pin. But that wrapper is also the fleet's only gh hang-protection (GARDEN_GH_TIMEOUT=60s via `timeout --signal=TERM --kill-after=10s`), added specifically because a raw gh call can stall unboundedly on a stuck TCP connect/DNS/credential-helper prompt (garden-comment-watcher@ hit this exact class on 2026-09-18). Bypassing the wrapper for identity-safety reasons threw away the timeout too.

Fix: wrap the `gh auth status --json hosts` call and the `gh api user` call in check-container-hardening.sh with an explicit `timeout` (e.g. `timeout --signal=TERM --kill-after=10s 15s "$gh" ...`), independent of the identity wrapper, so a stalled network call degrades to the existing "gh unavailable" fallback path (hosts.yml parse / rc 0 with no offenders) well inside the service's 120s TimeoutStartSec, instead of exhausting it and bypassing self-heal's diagnostic capture.
