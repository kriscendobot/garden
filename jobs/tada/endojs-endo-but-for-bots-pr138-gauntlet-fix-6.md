CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Stage:** Gauntlet FIX round 6 — endojs/endo-but-for-bots PR #138 (`design/ocapn-daemon-integration.md`).

**What I did:** Read the round-6 panel verdict (request-changes, disposition must-fix), applied its items once to the design doc, pushed as a follow-up commit to the PR head, and watched CI to terminal.

**Changes applied (`cb800c2ef`, one commit on `design/ocapn-daemon-integration`):**
- **critic (must-fix):** Withdrew Design Decision #3's unsupported "gateway and `Transports` converge on one Ed25519 identity" claim — verified against `gateway-bearer-token-auth.md` that the gateway token is an opaque **formula identifier**, not an Ed25519 key; reframed the two ingress paths as distinct. Added a one-sentence gateway gloss at first use (also resolves novice-1).
- **critic (must-fix):** Reconciled with `daemon-agent-network-identity` — added a **Supersedes** metadata row, stated that `@transports` supersedes that design's per-agent `NETS` and `registerAgentKey`/`unregisterAgentKey` pieces while building on its two done items, and corrected its cited status to **In Progress**.
- **skeptic (should-fix ×3):** Fixed the cleartext-preamble tradeoff's initiator-vs-passive-observer conflation (conceded the real metadata leak, kept the O(hosted-agents) ground load-bearing); added a Test Plan bullet for the shared-transport-instance GC close-all-sessions invariant; stated the atomic same-PR cutover boundary and rollback story.
- **decomplector:** Dropped redundant `outboundPolicy.allowSchemes`; scheme gating now has a single revisable source of truth (top-level `allowedSchemes`), and the reconciliation-precedence paragraph is gone.
- **ergonomist (must-fix + should-fix):** Flattened `endo agent <name> transports {…}` to flat `--as <agent>` verbs (verified the CLI has no second-level command groups); renamed `add`→`listen` to map 1:1 onto `listen()`; noted `Session`/`Listener` carry no own `close()`; corrected the nonexistent `endo nets` retirement in Decision #10 + Compatibility.
- **copyeditor/pedant/novice:** glossed `np` and "membrane" at first use, re-anchored `provideTransports` `options`, `Goal #1`→`Limitation #1`, consistent `Design Decision #N` form, Affected-Packages parallel form, Author field, connector consistency, split a dangling participial clause.
- Verified **no em-dashes / arrows / curly quotes** introduced (em-dash-style / typist rules).

**CI:** GREEN — `rollup-terminal … total=5 failed=0` (rc 0).

**Follow-ups:** None from me — per the staged-gauntlet contract I stop here; the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (7542190 cached reads)
- Output: 48085 tokens
- Cost: $6.3079719999999995
- Wall-clock: 1106s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
