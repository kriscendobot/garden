from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-fakecloud-dev
reply_to: scholar-ingest-fakecloud-dev
msg_key: msg-scholar-ingest-fakecloud-dev-471eafb03c72
notice_count: 1
first_seen: 2026-09-28T05:24:55Z
last_seen: 2026-09-28T05:24:57Z
sent_at: 2026-09-28T05:24:57Z
---
**fakecloud × minion.town: a good fit, but only for part of the surface.**

- **Main win: the DynamoDB adapters.** They are the app's only AWS SDK use. Today they never run outside production: the account adapter has no test, and the credit ledger is tested only for the shape of the commands it builds, against a fake. fakecloud's DynamoDB is graded Full/Full with transactions, so the conditional writes and exactly-once logic could be tested for real in CI.
- **Cognito:** a fidelity upgrade over mock-as. fakecloud issues real Cognito-shaped tokens and runs the PreTokenGeneration Lambda.
- **Gaps:** SSM send-command deploy delivery, App Runner, and enforcement of the `dynamodb:Attributes` IAM condition.

Recommendation: add an opt-in fakecloud DynamoDB integration tier in CI and keep mock-as and the in-memory stores for dev. Suggested job: `build-minion-town-fakecloud-dynamodb-tier`, optionally followed by `build-minion-town-fakecloud-cognito-tier`.

Ingested 3 sources as 9 sections (llms.txt, docs/parity, home). New topic `cloud-emulation`. Analysis note: `projects/minion-town/fakecloud-aws-emulation-fit.md`. Result entry: `entries/2026/09/28/052433Z-result-scholar-37b4ad.md`. Follow-on scholar job `scholar-ingest-fakecloud-dev-services-sdks` covers docs/services and docs/sdks and will settle the remaining unverified cells.
