Round-1 fix for PR #180 is pushed and CI is green. I fixed the panel's must-fix items and most of the should-fix items. I did not re-run the panel; the driver posts panel-2.

**What I changed** (kriscendobot/minion.town, branch `design/git-remote-endo-binding`, 94b7f46 → ae6ec13, two follow-up commits pushed with `safe-push-pr-head.sh`)

- **Control plane now checks its caller** (raised by assessor, locksmith, warden, saboteur, breaker and wire-watcher): before this, any local process could reach the loopback port and act as any owner.
  - Every control route now requires a bearer secret, `GIT_REMOTE_CONTROL_SECRET`, compared in constant time. Without it the request gets a 401.
  - The secret lives in `/etc/minion-git-remote/control.env` (root-only, mode 0600). `deploy-git-remote.sh` generates it once, and both `minion-git-remote` and `minion-mcp` load it.
  - If the secret is missing, the control listener stays off and the guest `git` tools are not mounted. The public git service keeps running either way.
- **Read vs. read/write is decided by the server, not the caller** (locksmith, wire-watcher):
  - Creating a partition returns two keys, one for read and one for read/write. Each key is an HMAC of the partition id and access level under the secret.
  - Mint and revoke take one of those keys instead of an access-level string, and the server works out the access level from the key. The read-only object only ever holds the read key.
  - A partition id on its own, which `info()` still returns, now authorizes nothing.
  - Rotating the secret would invalidate the keys held by existing guest partitions; the deploy script says so in a comment.
- **Revoke rules** (breaker): the read/write object can now revoke any URL on its partition. The read-only object can still revoke only read URLs.
- **Port collision** (engine-realist): the control port moves from 3004, which the npm registry already uses, to 3005. I updated both systemd units, `.env.example`, `DEPLOYMENT.md` and the design's env table.
  - Ports must now be integers from 1 to 65535.
  - A failure to listen on the control port is logged instead of crashing the public service.
  - `GIT_REMOTE_CONTROL_ORIGIN` is checked once at startup in `loadConfig`.
- **Caplet error handling**: control requests now time out after 10 seconds. A non-JSON reply produces an error that names the route and status code.
- **`createNamed`** looks partitions up through an owner + pet-name index instead of re-reading every partition file on each call.
- **Naming** (stylist):
  - `TOKEN_HASH_RE` → `TOKEN_HASH_PATTERN`, `text` → `requireString`, `post` → `postControlRequest`.
  - In the integration test: `tmp` → `daemonTemporary`, `conn` → `connection`, `casStoreDirectory` → `contentAddressStoreDirectory`.
- **Docs**:
  - `README.md`: the facet is now written `git`, not `Git` (archivist).
  - `DEPLOYMENT.md`: the guest-provisioning paragraph was splitting step 7 and has moved below that step's SSM block (integrator). The new secret and port are documented.
  - The tool-name comment now explains why `readOnly`, `mintUrl` and `revoke` are safe as bare names.
- **New tests** cover:
  - requests with no secret;
  - one owner's key used on another owner's partition;
  - a client asking for read/write without a key;
  - read/write revoking a read URL, and read failing to revoke a read/write URL;
  - a caplet with the wrong secret;
  - a non-JSON control reply;
  - port validation.

**Verification**
- Typecheck passes.
- `vitest run test/git-remote` plus the tool-name tests: 133 passed, 1 failed. The failure is `projectPartition > propagates a git failure`, in a file this PR does not change, and it fails the same way before and after my edits. It appears to depend on this container's environment; I did not dig into it.
- I did not run the live-daemon integration test locally.
- CI (`ci-wait-merge.sh`, exit 0): `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all passed.

**Not done**
- No check that the object behind a pet name really is a git partition (locksmith #4). This adds no new authority, since guests can already call methods on their own objects through the `evaluate` tool.
- No per-owner cap on partitions, no separate design document for the binding, and no renaming of the `readOnly`/`revoke` tools (should-fix items; the tool names are explained in a comment instead).
- **Before deploy:** run `deploy-git-remote.sh`, then restart `minion-mcp`, so both services load the new secret. Until then the guest `git` power stays unmounted.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4866697 cached reads)
- Output: 35140 tokens
- Cost: $2.7916993999999997
- Wall-clock: 1213s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
