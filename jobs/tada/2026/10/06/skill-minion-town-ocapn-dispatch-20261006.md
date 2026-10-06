I landed `skills/minion-town-ocapn-dispatch/SKILL.md` on `main2` as a **"not yet usable" status page**, not a working procedure. Commit `2271be47dd3` is confirmed as the remote `main2` tip; it also adds the skill to the skill list in `CLAUDE.md`.

**Why it isn't a procedure:** the route to kriscendobot's guest on minion.town over OCapN is not switched on yet, and #693 is not what it's waiting for.
- **Transport:** #340 merged on 2026-08-25 (`5aeaa30e0`), so Endo's `llm` branch now has the OCapN-Noise TCP network layer (`setup-ocapn.js`, installed as `@nets/ocapn`).
- **#684, #688 and #693:** all three are still open drafts with no activity since 2026-08-31, and #684 has changes requested. The command-line round trip proved on #693 on 2026-07-17 went to the **demo** container behind `/ocapn-daemon`, which has no account guests. minion.town's `DEPLOYMENT.md` says outright that probes against the demo routes "never count as account federation".
- **The real route** is minion.town "guest-locator federation": an account hands out a locator for its guest, and a separate Endo daemon adopts it over TCP on port 8940. `DEPLOYMENT.md` marks it "built, NOT activated". The live account daemon has no OCapN network, and I checked that port 8940 is closed today. Its release gate is blocked on:
  - Endo #1335, the gateway authority fix (a hard blocker; still a draft).
  - An `ocapn-advertise-addr` setting in Endo, which hasn't landed.
  - #1124 and #1333 merging; both are drafts.
  - The maintainer answering the authority questions on #1332.
- **Already tracked:** the orchestration `endo-minion-town-guest-locator-federation` owns this work. Its release-gate, deploy and live-acceptance child jobs are parked in `jobs/plan/`, so I posted no parallel job.

**What's in the skill:**
- **Readiness check:** four commands that can be run today: are the PRs merged, has the release gate left `plan/`, is port 8940 open, and does `endo store` have a `--locator` option. I tested each one so it can't pass by mistake:
  - The guest-locator web address always redirects to login without signing in, so it can't show whether federation is on.
  - `endo paths --locator` already exists and would have given a false match.
- **Dispatch steps:** the planned shape of a send, clearly marked as unproven, with TODOs for:
  - which account the garden uses (jobs currently act as the shared test account `minion-mcp-test-cc`);
  - getting the locator without someone at a browser;
  - the final name of the adopt command (`endo adopt-locator` is being replaced by `endo store --locator`, #1333/#1360);
  - the actual send command.
- **Handling rules:** the locator is a secret anyone can use to reach the guest, so it is kept 0600 on the host and never committed or logged.
- **Notes:** the minion.town MCP connection is today's way to act *as* a guest, but it doesn't count as an OCapN dispatch, and the demo routes must never be used as a stand-in.

**Follow-ups:**
- When the live-acceptance child job finishes, someone should replace the TODOs with the commands it actually ran and remove the "not usable" marker; the notes section lists what to fill in.
- Open draft #1404 ("guests neither produce nor consume identifiers or locators") may change what a guest can receive, so check it before writing the send step.
- The maintainer still has to choose which account the garden sends as.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/skill-minion-town-ocapn-dispatch-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1551893 cached reads)
- Output: 14714 tokens
- Cost: $1.2392665999999997
- Wall-clock: 201s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
