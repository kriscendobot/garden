## Job report: issue-kriscendobot-garden-117 (dckc: OCapN over Cloudflare RPC / Cap'n Web)

I posted a feasibility sketch on the issue and queued a designer job to write the detailed endo-but-for-bots design. I haven't built or run anything on Cloudflare; the sketch is based on reading code, and it marks the Cloudflare claims it could not confirm with *(verify)*.

**Feasibility sketch (the verdict is "feasible")**
Posted at https://github.com/kriscendobot/garden/issues/117#issuecomment-5904154362. It is based on the current ebfb `llm` tree: `packages/ocapn/src/client/types.js`, `codec-interface.d.ts` and `sturdyrefs.js`.

- **Netlayer:** use Cloudflare only as a message channel between OCapN peers, and let OCapN carry the object references. There are three candidate carriers: a Durable Object / WorkerEntrypoint RPC method, a Cap'n Web object that receives messages, or a hibernatable WebSocket. Each one fits the existing interface where the transport hands over one OCapN message at a time as bytes.
- **Grant-matching:** platform RPC doesn't tell the callee who is calling. OCapN's key-based handshake and its three-party handoffs fill that gap without help from the platform.
- **Each Durable Object acts as one OCapN location (a vat).**
- **Closing the `fetch` hole:** the confined facet's only outbound capability becomes an OCapN connection handed down by the supervisor. It gets no `fetch` or general outbound access.
- **Sturdyrefs:** yes, they work. Each Durable Object keeps a table of secrets in its storage; looking one up re-creates the object, and deleting the row revokes it. The "copy URL" button becomes "copy a sturdyref", and liveslots isn't needed.
- **The p.s. (structured clone / Cap'n Web values instead of bytes):** feasible, with one real change. Endo's codec reader/writer interface is already abstract, so a codec that works on plain JS values can implement it. What has to change is the outer type, which today is fixed to raw bytes, so it must become generic over the message type.
  - OCapN's record, tagged, selector and set types have no native equivalent on either platform. They would use a tagged-array escape borrowed from Cap'n Web.
  - One hard limit: anything signed (location signatures, handoff certificates) must stay as canonical Syrup bytes.
  - OCapN and Cap'n Web should not both do promise pipelining.
- **Open risks:** message ordering and reliability, sessions surviving hibernation, the facet storage quota, how Noise (which encrypts bytes) fits with messages that aren't bytes, and a test harness on Miniflare/workerd.

**Follow-on job**
I posted `design-ebfb-ocapn-cloudflare-netlayer` (role: designer, tier mentor with minion fallback). It asks for `designs/ocapn-cloudflare-netlayer.md` in endojs/endo-but-for-bots, covering everything above, and tells the designer to check each *(verify)* claim. The ISSUE NOTE is copied verbatim so that job can comment back on #117. The issue is left open for dckc to close.

**Follow-ups**
- There is a related existing job, `build-endo-daemon-cloudflare-storage`; the designer may want to look at it.
- No garden code changed and nothing was committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (551286 cached reads)
- Output: 10416 tokens
- Cost: $0.7437452
- Wall-clock: 139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
