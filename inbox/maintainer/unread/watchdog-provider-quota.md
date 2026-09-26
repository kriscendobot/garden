from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-26T02:25:10Z
watchdog_key: provider-quota
notice_count: 1
first_seen: 2026-09-26T02:25:09Z
last_seen: 2026-09-26T02:25:10Z
---
provider quota/usage limit reached: the API is refusing calls fleet-wide.
limit_type: unknown
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden-ece02cb4):
provider quota exceeded while running garden-mentor. Observed: ## Diagnosis

The captured log shows all three of `garden-mentor`'s configured inference providers were simultaneously unavailable at 02:20 UTC:

1. `openai` (codex-endolin) — subscription quota at high water, skipped (rc=10)
2. `local` (hermit) — this lane is permanently retired/pinned inert at `hermits: 0` (2026-09-13 maintainer decision), so it always fails this check
3. `anthropic` — Cla — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob 95eb95809d17c850361bce33f8bbf7fcbeef8057 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 95eb95809d17c850361bce33f8bbf7fcbeef8057).
