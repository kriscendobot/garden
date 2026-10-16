Fix round 2 for kriscendobot/minion.town PR #193 is done: I applied the panel-2 must-fix items in one follow-up commit, pushed it, and CI is green on the new head.

**Pushed:** commit `32bab44` on `build/ocapn-guest-canary` (head moved from `21fb3cf` to `32bab44`) through `safe-push-pr-head.sh --mode advance`.

**Must-fix items applied:**
- **Single-use invitations and the wrong command** (breaker, engine-realist, integrator): the canary now binds each guest from its durable `endo://` locator with `endo adopt-locator --file`, which is the command DEPLOYMENT.md documents. The locator goes through a private temporary file, so it never appears in an argument list. A guest is adopted only when its pet name is missing, so later runs reuse the binding. A two-run test uses a fake that refuses a locator it has already redeemed.
- **Guests-file checks** (typist, saboteur, breaker):
  - The file must be a regular file, so a FIFO can't block the read.
  - Bad JSON is reported as `unparseable` with the file path only, never the content (the parser's message can quote locators).
  - Locators must be one-line `endo://` values, so bare formula IDs are refused.
  - `peerNames` must map other guests' names to strings.
  - Any malformed entry is reported as `malformed-guests` with the offending field, e.g. `guests[1].locator`.
- **`peerNames` test evidence** (prover): the fake now finds each recipient through the sender's own pet names and refuses unknown ones. With the mapping the run passes; without it, `message-send:alice->bob` fails.
- **Guarded, authenticated probe** (locksmith, wire-watcher; warden's comment): the probe is now a `makeExo` with an `M.interface` exposing one method, `prove(string) → string`. It holds a per-run proof the message never carries, and the check passes only if that proof comes back. A test confirms a substituted capability fails.
- **Leftover state** (wire-watcher): each run first clears canary messages and names left by an earlier run, such as a message that arrived after its poll gave up. Cleanup may now run up to 2 minutes past the run deadline. Tests cover both cases.
- **Hung CLI calls** (breaker): a child still running at the timeout gets SIGTERM, then SIGKILL, and the call returns either way. Tested with a child that ignores SIGTERM.
- **Rename** (stylist): `runId` is now `runIdentifier` throughout, including the audit record.
- **Design references** (archivist): I removed the references to the missing `root-canary-reader-identity.md` and the unrelated `root-canary-principal.md` sections. I added a DEPLOYMENT.md section, "OCapN guest canary", covering the guests file, exit status, audit records and installation. It names the exact `ORCHESTRATION-AUTH-UNAVAILABLE` signal.

**Other review items also handled:**
- **Corner-prober:**
  - Overlapping secrets are now scrubbed in one pass.
  - The pause between polls can't run past the poll deadline.
  - New tests cover message numbers `0` and `9007199254740993`.
- **Fast-checker:** added fast-check properties for `loadGuests` and `scrub`.
- **Spec-keeper:** the test now checks for a `TypeError` instead of V8's wording.
- **Pruner:** removed the provenance and narration comments, and shortened the PR body.
- **Gateway:** the PR body now explains why the test runs in the root `test.yml`.
- **Transplanter:** the systemd unit now reads its paths from a required environment file.
- **Scribe:** I posted the summary comment it asked for: https://github.com/kriscendobot/minion.town/pull/193#issuecomment-6213557675.

**Checks:** `node --test deploy/probe/ocapn-canary.test.mjs` passes 47/47. The spelling and cliché greps found nothing. `ci-wait-merge.sh --no-merge` exited 0 (green). The bot token can't read the status-check summary here, so the script fell back to the Actions runs API and could see only that one Actions run.

**Follow-ups:**
- The canary now depends on the guest-locator federation being enabled, and `endo adopt-locator` is still in a draft Endo PR (endojs/endo-but-for-bots#1333). The live-run successor job, `minion-town-ocapn-canary-live-run`, should confirm the real command and the shape of the `endo list` output.
- I did not act on coverage-auditor's comment: there is no c8 coverage report to check new lines against.
- The panel-3 stage will re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (3048197 cached reads)
- Output: 46725 tokens
- Cost: $2.5374194
- Wall-clock: 1223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
