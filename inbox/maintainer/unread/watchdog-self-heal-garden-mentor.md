from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-01T18:54:01Z
watchdog_key: self-heal-garden-mentor
notice_count: 1
first_seen: 2026-08-01T18:54:01Z
last_seen: 2026-08-01T18:54:01Z
---
self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: d60fc6814bbc2d5d507020e4ef0d84a11c7bdbd7 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p d60fc6814bbc2d5d507020e4ef0d84a11c7bdbd7). Diagnosis: ## Diagnosis: `garden-mentor` exit 1 — already-filed fix is poison-parked behind a go-ahead gate

**Failure chain.** `mentor-claude.sh:162` dies with `mentor provider 'openai' returned malformed semantic output; refusing fallback…`, and `mentor.sh:145` then dies (`is_transient_claude_signature` / `_fetch_stderr_is_offline` correctly don't match, so it takes the real-defect branch). Not transient: it has fired on **every** tick that actually reached the provider — 11:20:56, 11:50:49, 18:50:53 today, and per the existing job body 9× since 2026-07-29. The intervening ticks all exited in ~5.7s at `mentor.sh:73` (empty digest), so the provider-reaching path is failing 100% of the time, not flaking.

**Root cause (already established, not re-derived).** `validate_mentor_response` (`mentor
