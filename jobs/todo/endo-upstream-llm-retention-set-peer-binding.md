---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: endojs/endo (base branch `llm`), via the bot fork kriscendobot/endo

Port a security fix upstream. Authorized by the maintainer (kriskowal) on
2026-08-12 in the liaison session, who chose "patch upstream llm now" over
retraction, on the reasoning that the fork PR's title is already public and
upstream `master` is unaffected, so closing the window beats trying to un-say it.

## What is wrong upstream

`endojs/endo` branch `llm` at `33311ae9a41d0b12ba6f0367717352b67d9032bc`,
`packages/daemon/src/daemon.js`: the gateway returned by `hello` is shared, and
`followRetentionSet` passes its caller-supplied node directly to
`listFormulaNumbersByNode` with no binding to the peer `hello` authenticated and
no local-node refusal. A caller can therefore pass the LOCAL node (revealed by
`getNodeId()`), enumerate every local formula number, combine each with the node
into a full formula ID, and call `provide(id)` — reaching unconfined,
host-equivalent authority.

Upstream `master` (`d9923b92`) does NOT contain retention following at all, so
the default branch is unaffected. This is a development-branch defect.

This was found in production on minion.town, where it was reachable by any
holder of an OCapN address. That deployment is contained.

## The work

1. **Port the fix from https://github.com/endojs/endo-but-for-bots/pull/978**
   (branch `ocapn-gateway-retention-peer-binding`). Its shape:
   - `hello` returns a gateway BOUND to the peer's authenticated node;
     `followRetentionSet` answers only for that node, never another peer's and
     never the local node's.
   - The shared `localGateway` (outbound/loopback paths not flowing through
     `hello`) refuses to enumerate the local node's formula index outright,
     justified by the fact that a node never peers with itself.
   Do not assume the two trees are identical. Read the upstream code and adapt;
   report any place the upstream shape differs enough that the fix must change.

2. **Verify the same bearer-read audit holds upstream:** `provide`,
   `provideBlob`, `provideTree` should each answer only to a caller already
   holding the secret id/hash, with `followRetentionSet` the only enumerating
   method. If upstream has additional enumerating methods the fork lacks, fix
   those too and say so.

3. **Tests**, matching the fork PR: a peer confined to its own retention set,
   the local index not enumerable, and a positive interop control proving
   peer-to-peer retention still works. Run the cross-daemon invite-retention
   suite.

4. **Open a PR from `kriscendobot/endo` against `endojs/endo` base `llm`.** The
   bot's fork already exists. Do NOT merge it; merging is the maintainer's.

## Bounds

- **No ferry, no identity switch.** Push and open the PR under the bot identity
  as normal. Nothing here needs the maintainer's credentials.
- **Describe the class of defect, not a recipe.** No ready-to-run enumeration
  sequence, no live node IDs, designators, or addresses, and no reference to
  minion.town, its endpoints, or the incident. The upstream PR is about the code.
- Do not open an upstream ISSUE, and do not cross-link the fork PR from the
  upstream PR or vice versa.
- Do not touch `agoric/agoric-sdk` in any way.
- The known outbound residual (a dialed peer can still follow a THIRD node's
  retention set) is deliberately OUT of scope here and parked separately as
  `ocapn-gateway-outbound-peer-binding`. Mention it in the PR as known follow-up
  work, without implying it is fixed.
