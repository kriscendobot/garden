---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-28T05:59:07Z
---
# scholar-ingest-fakecloud-dev-services-sdks — result

Job: follow-on to `scholar-ingest-fakecloud-dev`; ingest fakecloud.dev docs/services, docs/sdks, docs/reference and resolve the minion.town fit note's unverified cells.

## Ingested (12 web sources, 15 sections; all fetched direct 2026-09-28 via fetch-source.sh)

- `web--fakecloud-services` (https://fakecloud.dev/docs/services, sha `30364ffe…`, same bytes as the 2026-09-28 retrieval but never ingested before, so no skip) — 1 section
- `web--fakecloud-services-dynamodb` (`83ab143f`) — 2
- `web--fakecloud-services-s3` (`5cbfe3e9`) — 2
- `web--fakecloud-services-ssm` (`af26e00a`) — 1
- `web--fakecloud-services-cognito` (`b9f2586b`) — 1
- `web--fakecloud-services-secretsmanager` (`9586e6fd`) — 1
- `web--fakecloud-services-iam` (`2b8493e9`) — 1
- `web--fakecloud-sdks` (`386ed5cd`) — 1
- `web--fakecloud-sdks-typescript` (`650f64be`) — 1
- `web--fakecloud-reference-security` (`beadb5c0`) — 2
- `web--fakecloud-reference-introspection` (`f5197dd2`) — 1
- `web--fakecloud-reference-limitations` (`8be8778e`) — 1

Budget note: 12 sources is above the 3–5 guideline. These are short single-topic vendor pages (one or two sections each), and 15 section writes is under the 25-section ceiling. The job named each page explicitly.

## Pages touched

Topics: `cloud-emulation` (+15 rows), `testing` (+5), `policy-language-authorization` (+3), `oauth-credentials` (+1). Concept: `fakecloud` (+15 rows). Indexes: `sources/README.md` (+12 rows), `keywords.md` (fakecloud line widened). Project: new `projects/minion-town/fakecloud-aws-emulation-fit-addendum.md` plus a README row. The parent fit note is untouched (append-only).

## Findings (the four unverified cells + license)

1. **CancellationReasons:** confirmed per-index `None`/`ConditionalCheckFailed` alignment. The docs do not state it; the evidence is upstream source `faiscadev/fakecloud@4db815e2` `crates/fakecloud-dynamodb/src/service/batch.rs` plus an e2e test asserting it.
2. **S3 presign:** not validated by default. Query-string SigV4 is validated under `--verify-sigv4` with ±15-min skew. `X-Amz-Expires` enforcement is undocumented. Any `test*` key bypasses the check.
3. **SSM SendCommand:** a status timer only; `AWS-RunShellScript` is not executed and `StandardOutputContent` is empty (source `commands.rs`). The gap is confirmed.
4. **dynamodb:Attributes / LeadingKeys:** documented as enforced under `--iam strict`. A negative test with a non-`test` key is still advised. The limitations page contradicts this by listing only S3/SNS/Lambda/SQS keys; treated as stale.
5. **SDK license:** npm `fakecloud@0.46.0` is AGPL-3.0-or-later with zero runtime deps. Recommendation: raw HTTP, no devDependency.
6. **Correction to the parent note:** the global reset is `POST /_reset` (the SDK source); the reference lists only `/_fakecloud/reset/{service}`.

## Gates and regeneration

- `library-link-check.sh --changed`: OK. After landing, per-slug checks on all 12 slugs: OK.
- `library-slug-prefix-check.sh --changed`: OK.
- `regenerate-topics-counts.sh --check`: stale before landing (informational). After `--land`: current.
- `regenerate-sections-index.sh`: landed. `regenerate-topics-counts.sh`: landed.

## Follow-ons

None posted. Remaining fakecloud pages (other services, reference/configuration, persistence, organizations, and the other six SDK pages) are outside minion.town's surface; ingest on demand. The suggested build jobs from the parent note (`build-minion-town-fakecloud-dynamodb-tier`, optional Cognito tier) remain the liaison's call. The addendum adds an optional IAM negative-test case to the DynamoDB tier.
