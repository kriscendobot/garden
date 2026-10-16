Fix round 10 for kriscendobot/minion.town#178: I applied the panel-10 must-fix items in three follow-up commits, pushed them, and CI on the new head (`d1e89c9`) is green (`ci-wait-merge` rc 0).

**Main fix (`3dbee7f`, `git-http.ts`).** Five jurors flagged that a request declaring 4 bytes or fewer skipped the rate and queue caps but still started a `git http-backend` child. That meant a write-capability holder could pile up stalled children with short or withheld bodies. The router now reads that short body itself, with a 10-second deadline:
- An exact `0000` (what stock git sends) gets an empty 200.
- Any other short body gets 400; one that never finishes arriving gets 408.
- While its body is arriving, the request counts against `GIT_REMOTE_MAX_PENDING_PUSHES`, so stalled ones hit the same 429 limit as stalled pushes.

**Other code changes in the same commit:**
- `defaultPushLimits` is typed `Readonly` to match its freeze.
- The rate limiter clears idle partitions at most once per window instead of scanning every partition on every check.
- Startup refuses a rate window too long to count in milliseconds.

**Tests (`326ecc7`):**
- **Serialization:** two valid queued pushes, under a size cap that fits only one, now result in exactly one landing. I checked that this test fails when per-partition serialization is removed. The abandoned-push test now shows the queued push never started.
- **New coverage:** another partition isn't held up by a stalled push; short-body validation and stalled-request bounds; boundaries for exact-cap size, the rate window's exact expiry, and emoji framing; a 20,000-partition test of the idle cleanup; and a fast-check property mapping the five cap settings to the runtime limits.
- **Flaky test:** the chunked over-cap test now accepts either outcome (413, or 200 with an unpack failure) and still checks that no ref moved.
- **Small items:** the renames, comment removals and `os.devNull` that the stylist, pruner and transplanter asked for.

**Docs (`d1e89c9`):** the design's inventories now list `limits.ts` and its test suite, and call the work a follow-on slice of increment 1 rather than "Increment 2". `DEPLOYMENT.md` gets a Phase 14 row (built, not deployed) and a note for operators upgrading.

**Summary comment.** I posted a summary comment on the PR (https://github.com/kriscendobot/minion.town/pull/178#issuecomment-6213925183). It maps panel rounds 2–10 to the commits that answered them and lists verification. It also declines three items:
- **Benchmarker:** the claims are structural, and the cleanup is tested directly.
- **Releaser:** the repo has no changeset tooling and the package is private; the upgrade note went in `DEPLOYMENT.md` instead.
- **Coverage-auditor:** the package has no coverage tooling configured.

**Verification:** typecheck is clean, and `vitest run test/git-remote` passes 128/128 locally, with the limits suite passing three more times in a row. For local runs I had to take the garden's `git` wrapper off `PATH` and set `GIT_CEILING_DIRECTORIES`. Without that, one test the PR doesn't touch (`capability.test.ts`) fails and the concurrency tests count extra processes, because the scratch directory sits inside the garden repo.

Per the gauntlet, I did not re-run the panel; the driver posts panel-11.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (4013763 cached reads)
- Output: 38867 tokens
- Cost: $2.6567406000000005
- Wall-clock: 1982s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
