---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-28T05:24:36Z
---
# result: scholar-ingest-fakecloud-dev

Job: scholar-ingest-fakecloud-dev (role scholar). Ingested fakecloud.dev and cross-referenced it against minion.town's AWS-testing surface.

## Library ingestion (all new; there were no prior anchors, so the idempotency check passed trivially)
- `library/sources/web--fakecloud-llms-txt.md`: 4 sections. https://fakecloud.dev/llms.txt, sha256 7da05536…
- `library/sources/web--fakecloud-parity.md`: 4 sections. https://fakecloud.dev/docs/parity, sha256 ee0e08c4…
- `library/sources/web--fakecloud-home.md`: 1 section. https://fakecloud.dev/, sha256 ae003046…
- All three were fetched directly through fetch-source.sh. 9 section files in total.
- New topic `library/topics/cloud-emulation.md` (rationale: the corpus had no home for provider-API emulators; `testing` is endo-centric and `sandbox-platforms` covers isolation). Rows were also added to the `testing`, `oauth-credentials`, and `tooling` topics.
- New concept `library/concepts/fakecloud.md`, plus a keywords.md line and index rows in the sources, topics, and concepts READMEs.

## Project tree
- New `projects/minion-town/fakecloud-aws-emulation-fit.md` and a README row. Surveyed against kriscendobot/minion.town main @ f69bf87.
- Verdict: fakecloud fits, but narrowly.
  - The DynamoDB adapters are the high-value close fit. `@aws-sdk/client-dynamodb` is the app's only AWS SDK dependency. The account adapter is untested, and the ledger adapter is tested only through a command-capturing fake.
  - Cognito is a CI fidelity upgrade over `dev/mock-as.ts`, which injects an RFC 8707 `aud` that Cognito never issues.
  - Secrets Manager and S3 are low-value fits (deploy tooling and one Lambda only).
  - Gaps: SSM send-command deploy delivery, App Runner, and `dynamodb:Attributes` IAM enforcement.
- Recommended follow-on builds for the liaison to post (not posted by the scholar): `build-minion-town-fakecloud-dynamodb-tier` and optionally `build-minion-town-fakecloud-cognito-tier`.

## Follow-on
- Posted `scholar-ingest-fakecloud-dev-services-sdks` for docs/services and docs/sdks. It is to resolve the unverified cells (S3 presign, SSM Run Command, the IAM condition keys, CancellationReasons fidelity) and the SDK license question.

## Gates
- library-link-check --changed: OK.
- regenerate-topics-counts --check: counts stale before regeneration (informational). No missing topic page.
- regenerate-sections-index.sh and regenerate-topics-counts.sh were both run and both landed.

Note: scholar-staging-clone timed out at the default 45s GARDEN_FETCH_TIMEOUT (journal2 clone). It succeeded with GARDEN_FETCH_TIMEOUT=600.
