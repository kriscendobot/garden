Report follows.

---

# Closure audit — minion.town's public OCapN endpoints

**Method:** off-host from the garden container (unauthenticated external client, fresh client keys), read-only introspection (`__getMethodNames__`/`__getInterfaceGuard__`, pure-function reads) plus a source-level closure of the deployed revision (endojs/endo-but-for-bots #693 head `803ef977`, `packages/daemon/src/networks/ocapn.js` + `manager.js` + `packages/ocapn-noise`). Read-only SSM used only to obtain designators and confirm host state. No mutating method, no code execution, no state written.

## Headline

**A material production change landed *during* this job.** At **~23:18–23:19Z on 2026-08-12** — ~5 min after I claimed this job (23:13Z), and ~37 min after the 22:41Z powers-plane containment — a **separate, kriskowal-authorized emergency containment** dropped in `/etc/caddy/conf.d/00-containment-ocapn-daemon-routes.caddy` that `respond 404`s `/ocapn-daemon*` and `/.well-known/ocapn-cbor-np*` (incl. `www.`). A concurrent worker messaged my inbox at 23:20:54Z confirming it. So the premise that "these endpoints were deliberately left untouched" is **no longer true**: the two daemon endpoints this audit targets are now **404 off-host** (I verified: `/ocapn-daemon` and `/.well-known/ocapn-cbor-np` return HTTP 404 empty; the forensics job saw 426). The backend pet-daemon container is still up on loopback `127.0.0.1:8931` — only the public Caddy route was cut. My independent closure below **corroborates that containment decision** and explains precisely why those endpoints were the dangerous surface.

## Q1 — Walk the closure of the daemon bootstrap (`/ocapn-daemon`, `/.well-known/ocapn-cbor-np`)

Swissnum `endo-bootstrap` → `EndoOcapnBootstrap` exo. Its four methods:

- `getNodeId() → string` — the daemon's **persistent agent public key** (`a677fd34…`). Public identity data. Dead-end.
- `getAgentBinding() → { agentPublicKey, signature }` — a **hardened data record of two hex strings**, precomputed once at module install (`ocapn.js:177-182`), identical for every peer. It is an *attestation* the dialing peer uses to verify the server ties its ephemeral session key to its agent key; it is not a live capability and resolves to no object. Dead-end.
- `help() → string` — static text. Dead-end.
- `getGreeter() → EndoGreeter` — **the closure continues here.** This is the word "immediate" doing its work: the bootstrap is not a host, but getGreeter is one hop from more.

`EndoGreeter` (`manager.js:1582`) has a single method:
- `hello(remoteNodeId, remoteGateway, canceller, cancelled) → localGateway`. It checks only that `remoteNodeId` is *syntactically* a node number — **no signature or identity check on the caller** — then returns the daemon's real `localGateway`. (A fresh peer supplies its own node id and a stub gateway and gets the gateway back.)

`localGateway` = `Far('Gateway')` (`manager.js:1459`), the object handed across the wire to the peer. Its **peer-reachable** methods:
- `provide(formulaId) → value` — validates the id is a well-formed local 256-bit formula id, then returns `provideController(id).value`. **No authorization check** beyond id validity: know the id → get the capability.
- `provideBlob(hash)` / `provideTree(hash)` — content-addressed reads; the 256-bit hash is a bearer read cap.
- `followRetentionSet(peerNodeNumber) → reader` — returns `SELECT number FROM formula WHERE node = ?` (`manager-database.js:160`). **Nothing constrains `peerNodeNumber` to the caller's authenticated node.**

**Where it stops — and where it does not.** `provide` is safe *only* under the CapTP assumption that formula ids are unguessable and non-enumerable (they are: `crypto.randomBytes(32)`, or `SHA256(secret rootNonce ‖ path)` for the root objects — host/agent/endo formula numbers included; verified `manager.js:569`, `manager-persistence-powers.js:78`). **But `followRetentionSet` breaks the non-enumerable half:** a session-holding peer calls `followRetentionSet(<the daemon's own node id, from getNodeId()>)` to enumerate *all* local formula numbers, then `provide(<number>:<node>)` to dereference them — reaching the **EndoHost**. So the reachable set is **not bounded to data** once a peer holds a session; it closes over the whole local formula graph via the indirect getGreeter→hello→gateway→followRetentionSet+provide path. This is exactly the "the dangerous object arrived indirectly" lesson.

*(Caveat: I could not live-exercise the `followRetentionSet(localNode)` enumeration against the deployed daemon because its route was 404'd mid-audit. The finding is source-level against the confirmed deployed revision, not live-run. The concurrent containment worker likewise reported "no hello/provide invoked.")*

## Q2 — What a valid locator requires, and how a peer comes to hold one

The gate is the **designator** — the responder's ephemeral session public key. The transport is `Noise_IK_25519_ChaChaPoly_BLAKE2s` (`ocapn-noise/src/bindings.js:160`): **the initiator must know the responder's key a priori**; the SYN is encrypted to it and the responder never transmits it. The designator is:

- **Fresh-random per daemon start** (`network.generateSigningKeys()`), *distinct from and not derivable from* the public node id (they are linked only by the `getAgentBinding` signature, which is one-way);
- **Not published** on any public surface — I confirmed the endpoints are WS-upgrade-only and leak no location JSON over HTTP;
- **Obtainable only** by reading the host filesystem (`/data/ocapn-daemon-location.json`, root) or receiving a **host-minted `endo invite`**.

Therefore, **even before the containment, `/ocapn-daemon` was NOT "open to anyone who can reach the port."** An unauthenticated internet peer with no invitation cannot complete IK and cannot reach the bootstrap at all. Holding a valid locator conveys the ability to open a session and reach bootstrap+gateway — and, per Q1, (via the followRetentionSet/provide defect) effectively the whole graph. So the realistic pre-containment threat was: **a peer given an invitation intended to convey one narrow capability actually receives host-equivalent reach through the gateway**, plus any leak of a designator (logs, a shared location file, a stored invitation). The containment (404 route) closes that residual exposure by making the endpoint undialable off-host regardless of designator knowledge. Not open to the world; now not reachable off-host at all.

## Q3 — The separate `/ocapn` Greeter demo (and the TCP demo)

Two demo surfaces are **still public and live** (untouched by both containments). I live-probed both off-host with fresh client keys:

- **`wss://minion.town/ocapn`** (426, `endo-ocapn-toy` :8930, designator `fe2017c4…`)
- **raw TCP `minion.town:8929`** (directly dialable, sg `minion-town-web`, `endo-ocapn-tcp-toy`, designator `c1ac846d…`)

Both are the standalone `ocapn-{ws,tcp}-server.mjs` `Greeter` exo. Live `__getMethodNames__` = `["__getInterfaceGuard__","__getMethodNames__","getNodeId","hello"]`; interface guard = `getNodeId()→string`, `hello(string)→string`. `getNodeId()` returned the designator; `hello("…")` returned a plain greeting string. There is **no `getGreeter`, no gateway, no host** — the locator is `{greeter}` and nothing else. **Fully bounded dead-ends**: every reachable method returns a string. This holds even if the designator leaks (nothing is at risk). Cleared, with confidence.

## Q4 — Is `getAgentBinding` per-peer?

**No, and that is the safe design here, not the defect.** `getAgentBinding()` takes no arguments and returns the **same precomputed `{ agentPublicKey: <the daemon's own node id>, signature }` constant to every peer**, minted once at install before any peer connects. A peer cannot influence it. Critically, it returns **data (a public key hex + a signature hex), not a resolvable capability** — it does not "resolve to" a shared/privileged agent object, so it is *not* the `@agent`-powers-string defect class. It conveys no authority; it is only the material a dialing peer uses to verify the server. (The genuine shared-authority concern lives one door over, on the **gateway** — Q1 — not on the agent binding.)

## Bottom line

- **`/ocapn` and `minion.town:8929` (demo greeters):** genuinely, provably **bounded** — string-returning `Greeter`s with no onward closure. **Cleared.**
- **`/ocapn-daemon` + `/.well-known/ocapn-cbor-np` (pet daemon):** the bootstrap is not a host, but its closure **does** reach the EndoHost indirectly (getGreeter → hello → gateway → `followRetentionSet(localNode)` enumerate + `provide` dereference, no ACL). Pre-containment this was **gated by the Noise-IK designator** (unpublished, non-derivable, host-only) — reachable by invited/host-adjacent peers, not the open internet. As of **23:18–23:19Z 2026-08-12** these routes are **404 off-host** (kriskowal-authorized containment, concurrent with this job); the backend remains on loopback. My closure corroborates that decision and identifies the specific confinement defect (`followRetentionSet` not scoping its node argument to the authenticated caller, and `provide` having no ACL) that made the endpoint dangerous to any session-holder — worth a durable code fix if/when these endpoints are re-exposed.

Specifics (designators, node ids, the code-level defect) are kept out of public trackers; they are in the `minion-town-deployed-topology` memory and this internal report only. No production change made; no deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ocapn-endpoint-closure-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 87 tokens (4530042 cached reads)
- Output: 58809 tokens
- Cost: $5.156304 (1 engagement(s) unpriced)
- Wall-clock: 1346s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
