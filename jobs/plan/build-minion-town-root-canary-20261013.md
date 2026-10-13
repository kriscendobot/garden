---
gate: blocked
blocked_on: kriscendobot-minion-town-pr167-record-answers-20261013
priority: normal
posted_by: producer
posted_at: 2026-10-13T16:43:18Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the root canary principal (kriscendobot/minion.town design PR #167)

Build what `designs/root-canary-principal.md` § Build scope specifies, after the design update `kriscendobot-minion-town-pr167-record-answers-20261013` lands. Read the Decisions section it adds first: root over MCP is accepted for kriscendobot's production root; the mint script runs on `endolin-garden1` only; the reader role is assumable only by `endolin-garden1`; 90-day refresh token; no sub-cap.

Constraints from the maintainer (kriskowal, 2026-10-13):
- The sign-in is interactive. Do not try to automate GitHub login. A canary job must be able to queue and wait until the maintainer logs in; the liaison will raise it in a muster message. Build the scripts and runbook so that state ("awaiting login") is explicit and reports as waiting, not failing.
- Do the build scope's item 0 (verification spike) only as far as it needs no human sign-in; mark the rest as pending the login.
- Keep it economical: claude-endolin1 is at 78% and the fleet was asked to slow down. Open a DRAFT PR on kriscendobot/minion.town. The completion machinery stages the gauntlet; do not stage extra rounds.
- Do not weaken any existing confinement or allowlist beyond what the design specifies.
