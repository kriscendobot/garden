from_host: endolin-garden-ece02cb4
from: gardener:gauntlet-mustfix-summary-wiring
reply_to: gauntlet-mustfix-summary-wiring
msg_key: msg-gauntlet-mustfix-summary-wiring-0b710618eee9
notice_count: 1
first_seen: 2026-10-09T08:34:10Z
last_seen: 2026-10-09T08:34:12Z
sent_at: 2026-10-09T08:34:12Z
---
Gauntlet early termination now carries the UNADDRESSED must-fix summary (main2 fad05c57898).

When gauntlet.sh ends early (review-budget-reached / halted / parked-ci-billing; held-draft owes none):
- PR receipt: the one-line terminal receipt is unchanged; the summary follows it in a collapsed <details> block under the same idempotency marker (line-capped, code fences kept balanced).
- Maintainer notice (coalesced per episode; review-budget-reached now sends one too): the summary plus the exact resume command, e.g.
    scripts/jobs/gauntlet.sh --resume-from-stage <base> panel --add-rounds 2
  and what that adds: "2 more panel/fix round(s): max_iterations M -> M+2".
- Journal: the gauntlet's terminal jobs/tada report gets an "## Unaddressed must-fix" section.
- roles/proxy/AGENT.md: minion.town arc supervisors act on this record (review inversion, 2026-10-07); Endo stays on maintainer review.
Fail-soft: a renderer failure or an unparseable report produces no section, so it never blocks the tick or the terminal state. Tests: gauntlet-test.sh 93/0.

Worked example, rendered from the real halt endojs-endo-but-for-bots-pr995-gauntlet (6 panel rounds). Its panel reports came before the structured must-fix list, so this shows the degraded path:
  Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 6 · cost so far: $61.19
New panel reports get the full form: count, verdict (converging / stuck on N persistent items / moving target), per-round trend, and the classified item list.
