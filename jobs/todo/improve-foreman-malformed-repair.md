---
posted_at: 2026-10-30T00:21:13Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/foreman-claude.sh
scripts/jobs/handlers/foreman-claude.sh:468-473 turns OpenAI’s malformed semantic reply at 2026-10-30T00:14:31Z into a fatal pump failure, despite a recoverable single-provider format error.
Add one bounded same-provider repair attempt with a fixed protocol-only correction prompt, preserving fail-closed rejection and prohibiting cross-provider fallback.
