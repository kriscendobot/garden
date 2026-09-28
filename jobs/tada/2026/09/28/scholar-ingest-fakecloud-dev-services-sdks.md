# Completion report: `scholar-ingest-fakecloud-dev-services-sdks`

The ingest is done. All four "unverified" cells in the minion.town fit note and the SDK license question now have answers. Everything is landed on `journal2`, and the integrity checks passed.

**What I ingested:** 12 fakecloud.dev pages, all fetched directly on 2026-09-28 with `fetch-source.sh`, making 15 sections under the `cloud-emulation` topic and `fakecloud` concept.
- **Services:** the `docs/services` catalog page (1 section), DynamoDB (2), S3 (2), SSM (1), Cognito User Pools (1), Secrets Manager (1) and IAM (1).
- **SDKs:** `docs/sdks` (1) and `docs/sdks/typescript` (1).
- **Reference:** `reference/security` (2), `reference/introspection` (1) and `reference/limitations` (1).
- **Idempotency:** the `docs/services` page's hash is still `30364ffe…`, the same as the earlier fetch, but it had never been ingested, so this was not a skip.
- **Budget:** 12 sources is over the usual 3–5, but they are short single-topic pages, 15 sections is under the 25 ceiling, and the job named them all.

**Library pages touched:**
- Rows added to the `cloud-emulation`, `testing`, `policy-language-authorization` and `oauth-credentials` topic pages and the `fakecloud` concept page, all through `insert-sections-table-row.sh`.
- 12 new rows in `sources/README.md`, and the `fakecloud` line in `keywords.md` widened.
- Each file landed through `land-journal-edit.sh`; modified files were landed with the blob they were read from, so a peer's concurrent edit would have been refused.

**Project note:** I added `projects/minion-town/fakecloud-aws-emulation-fit-addendum.md` and a row for it in the project README. The original fit note is unchanged.

**What the addendum finds:**
1. **`CancellationReasons`:** fakecloud matches AWS, returning one entry per transaction item (`None` or `ConditionalCheckFailed`). The docs don't say this; I confirmed it in the fakecloud source at commit `4db815e2`, and an upstream end-to-end test asserts it.
2. **S3 presigned URLs:** by default signatures are never checked. With `--verify-sigv4` on, presigned signatures are checked with a ±15-minute clock-skew window. Whether the URL's expiry time is enforced is not documented.
3. **SSM `SendCommand`:** it only simulates status changes (Pending → InProgress → Success) and never runs the script; the output is empty. This is confirmed in the source, so the deploy-rehearsal gap is real.
4. **`dynamodb:Attributes` / `LeadingKeys`:** documented as enforced under `--iam strict`. A negative test is still needed, and it must sign with an access key that doesn't start with `test`, because those keys skip all signature and IAM checks.
5. **SDK license:** the `fakecloud` npm package (v0.46.0) is AGPL-3.0-or-later and has no runtime dependencies. I recommend calling the HTTP endpoints directly instead of adding it as a devDependency.
6. **Correction to the original note:** the whole-server reset is `POST /_reset`, not `POST /_fakecloud/reset`.

**Checks:**
- The link check and the slug-prefix check both passed before landing, and the link check passed again for all 12 new sources on the updated journal.
- Both generated indexes were rebuilt and landed (the sections index and the topics section counts), and the counts check now reports current.

**Journal and messages:**
- Result entry: `entries/2026/09/28/055859Z-result-scholar-1ff88e.md`.
- The maintainer summary was delivered to the maintainer inbox.
- I could not read my own inbox at the end: its journal clone timed out (offline, exit 75). That is a network problem and doesn't affect the landed work.

**Follow-ups:** I posted no follow-on job. The remaining fakecloud pages (other services, the configuration, persistence and organizations reference pages, and the other six SDK pages) don't touch minion.town's AWS usage; they can be ingested when needed. The build jobs suggested in the original note (`build-minion-town-fakecloud-dynamodb-tier`, and an optional Cognito tier) are still for the liaison to post. The addendum adds an optional IAM negative-test case to the DynamoDB tier.

Self-improvement: `scholar-staging-clone.sh` and `inbox-read.sh` both fail their first journal clone at the fixed 45-second limit on this host. The staging clone only succeeded after I reran it with `GARDEN_FETCH_TIMEOUT=300`, and the inbox drain never did. A worth-considering change is to derive the first-clone timeout from how big the repository is, or to reuse a local reference clone (`--reference`), so jobs don't lose time to this.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-fakecloud-dev-services-sdks.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6683893 cached reads)
- Output: 47805 tokens
- Cost: $3.7286306
- Wall-clock: 1036s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
