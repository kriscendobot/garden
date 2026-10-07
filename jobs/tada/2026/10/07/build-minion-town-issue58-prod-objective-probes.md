The production probe is built and opened as draft PR kriscendobot/minion.town#166 (head `feat/prod-objectives-probe`, base `main-d750b09`). Run against production today, all six checks passed, and the PR's CI is green. It has not run on its own schedule yet, because GitHub can only start that workflow once it is merged to `main`.

**What it does.** `deploy/probe/prod-objectives.mjs` is a small Node 22 script with no dependencies and no LLM. It runs one named check per checked issue-58 objective, prints a JSON summary, and exits 1 if any check fails:
1. `daemon-unit-healthy`: `/mcp` without a token answers 401 with the right challenge, the OAuth metadata is correct, and a logged-in `status` call reaches the daemon guest.
2. `oauth-guest-authenticated-tool-call`: a token from the `minion-mcp-test-cc` test client carries the `mcp/guest` scope, and a value written to the guest reads back through `/mcp`.
3. `clip-origin-isolation`: a canary clip on its `<hash>.ocap.site` origin sends the required security headers (CSP, COOP/COEP/CORP, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`) and sets no cookie.
4. `clip-content-addressed-hard-cache`: the `ETag` is the SHA-256 of the body and matches the recorded hash, caching is `immutable`, and `If-None-Match` gets a 304.
5. `clip-well-known-ocapn`: `ocapn-cbor`, `ocapn-syrup` and `endo-captp` answer 426, and `ocapn-bootstrap` answers 200 with an `endo:` identifier.
6. `ocapn-cbor-np-websocket`: `https://minion.town/.well-known/ocapn-cbor-np` accepts a WebSocket upgrade.

Each check gets one retry before it counts as failed. Without the test-client credential, checks 1 and 2 report `skipped: no-credential` with a warning, and the overall result is `incomplete`, never `pass`.

**Workflow.** `.github/workflows/prod-probe.yml` runs every 3 hours, on manual dispatch, and after each successful deploy. A failure turns the run red and opens one tracking issue labeled `prod-probe-failure`, or comments on the one already open; a fully green run closes it. The JSON summary is uploaded with each run.

**Changes I made outside the repo:**
- **Canary clip:** I published one dedicated clip through the garden's minion.town guest (`u3so3bbiw3qwoeybdilkgn2inwz73jg4qwreabj327vq4wfczuba.ocap.site`). Its power is a harmless text value named `prod-probe-canary-back`. The hash is recorded in `deploy/probe/canary.json`; the clip must not be unpublished.
- **Actions secrets:** I set `MINION_PROBE_CC_CLIENT_ID` and `MINION_PROBE_CC_CLIENT_SECRET` on kriscendobot/minion.town from Secrets Manager `minion/test-cc-client`, so checks 1 and 2 will really run in CI. The script never prints the token or secret.

**Testing:**
- **With the credential:** all 6 checks passed, and the secret did not appear in the output.
- **Without it:** checks 1 and 2 were skipped and the other 4 passed.
- **Unit tests and lint:** the new unit tests pass 11/11, and `actionlint` is clean.
- **PR CI:** the test job and both harness image builds are green.

**Also in the PR:** a new step in `test.yml` that runs the unit tests, and a "Production objectives probe" section in `DEPLOYMENT.md`. I did not touch the issue-58 checklist.

**Follow-ups:**
- The review gauntlet stages automatically from here.
- After #166 merges, the first scheduled or post-deploy run will be the first in-CI evidence. Starting it by hand needs the workflow on `main` first.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-issue58-prod-objective-probes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3354704 cached reads)
- Output: 32118 tokens
- Cost: $2.1165407999999997
- Wall-clock: 606s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
