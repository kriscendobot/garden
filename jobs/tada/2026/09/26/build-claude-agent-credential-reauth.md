I built the credential-expiry detection and root-notification half of the design and opened it as draft PR https://github.com/kriscendobot/minion.town/pull/119. CI is green, the pre-push gates pass, and `npm test` passes (498 tests, 7 skipped).

**Scope differs from the job brief.** The brief asked for an `@operator` binding and a single-use `ReauthTicket` mailed over ocap-mailboxes. The version kriskowal approved (review 5324704742, #96 head `177c39d`) removed both and kept only the root-user case. They are now in the design's deferred follow-up. I built the approved design and say so in the PR body. I did not build the browser OAuth relay either. Until it lands, reauthentication is the manual `claude setup-token` entry over HTTPS.

**What the PR does:**
- **Detection:**
  - One helper sorts every `infer` result into a single class. Only a rejected credential triggers reauthentication; rate limits, model overload, harness bounds and spent usage never do.
  - A second function reads raw CLI or provider responses against a table of response shapes that a canary run records. It fails closed: an unknown version, non-JSON output, no match, or an ambiguous budget-versus-auth response is treated as "unclassified", never as an expired credential.
  - A new `usage-exhausted` result joins `infer()`, with a reset time for a subscription window and none for a spend cap.
- **Both entry points:**
  - `infer` and `create` both report a rejected credential to the same trigger on the host.
  - A rejected credential is marked lapsed, so every sibling agent reports `needs-auth` until the root reconnects.
- **Notification** (`src/endo/claude/reauth.ts`):
  - Each root gets at most one open event and one notice, even when siblings fail concurrently.
  - The event, the list of parked agents and pending notices survive a restart when a state file is configured.
  - Failed deliveries retry with backoff. After the park ceiling the event is marked abandoned and raises an operational alert, and the work stays parked.
  - Usage notices, a diagnostic notice for repeated unrecognized failures, and a once-per-expiry renewal reminder use the same channel.
  - An explicit disconnect by the root dismisses the event.
  - A successful reconnect that passes the credential probe clears the event and wakes parked agents.
- **Account page:** `GET /account/claude` is the fixed link every notice carries. Only the root can view it, and it creates a fresh 10-minute connect link only after the root logs in, so a late notice never holds a stale link.
- **Deployment settings:** notices go to a webhook set by `ENDO_CLAUDE_NOTIFY_WEBHOOK_URL`. With no webhook configured, delivery fails into an operational alert rather than pretending to notify. There are new `ENDO_CLAUDE_*` settings for the state file and the three time limits, and a 60-second timer drives retries and time limits.

**Tests:** `test/claude-reauth.test.ts` adds 19 tests covering every acceptance item that doesn't need production infrastructure. I broke the dedupe, the `create` trigger and the ambiguity check in turn, and the matching tests failed each time.

I renamed the local `ctx` parameter to `context` throughout `src/endo/claude/agents.ts`, because the spell-out gate rejected the new lines that used it. The PR's base is a new pinned branch, `main-561472a`, cut after #96 merged.

**Follow-ups:**
- Per the brief, I did not post a gauntlet; the blocked job `build-claude-agent-credential-reauth-run-gauntlet` will post it for #119.
- Nothing is recognized as an expired credential until a canary run records the real CLI and provider response shapes for one pinned CLI version, and nothing currently records them.
- Production still needs a notification channel set in `ENDO_CLAUDE_NOTIFY_WEBHOOK_URL` and a state file set in `ENDO_CLAUDE_REAUTH_STATE_PATH`.
- A validating job still has to collect the production evidence the design asks for: a real browser run, a real notification channel and a real `claude -p` spawn.
- Wiring the wake-up into the agent loop and storing credentials durably both wait on the unmerged confinement work in endojs/endo-but-for-bots#1015.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-claude-agent-credential-reauth.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (5098070 cached reads)
- Output: 56650 tokens
- Cost: $3.366646
- Wall-clock: 1023s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
