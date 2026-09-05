---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Improve garden economics and resilience

Audit the current cybernetics and budget machinery before proposing any change. Read the recent credit-investigation report plus the existing designs around live budget admission, session pacing, quota throttling, recurring budget calibration, manual gauntlet triggering, and the cybernetics audit. Verify which of the requested behaviors are already implemented in the recent upgrade and narrow the result to the remaining delta.

Produce a design at `designs/cybernetics-economic-resilience.md` that improves the garden's economics and resilience without regressing deployed behavior. The design should cover:

- one overrun, with no retry, as sufficient just cause to split a job and propagate omega score upward through parent jobs;
- retries only after back-off, and only for quota bump / quota recovery cases;
- triager pacing from estimated job cost so it wakes when enough tokens are projected to be released for the next job;
- durable journal visibility for each cybernetic input and output, with clear provenance and outcome tracking.

If any of these behaviors already exist, say so explicitly and keep the design focused on the missing pieces. Keep unresolved choices in an open-questions section rather than guessing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-05T16:03:31Z
