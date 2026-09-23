---
ts: 2026-05-14T21:18:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: designer amends Noise Protocol design with session-reconnect semantics

Dispatch root: `dispatches/designer--e0ae8a/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached). Per the new designer policy, open a draft PR carrying the design amendment against `llm`. Branch: `design/ocapn-noise-session-reconnect`.

## Maintainer directive (2026-05-14)

> When I was discussing OCapN Noise Protocol transports with @erights, he reminded me that the TCP default timeout is four days and it does not do liveness checks. This generally has led in the direction of meta-TCP protocols for CapTP where sessions have a much shorter timeout, continuous ping/pong heartbeat, and can be reestablished with a TCP reconnect by either side (crossed hellos being accounted for). This would have implications for the Noise Protocol cryptography, which does have a path for sequencing encrypted packets where the sequence may continue across a sequence of TCP sessions. Please dispatch a designer to amend the Noise Protocol as it stands on llm. This may require tentatively extending OCapN to handle op:ping messages (which would be heard as pong by the recipient, if that name distinction is useful).

erights' authority: per `journal/projects/endo/README.md`, erights is a senior contributor on ocap, captp, marshal, eventual-send, ses, pass-style, harden, patterns, and the OCapN-family protocol — his technical input on a topic-matching design carries kriskowal-equivalent (or greater) weight. The directive is the maintainer relaying erights' framing; the design treats erights' framing as load-bearing.

## Existing designs on llm to read first

- `designs/ocapn-noise-network.md` — the primary Noise Protocol design (the immediate target for amendment).
- `designs/ocapn-noise-cryptographic-review.md` — the security-side of the Noise design; consult for what's already settled vs open on the crypto axis.
- `designs/ocapn-tcp-syrups-framing.md` — the TCP transport framing. Session-reconnect concerns may also belong here; the designer picks.
- `designs/ocapn-network-transport-separation.md` — the separation of transport and CapTP layers; consult to understand what's CapTP-level vs transport-level.

## What to encode

The session-reconnect amendment covers several intertwined concerns; treat them as one coherent design addition:

1. **Why the amendment.** TCP's default keepalive timeout is roughly four days and does not check liveness; an idle TCP connection looks alive long after the peer has crashed or the network has partitioned. CapTP needs a much shorter timeout and continuous liveness signal.

2. **Heartbeat protocol.** A continuous ping/pong heartbeat between the two ends of the session. The maintainer tentatively proposes extending OCapN with `op:ping` messages — heard as `pong` by the recipient, if the name distinction is useful (i.e., does the same op-code mean "ping" if you're sending and "pong" if you're receiving, or are they distinct ops with explicit pairing). The designer decides.

3. **Reconnection.** Either side may re-establish the underlying TCP transport when the heartbeat detects loss. Crossed-hellos handling (both ends try to reconnect simultaneously and see each other) needs an explicit tiebreaker.

4. **Noise sequence continuity across reconnects.** The Noise Protocol's encrypted-packet sequence number can continue across a sequence of TCP sessions (Noise itself supports this; the Noise spec's `CipherState.n` counter is per-direction and per-session-key). The amendment specifies how the sequence is preserved when the underlying TCP connection drops and re-establishes. Critical: the design must NOT allow nonce-reuse across reconnect — that would compromise the Noise cipher entirely. Reference Noise spec for the relevant requirements.

5. **Tentative OCapN op:ping extension.** The amendment proposes (tentatively, pending wider OCapN consensus) extending OCapN with `op:ping`. The designer drafts the op-encoding, the response-shape, and whether `op:ping` and `op:pong` are the same op-code reinterpreted by direction, or distinct. The amendment names this as "proposed; pending OCapN-org review".

6. **Timeout values.** The shorter session timeout. The designer proposes a default (e.g., 30 seconds with heartbeat every 5; or 60s with heartbeat every 10) and a tunable range.

## Per-action authorization

Standing on endo-but-for-bots: push, open the draft PR (per the new designer policy). READ-ONLY on `ocapn/ocapn` and `endojs/endo` — no comment, no cross-link.

## Task

1. **Read the existing designs** in the order listed above. Then read enough of the Noise Protocol spec ([noiseprotocol.org](https://noiseprotocol.org/noise.html)) to confirm what the spec permits for sequence-number continuity across re-keyed sessions vs across reconnects on the same key. WebFetch where needed.

2. **Decide the amendment's home.** Either:
   - A new section in `designs/ocapn-noise-network.md` (single-file amendment), OR
   - A new sibling design `designs/ocapn-noise-session-reconnect.md` cross-linking the existing files (multi-file).
   
   Pick whichever produces the cleaner reader-experience. The user's framing ("amend the Noise Protocol as it stands") suggests an in-place amendment, but a new sibling may read more cleanly if the new content is substantial.

3. **Author the amendment** covering all six concerns above. Each concern gets its own subsection. Lead the amendment with a short *Rationale* citing erights' framing (TCP timeout, no liveness; meta-TCP session needed). Each subsection ends with the open questions (timeout values, op:ping shape, crossed-hellos tiebreaker, etc.) — surface them rather than picking unless the choice is obvious.

4. **Diagrams.** One mermaid sequence diagram showing: A and B in steady-state heartbeat exchange → TCP drop on B's side → A's heartbeat times out → A initiates reconnect → A and B re-handshake (Noise resumption variant or fresh handshake?) → sequence numbers resume → heartbeats resume. Another mermaid for the crossed-hellos case (both A and B reconnect simultaneously) showing the tiebreaker.

5. **Length.** Aim 2-4 screens. Cross-link aggressively to the existing designs rather than copy-pasting; the amendment stands alone but cites the canonical Noise / TCP / OCapN docs for the substrate.

6. **Open the PR as DRAFT** against `llm` per the new designer policy (gardener `3159ab` landed today). Branch: `design/ocapn-noise-session-reconnect`. Title: `design(ocapn,noise): session reconnect with heartbeat (per erights/kriskowal 2026-05-14)`. Body cites the maintainer directive, the existing designs touched, and the OCapN-op:ping proposed extension.

## Out of scope

- No implementation. Design-only.
- No edit to `endojs/endo` or `ocapn/ocapn`. The amendment lives on the bots fork's llm; the boatman ferries to upstream OCapN-org later when the maintainer authorizes.
- No comment on any external PR or issue.

## Report

≤ 500 words: path to the design file(s) added or amended, the chosen layout (in-place vs sibling), one-paragraph abstract of the amendment, the open questions list, PR URL, one-line `Self-improvement: ...`.
