## Fix round 9: kriscendobot/minion.town#174

I applied the panel-9 must-fix items in one follow-up commit and pushed it to the PR head (`c9ac17a..623d5c4`). CI came back green on all three checks (test, Claude harness amd64, Claude harness arm64). One must-fix item, the decomplector's first, needs a maintainer decision; I've asked for it but have no answer yet.

**Must-fix items:**
- **Decomplector 2 (move the hold into the ledger):** The ledger now owns the reservation. `AccountCharge.reserve(id, amount)` returns a one-shot `{settle, cancel}` and runs in the ledger's own serializer. The processor's `held` map and separate queue are gone, so the processor only sets the price.
- **Integrator 1 (two names for one mechanism):** The code now uses the reserve / settle / cancel words from `designs/clip-usage-metering.md` § 4. `authorizePublish` became `reservePublish` and `PublishAuthorization` became `PublishReservation`. § 6a of the design states the mapping, including what each step becomes under ERTP v2 (`withdraw` and deposit).
- **Archivist 1 (re-publish should be free):** Re-publishing content that is already paid for reserves nothing, so it is never refused for lack of funds. This now matches the design text, and a new test covers an account with a zero balance. Two publishes of the same content at the same time now share one reservation (this also clears breaker's comment 3).
- **Prover 1 and 2 (cancel sites not pinned by tests):** After each failure (failed store, failed upgrade write), the tests now reserve the account's full balance for different content, so a leaked reservation would make them fail. I deleted each of the three `cancel` calls in `publish.ts` in turn, and the tests failed every time.
- **Decomplector 1 (does "no ERTP" also waive durable reservations and Endo/DynamoDB persistence?):** This one I can't settle myself. I sent the question to the maintainer with `message-user.sh`. § 6a now names both departures as deliberate for the interim, pending that confirmation.

**Should-fix items also done:**
- **Purist:** reservations, processors and ledger records are frozen; the stub processor is now one-shot too; `InsufficientCreditsError` now reports the amount available rather than the raw balance.
- **Breaker 2:** when an append fails, the cleanup now cuts only the bytes this write added, so it can no longer erase a grant the operator CLI wrote at the same moment.
- **Integrator:** updated the design doc's Status line, added a § 7 Phase 1 pointer to § 6a, removed "this PR" from the design text, and made DEPLOYMENT.md use the same verbs as the design.
- **Pruner:** cut repeated explanations from § 6a, `.env.example`, the CLI header, the ledger header and the processor JSDoc.
- **Archivist comment:** the comment and DEPLOYMENT.md text about a torn final line now say exactly when it is dropped and when it is kept.

**Checks:** typecheck is clean and the credit-metering, gateway/publish and config tests pass (74/74). In the full local suite, one test failed: `git-remote/capability.test.ts > propagates a git failure`. That file isn't touched by this change, and CI runs the same suite and passed, so I think the failure comes from this machine's setup.

**Not done:**
- The maintainer's answer to decomplector 1 is still pending.
- I did not regroup the PR's ten commits into logical commits (integrator and packager raised this as should-fix). That needs a history rewrite, which would fit a retcon better than a fix round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3371961 cached reads)
- Output: 25314 tokens
- Cost: $2.1194962000000004
- Wall-clock: 1810s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
