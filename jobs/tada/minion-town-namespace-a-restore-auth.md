Restored production authentication and completed the namespace migration.

- Merged #25, moving weblets to `*.weblet.minion.town`.
- Added `*.weblet.minion.town → 13.56.17.18` and removed obsolete `*.minion.town`; retaining it served no route and unnecessarily broadened DNS coverage.
- Confirmed `github-idp`, `siwe-idp`, and `www` serve HTTPS with their own certificates.
- Verified the seeded placeholder returned the exact isolation headers, `Cache-Control: no-store`, no `Set-Cookie`/ACAO; garbage TLS was refused; `/gateway/*` returned 404; apex remained 302 and OCapN remained 426.
- Updated draft design PR #21 throughout, recorded the incident and shipped state, and left every §9 question open because Option A settled none.
- Rebased and merged #23 and #24 together after auth recovery. #24 was marked ready first. Integrated tests passed: typecheck plus 191 tests (3 skipped); both CD deployments succeeded.
- Final live CAS verification passed: content 200, immutable caching, ETag/304, isolation headers, no cookie/ACAO, reserved gateway 404, powers-path 426, and garbage TLS refusal.
- Posted completion summaries on PRs #21, #23, #24, and #25.

Follow-up: PR #21 intentionally remains draft with its open design questions. The powers plane remains disabled/fail-closed until its daemon socket is deliberately enabled.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-namespace-a-restore-auth.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1147s

<!-- garden-usage-end -->
