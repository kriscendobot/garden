# Plan: minion.town as an operational capability git remote (arc `minion-town-git-remote`)

Job `plan-minion-town-git-remote-increments-20261010`. This is a build plan, not a new
design. The designs of record are in kriscendobot/minion.town:
`designs/git-remote-capability.md` (the parent design, merged as #41) and
`designs/git-remote-capability-increment-1.md` (merged as #86). Every increment below is
parked as a plan stamped `arc: minion-town-git-remote`.

## What exists on `main` (c9a073c, 2026-10-10)

- **Increment 1 is merged and deployed.** The job brief says "not deployed", but that
  is out of date. `DEPLOYMENT.md` phase row 13 reads **DEPLOYED (2026-09-29)**, and
  job `verify-git-minion-town-deploy` (2026-09-29) confirmed all four legs:
  `minion-git-remote.service` running on 127.0.0.1:3003, the Caddy `git.minion.town`
  route, `/healthz` returning 200 over valid TLS, and the Route53 A record. That job did
  **not** run the live capability-URL round trip (§ Validating the git remote after
  merge, step 7), because the round trip writes production data.
- **Partitions can only be provisioned by the operator.** `partition-store.ts` has
  `create` / `mint` / `authorize` / `revoke`, but only the operator path reaches it. No
  guest can create a partition or mint a URL.
- **A push is projected but never served.** A push writes `content-roots/<id>`, which
  nothing else reads. The gateway serves only immutable `id = f(contentRoot, powers)`
  clips, so a push changes no visitor-facing bytes. The mutable partition-backed host
  is the parent design's § 1/§ 9 and OQ 10, and it has not been built.
- **No Endo-directory binding exists.** The partition is not a pet-named ocap in the
  guest inventory. The MCP baseline (`mcp-tool-names.ts`) has `adopt` but no tool to
  create or mint (parent § 7, § 12.2; increment-1 deferred item 2). The `@sites` power
  behind `publish`/`listSites` is the in-repo precedent for a guest-held power.
- **Pushes have no limits.** There is no pack-size, object-count, or partition-size cap
  on `receive-pack` (deferred item 3). That is acceptable while only the operator
  provisions partitions, but not once guests can create them.

"Operational as a capability git remote" therefore means that a guest can obtain a
partition through its own Endo inventory, push to it with stock `git`, and have the
result served as a clip, inside resource bounds. Increments 1 to 5 below deliver that.
Everything else on the increment-1 deferred list stays deferred: the in-CAS object
database and SQLite refs, GC, the write-only attenuation, Strategy B, and
`@endo/platform`.

## Increments

1. **`minion-town-git-remote-live-validation`** (deferred, builder). Run DEPLOYMENT.md
   § Validating the git remote after merge, step 7, against production: create one
   operator-owned test partition, mint a `readwrite` and a `read` URL, then push, clone,
   check the 403 on a read-token push, and revoke. Record the result in the phase-13
   row. If the operator provisioning path is awkward to drive on the box, the
   deliverable is a small `deploy/aws/scripts/git-remote-partition.sh` wrapper
   (create/mint/revoke), used for the run. Clean up the test partition afterwards.
2. **`minion-town-git-remote-push-caps`** (deferred, builder). Add resource caps on
   `receive-pack`: maximum request/pack bytes, maximum partition disk size, and a
   per-partition push rate. Each cap is configurable via `config.ts` and enforced
   before or during the CGI with a clean git-protocol error. Add tests for each refusal.
   Metering and billing stay out of scope (#174 owns the credit ledger).
3. **`minion-town-git-remote-endo-binding`** (blocked on increment 2, builder). Do the
   Endo-directory binding. Give the guest a git power modeled on `@sites` (for example
   `@git`), whose `create(petName)` makes a partition owned by the guest. The result is
   stored in the guest's inventory under that pet name as a partition object carrying
   its unconditional `attenuation` field. `mintUrl()` on a read or readwrite
   attenuation returns a show-once capability URL. The guest service reaches the
   git-remote process over a loopback-only control channel, never through the public
   `git.minion.town` route. Add the reconciled MCP tool names to `mcp-tool-names.ts`,
   and test `revoke` through the held object. If the `@sites` precedent does not fit,
   stop and open a design PR rather than inventing a daemon formula (that is
   endo-but-for-bots work, parent § 12).
4. **`minion-town-git-remote-served-clip-design`** (deferred, designer). Write a design
   PR on kriscendobot/minion.town that settles how a partition's projected
   `contentRoot` is served. It must cover the stable host for a partition (parent OQ
   10), how the gateway resolves it with only content-store authority (parent § 10), the
   write-side reconcile sweep (§ 9), and the deployment-coherent root-qualified
   sub-resource tier (§ 9, deferred item 5). Reconcile it with open PRs #88
   (nonce-locator / fresh id), #142 (clip lifecycle authority), and #170. The PR is
   the maintainer's decision surface. Build nothing in this increment.
5. **`minion-town-git-remote-served-clip`** (blocked on increment 4, builder). Build
   what the approved design names. The gateway serves a partition's live
   `contentRoot`, the git-remote process runs the background reconcile sweep, and an
   end-to-end test pushes twice and sees the served bytes follow. Stop if the design
   PR is not approved.

The foreman can draw increments 1, 2, and 4 immediately, in any order. Increment 3
waits on 2 and increment 5 waits on 4, both through the unblock watcher. The arc goal is
met when 3 and 5 have landed and been deployed.
