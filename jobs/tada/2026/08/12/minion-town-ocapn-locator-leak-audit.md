I have a complete, well-founded picture. This is a read-only audit — nothing was changed, posted, or deployed; all production reads were read-only SSM `cat`/`ls`/`docker inspect`. No commit is needed.

---

# Audit report: minion.town `/ocapn-daemon` locator/invitation leak

## The one question, answered

**No.** No OCapN address or invitation for the **current, host-powerful `/ocapn-daemon` pet daemon** has been written to any surface I could search. The only published minion.town OCapN strings are either **stale** (rotated-away session designators) or **powerless** (a toy greeter), and the current Noise gate is unpublished. Containment of the code flaw can proceed at normal urgency on this evidence; I did **not** send an urgent maintainer message because no current host-powerful address is public.

## The current daemon location (established live, read-only)

Read live from `/data/ocapn-daemon-location.json` inside the production `endo-pet-daemon` container (instance `i-0380cd68b90020fad`, host `minion-town-garden`, via read-only SSM `docker exec … cat`):

- **Current `/ocapn-daemon` designator (the Noise IK gate): `7f53f50d…e2b9a89`** (hint `ws:url ws://127.0.0.1:8930`, served publicly behind Caddy at `wss://minion.town/ocapn-daemon`).
- This value appears in **none** of the surfaces I searched — not GitHub issue/PR bodies, issue comments, or PR-review comments in either repo; not committed files; not the journal; not the minion.town or garden repos. The dangerous endpoint is **not effectively open**.

## What *is* published (and why each is not a live host-powerful exposure)

**1. Pet-daemon strings in a committed public file — STALE.**
`packages/daemon/deploy/transcripts/minion-ocapn-daemon-bootstrap.txt` in **endojs/endo-but-for-bots** (PUBLIC repo). Present on three public **draft**-PR branches — #684, #688, #693 — but **not** on `llm`/`master`. It contains, over `wss://minion.town/ocapn-daemon`:
- session designators `8c8dcf45…` and `ce47e379…` → **stale**: neither equals the current `7f53f50d…`. The transcript itself documents that the session designator rotates on restart (`8c8dcf45 → ce47e379`); it has rotated again since. A dialer using these cannot complete Noise IK with the live daemon.
- node id / `agentPublicKey` `a6cd6e01…` → the daemon's **persistent agent identity**, not the transport Noise static key. It is the `getAgentBinding`/`getNodeId` value, distinct from the IK gate (the transcript shows nodeId and designator are different keys). Knowing it does not open a session. (I did not re-derive the live nodeId; it is not the gate regardless.)

**2. Toy greeter designators in PR #693 comments + demo README — live but powerless.**
- TCP toy `minion.town:8929` (`endo-ocapn-tcp-toy`, public `0.0.0.0:8929`): designator **`c1ac846d…`** pasted in `endojs/endo-but-for-bots#693` comments (issuecomment-5111714349, -5152024262) and is **still live** (current advertised designator == pasted).
- WS toy `/ocapn` (`endo-ocapn-toy`): designator `810b996c…` in the committed demo README and #693 comments; the live WS toy designator has since rotated (`fe2017c4…`).
- **Why not dangerous:** both toy servers (`ocapn-{tcp,ws}-server.mjs`, read from the running containers) build `locator = new Map([['greeter', greeter]])` where `greeter` is a standalone `makeExo('Greeter', …)`. There is no gateway, host, `followRetentionSet`, or `make-unconfined` in the toy locator. Holding a toy designator yields only `hello()` — none of the `getGreeter().hello() → localGateway → provide(make-unconfined)` walk, which is specific to the pet daemon's wiring.

## Surfaces searched (so the negative is well-founded)

- **endojs/endo-but-for-bots** (public): every issue/PR body, all issue comments, all PR-review comments (via paginated REST dump, ~10.5 MB), grepped for `ocapn+noise`, `node=`/`loc=`, `.well-known/ocapn`, `:8929`, and all 64-hex designators/nodeIds; plus committed demo/transcript files across the OCapN branches.
- **kriscendobot/minion.town** (all issue/PR bodies + comments; and tracked files across `main`/`b5-work`/all refs) — no OCapN address strings.
- **Garden journal (`journal2`)**: `jobs/tada/`, maintainer inbox, messages, design docs — no daemon designators; the recent containment thread (08-12) confirmed.
- **Garden repo**: `designs/`, `references/`, `context/`, `roles/`, `skills/`, README — no designators.
- Live production containers/ports via read-only SSM (to establish the current value and toy liveness).

## What I could NOT search

- Off-GitHub surfaces: DMs, Slack/chat, email, external design docs, screen-shares, and anyone's local notes or clipboard history — outside my reach. The recent cross-host invite/accept demo work is exactly the activity that produces such pasted strings, so a private paste of a *now-current* designator cannot be ruled out from here.
- GitHub content that was **edited away, deleted, or force-pushed off** a branch (only current state is visible via the API).
- Private/other forks or repos I did not enumerate; rendered GitHub Pages beyond the committed sources that generate them.

## Bottom line for the containment decision

The urgent trigger — a **current** host-powerful address on a public surface — is **not** met. The current `/ocapn-daemon` designator `7f53f50d…` is unpublished; published pet-daemon strings are stale session keys plus a non-gating agent id on draft branches. The one live *public* designator (`c1ac846d…`, TCP toy `:8929`) reaches a greeter with no host authority.

## Suggested follow-ups (not acted on — read-only job)

1. Since the pet-daemon designator rotates on restart, treat the committed transcript (#684/#688/#693) as low-risk but scrub `a6cd6e01…`/`8c8dcf45…`/`ce47e379…` and the `/ocapn-daemon` bootstrap detail from those public draft PRs before they merge, on principle.
2. Decide whether the still-running public toys (`endo-ocapn-tcp-toy` on `:8929`, `endo-ocapn-toy`) should stay up now that the milestone is proven; they are powerless but are unauthenticated public listeners with publicly-pasted, live designators.
3. The real fix remains the daemon-side code change (bound `followRetentionSet` / gateway walk) tracked by the peer work; this audit only removes *urgency*, not the need for it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ocapn-locator-leak-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3390459 cached reads)
- Output: 39614 tokens
- Cost: $3.748545500000001
- Wall-clock: 969s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
