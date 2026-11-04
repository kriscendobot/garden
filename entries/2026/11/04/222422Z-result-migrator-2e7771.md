---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-11-04T22:24:51Z
job: kriscendobot-minion.town-pr236-gauntlet-panel-6
claim: ba50556f97c26510
---
Originating dispatch: user request to review kriscendobot/minion.town PR #236 against 919689231495f6b62fd5a7a80c712acd667881a2.

**Verdict:** request-changes

**Findings:**
- **must-fix** `src/web/guest-web-socket-service.ts:470-477` changes `inviteRemote` from minting (and thereby replacing) an existing remote invitation to rejecting it with `GuestNameConflictError`, exposed by `POST /api/guest/invitations` as HTTP 409 (`src/web/guest-web-router.ts:283-294,470-472`). Prior clients, including the shipped caller at `deploy/aws/www/home.js:281-285`, were permitted to retry a remote invitation under the same pet name and receive 201. `.changeset/remote-invitation-hints.md:2` labels that explicitly breaking outcome a `minor`; change the release classification to `major` and retain the migration instruction already in the body. [rule: roles/jurors/migrator/AGENT.md § Operating norms]

Self-improvement: nothing this time.
