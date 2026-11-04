Fix round 2 for kriscendobot/minion.town PR #245 is pushed as `bbcf120c` on `feat/api-key-agent-responder-ui`, and CI is green (7 of 7 checks, `ci-wait-merge` rc 0). There was no pre-pass block for this round, so I worked from the latest panel review (5776944437, "Must-fix before merge").

**What I changed for each juror:**
- **saboteur and breaker (out-of-order replies):** mail actions in `deploy/aws/www/provider-ui.js` now run one at a time. Every mail button is disabled until the reply comes back. A version number goes up on each redraw; if the view has changed by the time a reply arrives, the reply is dropped and the agent is reloaded from the server instead.
- **breaker (stale status after Retry):** a retry only queues the message, so the view now re-reads the agent every 2s, up to 15 times, until the message is answered or held again.
- **breaker (test fake):** `test/_fake-agents.ts` now treats `retryMail` like the real responder: it moves a held message into an `admitted` list and leaves it unread. Retrying a message that isn't held does nothing.
- **wire-watcher (retry replayed after a lost reply):** I documented on `OwnerAgents.retryMail` that it is safe to repeat. A message number that isn't held is a no-op, so a reconnect replay can't run or bill a message twice. An endpoint test checks that two calls admit the message only once. This is enforced only in our fake and in the interface doc; I could not check what the real daemon does.
- **spec-keeper and corner-prober (`retryAt` dates):** the UI now accepts only full ISO timestamps with an explicit time zone, including 6-digit extended years. Anything else shows "soon". The time is formatted from its UTC parts, so extended years read correctly. New browser cases cover `+010000`, `-000001`, a timestamp with no time zone, and a slash-separated date.
- **migrator (Phase 4 deployments):** I gated the button on what the daemon reports instead of bumping the Endo pin. **Retry now** appears only for mail the daemon reports as held, and only the Phase 5 responder reports holds. This is noted in a code comment, in `DEPLOYMENT.md` next to the `API_KEY_GUEST_AGENTS` entry, and in the PR body.
- **purist:** `attempts` is no longer sent in the HTTP response.
- **corner-prober (route limits):** the retry route now has tests that `0` and a 31-digit number are accepted, and that `01` and a 32-digit number are rejected.
- **changeset-auditor:** the changeset now has one sentence per line, and the stale `API_KEY_GUEST_AGENTS` qualifier is gone.
- **pruner:** I removed the sentence about Endo owning the responder from "Why". I also replaced the four-bullet "What to attend to" list with one line about the Phase 5 requirement.

**Local checks:** `tsc` is clean, and the endpoint and Chromium browser tests pass. Firefox and WebKit were skipped locally, as before. The full `npm test` run had one failure: `test/git-remote/capability.test.ts › propagates a git failure rather than reporting the ref absent`. That test is outside this diff, and I believe it is the known local git-wrapper false failure. CI passed.

**Follow-ups:** the endo-but-for-bots#1649 responder should follow the same rule, where retrying a message that isn't held does nothing. The panel re-run is left to the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr245-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1760808 cached reads)
- Output: 15764 tokens
- Cost: $1.2916176
- Wall-clock: 624s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
