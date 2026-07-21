All work complete. Summary of what I did.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots#777 — maintainer @kriskowal asked to "add a lane for `ocapn-cbor-quic-iroh` on minion.town for validation."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved it). Fetched the comment and treated it as data.

**What I found / routed:**
- PR #777 adds `@endo/ocapn-iroh`, an iroh 1.0 QUIC OCapN netlayer (ALPN `ocapn/netstring/0`, dial-by-`EndpointId`). It's green on all 26 checks but **conflicting with `llm`** (needs rebase+merge).
- minion.town's two existing OCapN lanes are Noise-over-WebSocket, fronted by Caddy on 443 (the only open inbound port). The iroh lane is a **different shape**: it dials by EndpointId through iroh's relay mesh, so it needs **no inbound port and no Caddy route** — which should sidestep the 443-only inbound posture that stalled cross-host TCP+CBOR. That reachability is the lane's central hypothesis to validate.

**What changed:**
- Opened **kriscendobot/minion.town#12** — new design doc `designs/ocapn-iroh-validation-lane.md` defining the lane: its shape, six validation gates, the deploy recipe following the existing `deploy/aws/daemon/` durable-record precedent (including a proposed `endo-ocapn-iroh.service` with no Caddy companion), and direct answers to the maintainer's two hypotheses (redundant crypto; can't-join-noise-network). Mermaid diagram parse-validated before commit.
- Posted a routing reply on endojs/endo-but-for-bots#777 (comment 5030423448).
- Messaged the maintainer with the routing summary + the three blocking gates + an offer to queue the deployment as an orchestration once #777 lands.
- Appended the iroh-lane state to the standing OCapN project memory.

**Why design-only (not a live lane):** deployment is blocked on three gates — (1) #777 rebase+merge to `llm` (maintainer-paced), (2) a net-new `ocapn-iroh-server.mjs` listener boot script (belongs in Endo source; #777 ships only the netlayer + tests), (3) confirming the `@number0/iroh` prebuilt binary on the x86_64 box. Standing up a live listener from an unmerged, conflicting PR with no server entry would have been wrong; the design makes the eventual deployment bounded, reviewable work.

**Follow-ups (awaiting maintainer):** whether to queue rebase #777 → merge to `llm` → author the iroh boot script → stand up + validate the live lane as an orchestration, or hold for design review first. No changes to the garden repo (main2) — this job mutated only the minion.town project repo.
