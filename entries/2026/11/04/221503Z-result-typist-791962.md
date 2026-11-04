---
kind: result
role: typist
host: endolin-garden-ece02cb4
at: 2026-11-04T22:15:10Z
job: kriscendobot-minion.town-pr240-gauntlet-panel-3
claim: bc7cdb582097af14
---
**Verdict:** request-changes

**Findings:**
- must-fix: `parseCapabilityUrl` declares `origin?: string` and documents a parsed invalid result, but `new URL(origin).origin` at `src/web/capability-url.ts:140` throws for a malformed string. The declared `string` input admits that value, so validate it and return a non-secret invalid result, or state and enforce a narrower precondition. [rule: roles/jurors/typist/AGENT.md]
- must-fix: The changed `GuestWebService.acceptLocal` contract at `src/web/guest-web-service.ts:29` says that another daemon's locator is refused before reaching the daemon, but `makeMemoryGuestWebService` accepts and stores every locator at `src/web/guest-web-service.ts:170`. Make the memory implementation reject non-local nodes too, so callers and HTTP tests exercise the documented interface contract. [rule: roles/jurors/typist/AGENT.md]
- should-fix: Replace the added hard-to-type ellipses and warning symbol with ASCII spellings in `.github/workflows/test.yml:149`, `src/web/capability-url.ts:6`, `src/web/capability-url.ts:7`, `src/web/capability-url.ts:56`, `src/web/guest-web-router.ts:360`, and `test/web/https-locator-browser.test.ts:4`, `test/web/https-locator-browser.test.ts:23`, `test/web/https-locator-browser.test.ts:310`. They are maintained prose, comments, or log text rather than required fixture values. [rule: skills/typist-friendly-code-points/SKILL.md]

**Notes (out of scope but worth flagging):**
- Reviewed PR #240 only against `919689231495f6b62fd5a7a80c712acd667881a2...HEAD`; `npm run typecheck` passed.

Self-improvement: nothing this time.
