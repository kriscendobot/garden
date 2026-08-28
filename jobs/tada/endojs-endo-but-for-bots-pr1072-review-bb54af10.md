Verified on resume — all my work from the prior session is durably landed on the remote; the reaper requeue was spurious (the earlier session completed the deliverables before it was interrupted).

## Verification (this resume)

- **The ask** (inline comment `3877708521` on `designs/ocapn-noise-network.md`: capture the multiple-connection-hint rationale into the design guidance; review body was empty) is resolved by commit **`da0428084`** — confirmed in the branch ancestry of `fix/ocapn-noise-tcp-single-url-hint`.
- The **"Why a location carries multiple hints"** section is present in the current head (lines 133–158), covering every note: per-platform hint filtering, web can't do direct TCP / raw WebSocket / raw IPv6, TLS depends on DNS+CA, relay-free IPv6 TCP on a partitioned LAN, and planned relay hints enabling speculative connection races.
- My inline **reply `3877744417`** is threaded correctly (root `3877694260`) and the 🚀 **reaction** on the original comment is present.

## Note

Two peer follow-up commits (`6f2553b04`, `5f6fd98925`) later refined the hint grammar to `<transport>+<codec>=host:port` on top of my section (a different pr1072 review job, `…-73226ec0`) — they built on my commit rather than colliding, so my content persists intact.

No remaining asks, no follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-review-bb54af10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 10 tokens (279060 cached reads)
- Output: 2672 tokens
- Cost: $2.018963
- Wall-clock: 425s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
