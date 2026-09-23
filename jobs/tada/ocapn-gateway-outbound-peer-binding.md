The work is complete. Here is my completion report.

---

## Job complete: OCapN outbound gateway peer-binding

**What the residual was.** #978 bound the *inbound* `hello` gateway to the authenticated peer (`makeGatewayForPeer`), but on the **outbound** path — a peer WE dial — every transport still presented the shared `localGateway` (`E(powers).gateway()`) as both its CapTP bootstrap and its `hello` argument. That bearer isn't bound to the dialed peer, so a peer we dial could call `followRetentionSet(thirdNode)` and receive the formula numbers we retain for a **third** node — formula ids `provide` accepts, i.e. cross-peer capability confusion. (It never reopened local-index enumeration; `localGateway` refuses the local node outright.)

**The fix.** We know the dialed peer's node up front in `makePeer(nodeId)`, so I bound there:
- `manager.js` — `makePeer` builds `makeGatewayForPeer(nodeId)` and threads it into `E(network).connect(address, ctx, outboundGateway)`.
- All three transports (`tcp-netstring`, `ws-relay`, `iroh`) — `connect` takes an optional `peerGateway` and presents it instead of the shared bearer, falling back to `localGateway` for loopback / older callers.
- `types.d.ts` — `EndoNetwork.connect` gains the optional `peerGateway`.
- New `test/outbound-gateway-binding.test.js` — drives the real tcp-netstring transport over loopback and asserts the dialed peer's gateway follows only its own node (refuses a third node and the local node), plus the unbound-dial fallback.

**Verification.** New test 2/2; cross-daemon `invite-retention` 10/10 (real outbound dials — interop preserved); `remote-control` 11/11; lint 0 errors; tsc 0 errors. The daemon-forking suites (endo.test.js, ws-relay.test.js) fail only on a pre-existing environmental `ENOENT …/endo.sock` startup quirk in this warm-cache worktree — confirmed **identical on the pristine base**, not a regression.

**Delivered.** Draft PR **endojs/endo-but-for-bots#979**, base `llm`, **stacked on #978** (which supplies `makeGatewayForPeer` and isn't in `llm` yet). Branch `ocapn-gateway-outbound-peer-binding` on the `kriscendobot` fork.

**Follow-up (not done, correctly gated).** The upstream `endojs/endo` `llm` port: upstream *shares the outbound transport shape* (same `gateway()`→`localGateway`→`hello` pattern), but its daemon code (`packages/daemon/src/daemon.js`) is entirely **pre-#978** — no `makeGatewayForPeer`, `hello` returns the shared gateway. There's **no upstream #978-port branch or PR** to stack on. Building the upstream outbound fix now would require also porting #978's inbound binding, which is the separate parked job `endo-upstream-llm-retention-set-peer-binding`. So the upstream outbound port should be posted as a follow-up once that inbound port lands, mirroring how #979 stacks on #978.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-gateway-outbound-peer-binding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 207 tokens (13840352 cached reads)
- Output: 89003 tokens
- Cost: $11.011858999999996
- Wall-clock: 1432s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
