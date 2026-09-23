---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 500
created_at: 2026-06-22T03:44:43Z
last_appended_at: 2026-06-22T03:44:43Z
status: parked
---

# Follow-ups for endo-but-for-bots#500

## Items

- [ ] Self-cycle behavior: can a caller pass the caplet being composed as its own `powers` argument, creating a `['powers', id]` self-edge in the formula graph? Investigate whether the daemon's persistence and collection layers handle self-referential formula graphs correctly.
  **Source juror(s)**: corner-prober, locksmith
  **Round**: 1
  **Recommended action**: open a follow-up investigation issue on endojs/endo-but-for-bots naming the self-cycle scenario; pair with a unit test if the behavior is defined.

- [ ] M.splitRecord shape for MakeCapletOptionsShape does not encode the `powers`/`powersName` mutual-exclusion constraint at the guard level; the runtime check in host.js is the only enforcement. Follow-up once the pattern-rule lands in AGENTS.md.
  **Source juror(s)**: breaker
  **Round**: 1
  **Recommended action**: open a follow-up PR adding the M.or shape once the pattern-rule is established.

- [ ] Master-base mirror PR: this PR targets the `llm` branch; whether these daemon additions (by-reference powers, retainUntil) should land on `master` as well is not stated in the PR description.
  **Source juror(s)**: integrator
  **Round**: 1
  **Recommended action**: ask the author (kumavis) or kriskowal whether a master-based mirror PR is wanted; open one if yes.
