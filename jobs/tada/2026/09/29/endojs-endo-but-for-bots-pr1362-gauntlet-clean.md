Clean stage finished for PR #1362: I added coverage tests, and CI is green at head `a86bb2a546`. `ci-wait-merge.sh --no-merge` returned 0 with all 33 checks terminal and 0 failed. The first push broke CI; the second push fixed it.

**What I pushed** to `build/npm-dev-registry-serving`, both via `safe-push-pr-head.sh` as history-preserving adds:
- `37ca7d66e8`: two new test files for `@endo/npm-registry-server`.
  - `test/grants.test.js` covers:
    - token hashing (the raw token is never stored);
    - input validation for grant id, token length and an empty package list;
    - rejection of absent and expired grants, including exactly at the expiry time;
    - revocation, including revoking twice and revoking an id that was never issued;
    - refusal to reissue a revoked id, and replacing a live grant's token;
    - `listGrants` output.
  - `test/http.test.js` covers the HTTP routes:
    - ping and whoami, and that only `Bearer` auth is accepted;
    - that the token never appears in logs;
    - error codes 401, 403, 404, 405, 413 and 400;
    - ETag 304s and HEAD requests on packuments and tarballs;
    - the abbreviated install-v1 content type;
    - publish and retry;
    - reading and setting dist-tags.
- `a86bb2a546`: a fix for the first commit. Its HTTP test used Node's built-in `fetch`, which on Node 24 under SES lockdown threw unhandled rejections when the server shut down. That failed `test (24.x, ubuntu-latest)`, `test (24.x, macos-15)` and `cover (24.x, ubuntu-latest)`. The test now uses a one-shot `node:http` client, the same workaround the PR's own `node-fetch.js` uses for upstream fetches.

**Coverage** went from 87.2% to 92.3% of lines, and from 68.8% to 79.1% of branches. `grants.js` went from 76% to 100% of lines, and `http.js` from 74% to 98%. All 22 tests pass locally on Node 22.

**Checks:** package lint has 0 errors. The 7 warnings (`safe-await-separator`) were already in the PR's files. The `tsc` type check (with `checkJs`) is clean, and prettier is clean. I found no code orphaned by the change, so I removed nothing.

**Follow-ups:**
- I couldn't run Node 24 on this host because the installed `better-sqlite3` binary is built for Node 22, so CI is the only Node 24 check.
- I left `registry.js` (87%) and `tarball.js` (87%) at their current coverage. Their remaining gaps are mostly upstream-error and malformed-tarball paths; a later pass could target them.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3707996 cached reads)
- Output: 18065 tokens
- Cost: $1.9274111999999999
- Wall-clock: 4919s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
