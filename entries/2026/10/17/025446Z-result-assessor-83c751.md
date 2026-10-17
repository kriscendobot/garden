---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-17T02:54:48Z
job: kriscendobot-minion.town-pr178-gauntlet-panel-11
claim: 23c9bae2ddad8ffd
---
**Verdict:** request-changes

**Findings:**
- must-fix: `src/endo/git-remote/git-backend.ts:165-174` detects a chunked body only after the stream has started piping to `git http-backend`; `unpipe()` does not retract the `data` event already being dispatched, so its pipe listener can still write the over-limit chunk to the CGI before `SIGTERM` takes effect. `receive.maxInputSize` bounds the decoded pack, not the complete smart-HTTP request, so a valid receive request whose protocol framing makes the wire body exceed `maxBodyBytes` can still update a ref. This contradicts the documented invariant that every refusal occurs before a ref moves. Gate the stream before forwarding any chunk that would cross the cap, and add a valid chunked-push regression that proves the ref remains unchanged. [proposed-rule: A streamed request-size cap must prevent the over-limit bytes from reaching a state-changing backend; killing an already-fed backend is not an admission control boundary.]

Self-improvement: nothing this time.
