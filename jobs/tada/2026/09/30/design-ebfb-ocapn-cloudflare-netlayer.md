## Completion report: design-ebfb-ocapn-cloudflare-netlayer

I wrote the design for OCapN over Cloudflare RPC and Cap'n Web. It is open as **draft PR [endojs/endo-but-for-bots#1388](https://github.com/endojs/endo-but-for-bots/pull/1388)**: head `design/ocapn-cloudflare-netlayer` (commit `0953969f4b`), base is the frozen `llm-7ff30af`. I linked it from [kriscendobot/garden#117](https://github.com/kriscendobot/garden/issues/117#issuecomment-5904227139) and left the issue open.

**What changed**
- New `designs/ocapn-cloudflare-netlayer.md` (slug `ocapn-cloudflare-netlayer`, status Proposed), following the repo's `designs/AGENTS.md` conventions.
- One row added to the summary table in `designs/README.md`.

**What the design covers**
- **Carriers:** a new `cf` network with three ways to reach a peer:
  - a Durable Object or `WorkerEntrypoint` RPC mailbox;
  - a mailbox object over Cap'n Web;
  - a hibernatable WebSocket carrying bytes.
- **Location scheme:** the peer's address uses the Ed25519 public key as its identity; the DO name and Cap'n Web URL are only hints for reaching it.
- **Peer identity:** the network runs its own signed challenge handshake, bound to the session. The code showed that the default OCapN handshake does not tie a peer's claimed identity to its key, and the platform gives the callee no caller identity.
- **Ordering and reliability:** every frame carries a sequence number with a bounded reorder buffer. Delivery is at most once and a failed delivery is never retried; it ends the session.
- **Session lifetime:** a session lives only as long as its isolate. On eviction or hibernation, peers reconnect and recover what they need through sturdyrefs.
- **Confinement:** the confined worker is loaded with `globalOutbound: null`, and its only way out is an OCapN endpoint handed down by the supervisor.
- **Sturdyrefs:** a table of secrets and object rows in DO storage handles mint, enliven and revoke, with no liveslots. This replaces the counter demo's "copy URL".
- **Native-value serialization (dckc's p.s.):**
  - OCapN's codec becomes generic over its message type instead of always producing bytes.
  - One array-tag escape convention works over both Workers RPC and Cap'n Web.
  - This refines the sketch: signed parts can travel as native values, because signatures are already checked by re-encoding the decoded structure. Only a separate canonical signing codec produces bytes.
  - It states how this relates to Noise and forbids layering Cap'n Web pipelining under OCapN's own.
- **Supporting sections:** an ownership map, a test plan (codec round-trips, a Syrup-equivalence property, the existing client/handoff/sturdyref suites over an in-memory network, and a workerd/Miniflare harness), and phased implementation.

**Checks of the "(verify)" claims** (a table in the doc cites a source for each)
- **Confirmed:**
  - `globalOutbound: null` blocks `fetch` and `connect`.
  - DO facets each get their own SQLite database.
  - `ctx.props` exists, but it is set by whoever configures the binding, so it is not caller identity.
  - Calls on one DO stub arrive in order.
  - The hibernation attachment limit is 16 KiB.
  - DO storage limits are 10 GB per object and 2 MB per key plus value.
- **Refuted:**
  - Cap'n Web does not preserve `-0`, so the design escapes it itself.
  - Cap'n Web does not support `Map` or `Set`.
  - Cap'n Web sessions cannot resume after a disconnect.
  - The runtime does not guarantee at-most-once delivery.

All three mermaid diagrams passed the parse check.

**Open questions** (in the doc and the PR body; the maintainer needs to decide these)
1. Should the codec be chosen per network?
2. Should the signing codec be fixed to Syrup or configurable?
3. Where does storage and a quota come from for confined workers that are not DO facets?
4. Is the plain-object shortcut for dictionaries worth having a second representation?
5. Should there be an optional keep-alive for live references?

**Follow-ups:** none posted. The PR stays draft for the automatic design-panel review. Implementation phases 1–4 are laid out in the doc for a later build job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ebfb-ocapn-cloudflare-netlayer.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2650190 cached reads)
- Output: 36540 tokens
- Cost: $2.8464802000000007
- Wall-clock: 417s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
