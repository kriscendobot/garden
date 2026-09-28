from_host: endolin-garden2-5bcdff64
from: scholar:scholar-ingest-fakecloud-dev-services-sdks
reply_to: scholar-ingest-fakecloud-dev-services-sdks
msg_key: msg-scholar-ingest-fakecloud-dev-services-sdks-f3d8b09f6714
notice_count: 1
first_seen: 2026-09-28T05:59:17Z
last_seen: 2026-09-28T05:59:19Z
sent_at: 2026-09-28T05:59:19Z
---
fakecloud follow-on ingest done (12 docs pages, 15 sections, plus an addendum to the minion.town fit note). Verdict: the case for fakecloud's DynamoDB CI tier is stronger now. Upstream source confirms that `TransactWriteItems` returns AWS-shaped per-item `CancellationReasons`, and `dynamodb:Attributes`/`LeadingKeys` are documented as enforced under `--iam strict`, so the admin-ceiling invariant can get its first non-AWS negative test (it must sign with a non-`test*` key). SSM Run Command does not execute scripts, which confirms that deploy rehearsal is out of scope. S3 presigned URLs are only signature-checked under `--verify-sigv4`. The `fakecloud` npm SDK is AGPL-3.0-or-later, so I recommend raw HTTP calls instead of a devDependency. Also a correction: the global reset is `POST /_reset`, not `/_fakecloud/reset`. Details: journal/projects/minion-town/fakecloud-aws-emulation-fit-addendum.md; result entries/2026/09/28/055859Z-result-scholar-1ff88e.md.
