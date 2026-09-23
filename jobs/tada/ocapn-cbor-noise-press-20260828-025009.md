Done. This dispatch is complete. Summary of what I did:

## Completion report

**Assessment (goal already met).** The standing press goal — garden host ⇄ minion.town daemon over OCapN-CBOR-Noise, bootstrap located + invoked — was proven end-to-end in the prior tick (2026-08-28, issue #58 comment 5447277859). I re-verified live this tick: `https://minion.town/.well-known/ocapn-cbor-np` serves **426** (was 404), and TCP **`minion.town:3469`** (pluribus, raw TCP+CBOR+Noise, opened at the maintainer's request) accepts connections. `#340` and `#886` are now both **merged** to `llm`.

**This tick's work — the freshest maintainer directive.** The maintainer's 02:49Z comment (issuecomment-5447781817) revised the hint model: *"Separate hints for the TCP host and port is an aberration. There should only be one hint per transport protocol."* I traced this to the **merged** transport-separation design (`#886`) and merged `@endo/ocapn-noise` code, which both specify the two-hint TCP model (`tcp+cbor:host` + `tcp+cbor:port`). Since `#684` (the daemon adapter that consumes this) is still **deferred and unbuilt**, I revised the design *now* so #684 builds to the correct model rather than reworking the aberration.

**Changed:**
- `designs/ocapn-network-transport-separation.md` — revised to **one hint per transport protocol**: hint key is the bare scheme, value is the single connection string (`tcp+cbor` = `host:port` authority, IPv6 bracketed; `ws` = dial URL). `TransportListener` now exposes a single `hint: string`. Updated the table, example, and API contracts.
- Opened **endojs/endo-but-for-bots#1071** (draft) with the revision.
- Posted a consolidated status to **kriscendobot/garden#58** (issuecomment-5447839678).

**Deliberately left as-is:** #1071 stays **draft** — it carries one clear encoding question to the maintainer (bare-scheme key vs a single `tcp+cbor:addr` field), the kind of genuine design detail my proxy delegation routes to the maintainer rather than self-merging. No live wire change was made; the deployed toys keep their self-consistent current form until #684 rebuilds and redeploys together.

**Open follow-ups (maintainer-gated, tracked on #58, not re-nagged):**
1. #1071 encoding confirmation.
2. Guest-by-formula-id **peer-fetch**: whether to expose the guest-substrate daemon (`endo-daemon@8920` loopback) over a public OCapN route, or unify onto the pet-daemon (asked at issuecomment-5447765615).

**Press not retired** — the core goal is met, but the maintainer is actively extending the arc; proposing retirement now would be premature.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-cbor-noise-press-20260828-025009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2872459 cached reads)
- Output: 32328 tokens
- Cost: $3.2293114999999997
- Wall-clock: 519s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
