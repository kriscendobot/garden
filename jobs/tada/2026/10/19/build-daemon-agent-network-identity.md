I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1503** (head `daemon-agent-network-registration`, pinned base `llm-330cf99`). It implements the "network registration" piece of `designs/daemon-agent-network-identity.md`.

**What was left to build.** The design lists four pieces. Agent-key locators, `LOCAL_NODE`, and per-agent `@nets` (NETS) were already on `llm`, so the design's status was In Progress, not Not Started as the job body said. Network registration was the remaining piece, and this PR builds it.

**What changed** (commit `4491104e23`):
- **Interface:** `EndoNetwork` gains two optional methods, `registerAgentKey(publicKey, agentId)` and `unregisterAgentKey(publicKey)`. The daemon checks each network's method names and skips networks that lack them, so the TCP, WebSocket relay, Iroh and loopback networks are unchanged.
- **Daemon (`manager.js`):**
  - Each agent's key is registered when the host or guest is created or restored.
  - Before an agent reads its network addresses (`locate`, `getPeerInfo`, invitations), the daemon updates registrations for every agent sharing that `@nets`: it registers with networks added since the last check and unregisters from networks removed.
  - `reviveNetworks` re-checks every agent at startup, so agents created before their networks still get registered.
  - When an agent is cancelled, its key is unregistered from every network.
- **Departure from the design:** a key is registered only with the networks in that agent's own `@nets`, not with "every installed network" as the design says. Otherwise a guest with an empty `@nets` would be disclosed to every network, which breaks the design's own persona-privacy rule. The PR body says this explicitly.
- **OCapN-Noise network:** it keeps the registered keys and its peer entry point answers `servesAgent(publicKey)`. The daemon's own node is always served and can't be unregistered.
- **Docs:** I updated the design document to describe the flow as built and to mark per-agent NETS and network registration done. Its status stays In Progress because the "Per-Agent Connection Hints" section is still unbuilt. I also updated the date in `designs/README.md` and added a changeset (`@endo/daemon` minor).

**Tests:**
- New daemon test in `endo.test.js` using a recording network. It checks that a guest with an empty `@nets` is not registered, and that removing the network from a guest's `@nets` unregisters it. With the pre-read update disabled, the test fails.
- New OCapN test in `networks-ocapn.test.js` that checks `servesAgent` through a real OCapN-Noise dial.
- Locally, 101 related daemon tests pass, the daemon type-check is clean, and `pre-push-gates.sh` is clean apart from a non-blocking comment-length advisory on the registration header comment. I kept that comment because it explains the privacy reason.

**Related designs:** the related-design gate returned `attention` because #138 (per-agent `@transports`) has an open changes-requested review that says "Retire `@nets`" and asks that transports route sessions by public key. The PR body argues the two fit: routing by key needs exactly this key set. When `@nets` is retired, only where an agent's networks come from changes; the network-side methods stay the same. The PR body carries a `garden-related-design: 138,1430` marker so the panel re-checks both.

**Follow-ups:**
- **Unauthenticated `servesAgent`:** it reports whether this daemon hosts an agent, but it doesn't prove the session speaks for that agent. That would need a per-agent signature, and the network only holds the root agent's `sign` power. I left this to the #138 transport work; the panel may prefer to remove `servesAgent` until something uses it.
- **Connection hints:** the design's per-agent connection hints (relay requirement, transport preferences) are still unbuilt.
- **Environment:** to run daemon tests here I rebuilt `better-sqlite3` in this job's project worktree. It had been compiled for Node 24 and the host runs Node 22.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-network-identity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (10013146 cached reads)
- Output: 44988 tokens
- Cost: $4.187029200000001
- Wall-clock: 2168s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
