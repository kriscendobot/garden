Fix round 6 for kriscendobot/minion.town PR #166 is pushed. The new head is `55299f0`, and CI is green on all 3 checks (`ci-wait-merge` rc 0).

The round-6 panel came back must-fix because three seats requested changes: locksmith, breaker and pruner. None of their items was labeled must-fix, so I fixed their should-fix items in one follow-up commit, `fix(probe): harden the cache check and confine the issue token`.

**Cache check (breaker and saboteur).** `hardCacheViolations` used to pass any header containing `immutable`. It now also requires `max-age` of at least `HARD_CACHE_MAX_AGE` (one year) and rejects `no-store`, `no-cache` and `private`. New tests:
- the bypass headers the panel named, plus a non-numeric `max-age`;
- a pin that ties the probe's value to the gateway's `IMMUTABLE_CACHE` in `src/endo/gateway/content-server.ts`.

**304 response (breaker).** The 304 revalidation response is now also checked against the isolation floor.

**Workflow token (locksmith, plus assessor's should-fix).** `prod-probe.yml` is now two jobs:
- **`probe` job:** has only `contents: read`, checks out with `persist-credentials: false`, then runs `npm ci` and the probe.
- **`report` job:** installs nothing and alone holds `issues: write`. It downloads the summary artifact and opens or closes the tracking issue based on the probe job's result, instead of on any failed step. The message for a run with no summary now names the failed step rather than saying the probe crashed.

`actionlint` passes on the workflow.

**Empty base URL (saboteur).** An empty `MINION_PROBE_BASE` now falls back to `https://minion.town`, matching how the other environment variables behave.

**DEPLOYMENT.md (pruner, plus locksmith's comment).**
- Removed the "deterministic / SDK client" wording, the explanation of why cleanup is bounded, and the "inert text pet name" sentence.
- Updated the hard-cache row of the check table.
- Noted that `MINION_PROBE_TOKEN_URL` and `MINION_PROBE_BASE` change where the credential is sent.

The offline probe tests pass (20 of 20).

**Left undone:**
- **Dedicated probe credential (locksmith #2):** this needs an operator. Someone has to create a probe-only Cognito client whose guest holds only `status`, `writeText` and `readText`, and store its secrets in a GitHub environment restricted to `main`. CI still uses the shared `minion-mcp-test-cc` client, which can use the guest's whole tool surface.
- **Fixed round-trip name (breaker and saboteur):** I kept the fixed name. A name per run would add a new entry to the guest's directory every three hours. The panel judged the collision risk acceptable.
- **Comment-only items:** I didn't address the two-CSP-headers false failure, the wrong-ETag 304 control request, the fixed 60-second settle delay, or the JSDoc types.
- **Prettier:** `prettier --check` reports style issues in `deploy/probe/prod-objectives.mjs` and `prod-objectives.test.mjs`. I didn't reformat them, because no CI check runs Prettier and CI passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1472116 cached reads)
- Output: 11186 tokens
- Cost: $1.1419352
- Wall-clock: 459s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
