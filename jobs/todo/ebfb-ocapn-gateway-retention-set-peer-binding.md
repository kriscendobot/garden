---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: endojs/endo-but-for-bots (base branch `llm`)

Security fix in the daemon's OCapN Gateway API. A confirmed capability leak,
derived from the exact deployed container source plus a read-only DB query by
job `deadmail-20260812T225323Z-c7db45`. Read that job's report first; do not
re-derive the closure.

## The defect

The public `/ocapn-daemon` bootstrap is **indirectly host-powerful** for any
bearer of a valid daemon location. The closure:

- `endo-bootstrap` exposes `getNodeId`, `getAgentBinding`, `getGreeter`, `help`.
- `getGreeter()` returns `EndoGreeter` with `hello` only.
- `hello(remoteNodeId, remoteGateway, cancel, cancelled)` returns the daemon's
  `localGateway`, which has `provide` and `followRetentionSet`.
- **`followRetentionSet(peerNodeNumber)` performs no session/peer binding and no
  authorization check.** It runs `listFormulaNumbersByNode(peerNodeNumber)`
  directly. `getNodeId()` publicly reveals the local node, so a caller passes
  the local node, enumerates every local formula number, combines each with the
  known node into a full formula ID, and calls `provide(id)`.
- The live formula index includes `endo`, 23 `eval`, `make-unconfined`,
  `least-authority`, workers, directories, peers, and invitations. So the
  reachable closure includes unconfined, host-equivalent authority.

`provide` is safe only while formula numbers stay secret. `followRetentionSet`
is precisely what destroys that secrecy. This is the same class as the
minion.town weblet defect just fixed: an operation performed in the daemon's own
authority on behalf of a caller who was never bound to it.

## The fix

1. **Bind `followRetentionSet` to the authenticated peer.** A caller may only
   follow the retention set of the peer it actually authenticated as over Noise.
   Passing another node number, including the local node, must be refused.
2. **Never let a caller enumerate the local node's formula index.** Even for an
   authenticated peer, the local node's formulas are not a legitimate answer to
   this query. Treat "which formulas exist locally" as never externally
   enumerable.
3. Audit the rest of the gateway surface reachable from `hello` the same way:
   every method on `localGateway` must be checked for whether it acts in the
   daemon's authority on a caller-supplied argument without binding that
   argument to the caller. Report anything else you find; fix the clear cases.

Do not fix this by making the bootstrap harder to reach. The locator gate is not
the defense: every legitimate Endo invitation's `locate()` includes
`addresses()`, and an OCapN address embeds the complete Noise designator in its
`loc=` parameter, so every invitation recipient already holds the locator. The
gate is broader than any single invitation's authority, which is the whole
problem.

## Tests

- An authenticated peer cannot follow a retention set other than its own,
  including the local node's.
- The local formula index is not enumerable through any gateway method.
- Positive control: legitimate peer-to-peer `provide`/retention behavior still
  works, so the fix does not break OCapN interop.

## Notes

- Security-sensitive. No exploit recipe in any public tracker or commit message.
- No production changes, no deploy. Containment and deploy are the maintainer's
  calls.
- The reporting job deliberately did NOT invoke `hello` or `provide` against
  production, since that handshake mutates peer/retention state. Reproduce
  locally against a test daemon, not against minion.town.
