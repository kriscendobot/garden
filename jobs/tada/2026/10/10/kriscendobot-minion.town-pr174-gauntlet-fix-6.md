**Gauntlet fix round 6 for kriscendobot/minion.town#174: all panel-6 must-fix items are applied, pushed as `dd4b591`, and CI is green.**

The first CI run failed in the "live-daemon B1 acceptance" job. The test that waits for the daemon to restart timed out at 120s. That job is known to fail intermittently, including on `main`, and this change does not touch that code. I re-ran only the failed job and it passed, so the rollup is green (3/3).

**Decomplector (must-fix): is the refund/hold mechanism needed?** It is not, so I removed it. A publish now checks the balance before storing anything (new `authorizePublish`, which refuses with `InsufficientCreditsError`). It is charged only after interning and registration, or the upgrade's directory write, succeed (`chargeForPublish`). A failed publish therefore never charges. That deletes:
- the refund records and the ledger's `refund` method;
- `PublishSettlement` and `refundAfter`;
- the hold shared between concurrent publishes of the same content;
- the `AggregateError` path when a refund also fails.

This also removes the optional `PublishSettlement | void` return the decomplector flagged (item 4).

The approach accepts two small leaks, both documented in `designs/ertp-credits.md` § 6a and `DEPLOYMENT.md`:
- **Bounded overdraft:** concurrent publishes can pass the balance check together and take the balance below zero by at most their combined price. The next check then refuses.
- **Unbilled publish:** if the charge fails to record after a successful publish, it is logged and the publish stays unbilled rather than reporting a live clip as failed.

**Breaker:**
- **Duplicate grants:** when the ledger is rebuilt from the log, it skips any record whose id was already applied. Two processes appending the same grant id now credit it once.
- **Malformed lines:** every line in the middle of the log is now checked as a real record (known kind, digit-only amount, string id and account). A bad one fails closed with its `ledger.jsonl:<line>` location; this catches `null`, `{}`, `"-5"` and similar.
- **Partial writes:** a failed append truncates the file back to its size before the write, so the next record can't be glued onto a torn line. This one has no test, because a partial write is hard to simulate.

**Surfacer:**
- **Operator command on a deployed host:** `DEPLOYMENT.md` now gives the command that works there, `sudo -u minion-mcp env GATEWAY_STORE_DIR=… node /opt/minion-town/dist/credits-cli.js grant|balance …`. That path matches `deploy-app.sh`, which ships the built `dist/src` as `dist/`. `npm run credits` stays for development checkouts.
- **Config tests:** added tests for `CLIP_METERING` and `CREDIT_LEDGER_DIRECTORY`, including the empty value that `.env.example` ships being treated as unset.

**Decomplector items 2 and 3:** § 6a now:
- links the maintainer's no-ERTP decision (kriscendobot/garden#58 comment 6073413592);
- says it replaces Phase 1 for the interim;
- names the ERTP v2 treasury as the single authoritative store at cutover, with each old store imported once;
- notes that re-publishing content already paid for is free.

**Tests:** typecheck is clean, and 76/76 pass in the affected suites. The full local suite had 980 passing and 1 failing: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". This change doesn't touch that file. I didn't check whether it fails without this change, but it passed in CI.

**Follow-ups, not done:**
- Decomplector item 5, collapsing the three torn-tail modes by having the CLI submit grants through the gateway.
- The surfacer's README mention of metering, which it rated a follow-up only.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4034171 cached reads)
- Output: 29189 tokens
- Cost: $2.3866142
- Wall-clock: 2164s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
