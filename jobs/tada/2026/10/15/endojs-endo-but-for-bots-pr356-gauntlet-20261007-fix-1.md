# PR #356 fix round 1: done, CI green (26/26)

I applied the panel-1 must-fix findings in two follow-up commits and pushed them to `endojs/endo-but-for-bots` `design/gateway-packaging-aws-stack` with `safe-push-pr-head.sh` (`18b52cac4..0b057f985`). Two findings were not applied here: the PR body rewrite, which is posted as a separate job, and the request to split out the unrelated commits, which I left alone.

The panel's verdict was posted as a COMMENTED review (5533862801) on `18b52cac`.

**Commits**
- **`b3268f9d9` test(ocapn):** stylist fix. Renamed `NetlayerRef`/`netlayerRef` to `NetlayerReference`/`netlayerReference` and `buf` to `buffer` in `netlayer-tcp-syrup.test.js`. Ran `ses-ava` locally on that file: 3/3 pass.
- **`0b057f985` fix(designs):**
  - **`gateway-package.md`:**
    - The UDS bootstrap is split in two. An owner-only (0600) admin socket hands out `GatewayAdmin`. A registration socket, which the operator may open to one group, hands out `GatewayRegistrar`, and each registration is tied to the caller's OS user ID. `getApps` is now admin-only.
    - Hostname canonicalization is defined once and used by both `bind()` and request lookup, with rules for `Host` and `X-Forwarded-Host`.
    - There is a concrete `ENDO_HTTP_ADDR` parser, since WHATWG `URL` can't parse a bare host:port.
    - One Noise message per WebSocket message, with fragments reassembled first.
    - Package `exports` and the `types-index` layout are spelled out, and `@endo/gateway-daemon` is the package that provides the `endo-gateway` command.
    - New test-catalog rows cover all of the above.
  - **`gateway-aws-attuned.md`:**
    - Keys are split by purpose. The enclave offers only purpose-specific operations: `signNoiseHandshake`, `issueAccountCredential` / `verifyAccountCredential`, and `encryptRow` / `decryptRow`. There is no raw sign or decrypt call.
    - Each request gets short-lived tenant-scoped AWS credentials (`sts:AssumeRole` with a tenant session tag); the instance role itself has no data access.
    - Garbage collection is a race-safe state machine in DynamoDB with a conditional delete before the S3 delete; lifecycle rules no longer expire CAS objects.
    - The secondary index key now includes the tenant ID, with a test for two tenants sharing an account ID.
    - Noise session keys and counters are no longer persisted, and relay registrations are ephemeral (daemons re-register after a restart).
    - Content-addressed writes are hash-verified and immutable.
    - A benchmark plan must pass before the `public` and `signed-url` modes become defaults.
    - The repeated preamble and the duplicate `## Prompt` section are removed.
  - **`gateway-packaging-ci.md`:**
    - The config directory is now mode 0750 (files stay 0640).
    - Each package target has its own publish job, and partial releases are defined.
    - The container user ID is a build argument (default 10001) instead of a fixed 1000.
    - The broken `.garden` link is gone.
  - **`gateway-aws-deployment.md`:** the apt repository key's fingerprint is checked before the key is trusted. `c7g.large` is now the initial default, pending a benchmark plan.
  - **`README.md`:**
    - The status counts were recounted and now add up to 129.
    - The date is updated.
    - In the roadmap, `endo-gateway` is marked superseded, and Milestone 1 now holds three of its successor designs, with totals and the timeline recomputed.
    - `gateway-aws-attuned` is placed after Milestone 1, because that design describes itself as following it.
  - **Typist:** the flagged non-ASCII symbols and em dashes are replaced. The maintainer prompt now appears only once, in `gateway-packaging-ci.md`, and the other two documents point to it.

**Not done here**
- **PR body (integrator #1, pruner #3):** the body should follow the repo's PR template. `gh pr edit` gets a 403 from this host's token. I posted job `endojs-endo-but-for-bots-pr356-body-template-20261015`, pinned to `endolin-garden-ece02cb4`, carrying the rewritten body to apply.
- **Unrelated commits (packager must-fix, integrator should-fix):** the branch still carries CI, test, `SECURITY.md` and tsconfig repairs from its stale base `llm-b1c3f4d`. I didn't remove them, because doing so would likely turn CI red. They belong to a weave (moving the PR onto a newer base), and the new PR body says so.
- **Decomplector findings:** whether to delete `endo-gateway.md`, and whether to reuse the existing Git formula, need a maintainer decision.
- **Fast-checker suggestion:** adding a property-based test to the OCapN syrup round-trip is a follow-up only; I didn't do it.

**CI:** `ci-wait-merge` returned rc 0, with 26/26 checks and no failures. It took about 45 minutes across several bounded waits; the two macOS legs finished last.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2847518 cached reads)
- Output: 17286 tokens
- Cost: $5.621573000000001
- Wall-clock: 3429s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
