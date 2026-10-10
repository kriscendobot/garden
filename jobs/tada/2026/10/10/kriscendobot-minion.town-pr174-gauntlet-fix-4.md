PR #174 fix round 4 (kriscendobot/minion.town) is pushed, and CI is green on the new head. I did not re-run the panel; the driver posts panel-5.

The round-4 panel comment is headed "must-fix", but none of its four jurors (assessor, typist, stylist, packager) asked for changes. The concrete items were two should-fixes, which I applied, plus a few cheap comment-only notes. They went in as one follow-up commit, `39a12d0`, pushed with `safe-push-pr-head.sh` as a fast-forward from `3e088a1`:

- **Torn final line in the ledger (assessor should-fix):** a final line with no newline is now kept only if it is a JSON object with a known `kind` (`grant`, `charge` or `refund`) and a decimal-string `amount`. Before, a tail like `123` was accepted, given a newline, and then broke every later operation when the gateway restarted. Any other tail is now dropped as torn. I added a regression test for the `123` case.
- **Env var name (stylist should-fix):** `CREDIT_LEDGER_DIR` is now `CREDIT_LEDGER_DIRECTORY`, matching the code's `creditLedgerDirectory`. The rename covers `src/config.ts`, `src/credits-cli.ts`, `.env.example`, `DEPLOYMENT.md` and the tests. In the tests I also renamed `env` to `environment` and changed the `"c-"` tmpdir prefix to `"credits-"`. The rename is done now because the variable hasn't been deployed yet.
- **Doc notes (comment-only):**
  - `LedgerRecord.amount` is documented as a decimal integer string.
  - The `refund` docs note that if writing the refund record fails, the user's retry is free rather than charged twice.
  - `PublishMeasure.contentRoot` notes that the metered processor requires it.

**Checks:**
- `tsc --noEmit` is clean, and the credit-metering suite passes (26 tests).
- The full local suite had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure…"). That file isn't touched by this diff, and CI's `test` job passed. I suspect the local git environment but didn't confirm it.
- I didn't run a formatter. The repo has no prettier config, and running prettier's defaults changed unrelated lines, so I reverted that. The `ledger.ready().catch(...)` line the packager flagged as long is unchanged.

**CI:** the first `ci-wait-merge.sh` run was stopped at the 10-minute background limit before it finished. I then watched the checks in the foreground until all three passed (`test`, Claude harness amd64 and arm64). A second bounded `ci-wait-merge.sh kriscendobot/minion.town 174 --no-merge` returned rc 0 ("CI GREEN", 3 checks, 0 failed).

**Left for later:** the remaining comment-only items. These are typist's per-kind record builders and `| undefined` in place of `| void`, stylist's two meanings of `log` and the `current`/`apply`/`post` names, and packager's squash-before-merge and import-order notes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1428645 cached reads)
- Output: 8385 tokens
- Cost: $0.9692130000000001
- Wall-clock: 1618s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
