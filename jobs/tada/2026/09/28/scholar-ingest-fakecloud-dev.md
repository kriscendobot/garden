## Completion report: scholar-ingest-fakecloud-dev

**Verdict:** fakecloud fits minion.town's AWS testing, but only for part of it.
- **DynamoDB adapters: strong fit.** These are the app's only AWS SDK use (`@aws-sdk/client-dynamodb`), and today they never run outside production. The account-store adapter has no test at all. The credit ledger is tested only for the shape of the commands it builds, against a fake `send()` that invents `TransactionCanceledException` results. fakecloud's DynamoDB is graded Full/Full with transactions, so CI could run the conditional writes and exactly-once logic for real.
- **Cognito: useful upgrade for CI.** fakecloud issues real RS256 tokens shaped like Cognito's and runs the PreTokenGeneration Lambda. The current `dev/mock-as.ts` imitates Cognito by hand, and even sets an `aud` claim real Cognito never issues.
- **Secrets Manager and S3: fit, but low value.** Only the deploy tooling and one Lambda use them.
- **Gaps:** SSM `send-command` deploy delivery (SSM's data plane is only Partial), App Runner (not emulated), and the `dynamodb:Attributes` IAM condition (enforcement not documented).

**Library ingestion** (all new sources, so the idempotency check passed trivially; fetched directly with `fetch-source.sh`)
- `web--fakecloud-llms-txt`: 4 sections
- `web--fakecloud-parity`: 4 sections
- `web--fakecloud-home`: 1 section
- New topic `cloud-emulation` (the library had nowhere to file provider-API emulators) and new concept `fakecloud`.
- Added rows to the `testing`, `oauth-credentials` and `tooling` topics, plus the sources, topics and concepts READMEs and a `keywords.md` line.

**Project tree**
- New `journal/projects/minion-town/fakecloud-aws-emulation-fit.md`, with a row in the project README. I checked it against the minion.town repo at `f69bf87` rather than trusting the README's service list.
- It covers three layers: app runtime, protocol-level Cognito, and deploy tooling. It includes a service-by-service fit table citing the library sections, and a recommendation.
- **Recommended builds for the liaison to post** (I did not post them): `build-minion-town-fakecloud-dynamodb-tier`, an opt-in CI tier using `/_fakecloud/reset` that keeps mock-as and the in-memory stores for dev; and optionally `build-minion-town-fakecloud-cognito-tier`.

**Gates and landing**
- `library-link-check --changed` passed.
- The topic-count check found only stale counts, which the regenerator fixes; no topic page was missing.
- All 23 files landed through `land-journal-edit.sh`, with base-blob checks on the shared indexes. Both regenerators then ran and landed.
- Result entry: `entries/2026/09/28/052433Z-result-scholar-37b4ad.md`. The maintainer digest was delivered, and my inbox was empty.

**Follow-on posted:** `scholar-ingest-fakecloud-dev-services-sdks`, covering `docs/services` and `docs/sdks`. It will settle what the ingested pages leave open: S3 presigned URLs, SSM Run Command, the IAM condition keys, whether fakecloud reports transaction-cancellation reasons like AWS does, and the TypeScript SDK's license.

**Self-improvement:** `scholar-staging-clone.sh` failed three times at the default 45s `GARDEN_FETCH_TIMEOUT`, because a full `journal2` clone takes longer than that. It worked with `GARDEN_FETCH_TIMEOUT=600`, and later landings were also slow (about 10–20s each). A fresh staging clone should get a longer timeout, or clone shallow or from a reference, rather than report "offline". This should go to the mentor/liaison as a script fix; I did not change the script.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-fakecloud-dev.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5645032 cached reads)
- Output: 39356 tokens
- Cost: $3.1830784000000008
- Wall-clock: 1287s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
