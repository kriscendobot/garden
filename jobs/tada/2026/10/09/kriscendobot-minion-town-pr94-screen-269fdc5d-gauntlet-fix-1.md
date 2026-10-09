I fixed all three must-fix items from panel round 1 (review 5464660283, on head `269fdc5d`). The new head is `4d27c94` and CI is green.

**What changed**

- **Unsquashed `fixup!` commit and leftover in-between history (packager, integrator):** I rebuilt the PR's 7 commits on base `main-50aa690` as 3 commits, one per fix:
  - `e8989ed`: the GitHub OIDC thunk's `/token` now requires client authentication. Its tests and the `secret.js` change for returning a 5xx on a Secrets Manager outage are in this commit.
  - `5bf86b7`: the SIWE thunk's client checks are hardened.
  - `4d27c94`: deploy secrets are streamed straight into place and never written to `/tmp`, with the change to the caddy environment test.

  The first `/tmp` approach, staging secrets in a private `mktemp -d` directory, and its fixup commit no longer appear in the history. Apart from the next item, the code at the new head is exactly the same as at `269fdc5`. I pushed with `safe-push-pr-head.sh --mode rewrite`.
- **The SIWE Basic parser was not RFC 7617 / RFC 7235 compliant (spec-keeper):** it only accepted the exact text `"Basic "`. It now matches the scheme name in any case, the same way the GitHub thunk does. I added a test in `deploy/thunks/siwe/test/oidc-face.test.js` showing that a `basic …` header is honored and takes precedence over the credentials in the request body.
- **The PR description was stale (integrator):** I rewrote it to describe the final state: secrets go through `install /dev/stdin` into `<dest>.new` and are then moved into place, with no `mktemp` staging. The test evidence is current, and the description is shorter. The new title is "fix(security): authenticate the thunk token endpoints; keep deploy secrets out of /tmp".

**Verification**

- Locally, the SIWE suite passes with `node --test` (24/24). Vitest passes for `github-oidc-thunk-token-auth` and `caddy-environment-sync` (51 tests). `bash -n` passes on all three deploy scripts.
- In CI on `4d27c94`, `test`, `Claude harness (arm64)` and `Claude harness (amd64)` all pass. The amd64 check sat in a queue backed up across the whole repo for about 40 minutes before it ran. I used my own polling loop to wait, because `ci-wait-merge.sh` hit the 10-minute background limit and was stopped.

**Follow-ups (should-fix items, not done here):**
- **Shared secret:** the `/token` check uses the upstream GitHub OAuth App secret itself, where a separate secret for the thunk's own clients would be safer. A code can also be redeemed by any client holding the credentials, because codes aren't tied to a specific client.
- **Type checks in `secretsEqual`:** check for `typeof === "string"` before comparing.
- **Missing header:** the 401 responses should carry a `WWW-Authenticate` header.
- **Both credential methods sent:** decide whether to reject a request that uses both methods, or document which one wins.
- **Test isolation:** reset `vi.resetModules` and `getTokens` between tests.
- **Duplicated code:** `secretsEqual` and the Basic parser exist in both thunks with no comment pointing from one copy to the other.
- **Placement:** the GitHub thunk's client-auth check sits in `index.js` rather than the protocol layer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1642652 cached reads)
- Output: 9502 tokens
- Cost: $1.0848584
- Wall-clock: 2777s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
