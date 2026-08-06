The plan is posted. This was a design-only job with no garden-repo code changes, so there is nothing to commit or push.

---

**Completion report**

**Job:** Design a non-CI live integration-test path for `@endo/google-sheets` (PR endojs/endo-but-for-bots#874), per @dckc's request for a test against the real Sheets service.

**What I did:**
- Read the PR, the directive comment (#issuecomment-5120591989), the package source (`makeSheetsClient` and its `values`/`spreadsheets` surface, date helpers, `GoogleSheetsError`/`errorCodeFor`), README, package.json, and the repo's existing opt-in live-test precedent (`ocapn-iroh/test/netlayer-integration.test.js`, gated by `ENDO_IROH_INTEGRATION=1`).
- Wrote a short implementation plan and posted it as a top-level PR comment: https://github.com/endojs/endo-but-for-bots/pull/874#issuecomment-5200876268

**What the plan specifies:**
- **Shape:** `test.serial.skip` unless `ENDO_GOOGLE_SHEETS_INTEGRATION=1`, mirroring the iroh precedent — never runs in CI, so no secret ever reaches a CI log and no GitHub secret is needed.
- **Minimum ops/assertions:** a 7-step serial round-trip (`getSpreadsheet` → `updateValues` → `getValues` (real 1900-date-system round-trip) → `appendValues` → `batchGetValues` → `clearValues`) plus one live `not-found` error-mapping assertion, all confined to a dedicated `IntegrationScratch` tab.
- **Least-privilege credential model:** a service account with **no** IAM roles, access granted only by sharing the one fixture sheet (`spreadsheets` scope); token minting stays in the harness, honoring the package's injected-`fetch` boundary.
- **Secret handling:** SA key injected via `GOOGLE_SHEETS_TEST_CREDENTIALS` / gitignored `.env`, never committed, never logged.
- **Disposable fixture + cleanup:** empty single-tab sheet, `test.after.always` clear, unique run marker, delete-and-recreate as the worst case.
- **Reproducible command** documented.

**Constraints honored:** created no GCP project, service account, credential, GitHub secret, or fixture; added no CI test. The comment ends with an explicit 5-point maintainer decision request (project/SA authorization, fixture authorization, local-only credential residency, `google-auth-library` devDependency approval, and coverage-tier choice: full read-write SA vs. read-only API-key-against-a-public-sheet).

**Follow-ups:** none by me — implementation is gated on the maintainer's answers to the 5 decision points.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr874-live-google-sheets-integration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 19 tokens (463849 cached reads)
- Output: 9884 tokens
- Cost: $0.9285045
- Wall-clock: 165s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
