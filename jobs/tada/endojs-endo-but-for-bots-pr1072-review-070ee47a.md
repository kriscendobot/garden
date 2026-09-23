---
handed-off: endo-1072-address-review-multihint
deliverable-complete: false
---
The fixer job is confirmed on the board (`jobs/todo/endo-1072-address-review-multihint.md`, commit `b565de94b8` on `origin/journal2`). My local `journal/` worktree was just stale.

This review-directive job is resolved by routing the substantive rework to a fixer, as the directive instructs.

---

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #1072 — kriskowal's `CHANGES_REQUESTED` review `#pullrequestreview-5063029094`.

**Preflight:** `pr-feedback-preflight.sh` returned **exit 0 (PROCEED)** — no correlated peer resolution existed on the PR for this review. Verified against the board directly: nothing under `jobs/{plan,todo,doin,tada}/` addressed it before this run.

**Enumerated the whole review as the unit of work.** The top-level review body is empty; the review carries **four inline comments**, all fetched and treated as directives from the trusted reviewer (other PR text treated as untrusted data):
1. `designs/ocapn-noise-network.md:80` — change the locator URL scheme `ocapn://` → `endo://` ("not front-running consensus").
2. `designs/ocapn-noise-network.md:129` — add a URL **path** for the wss transport, consistent with minion.town.
3. `packages/ocapn-noise/src/transports/tcp.js:91` — **omit** a hint rather than advertise localhost; prefer IPv6; leave a **pluggable** public-IP-discovery seam; advertise IPv6+IPv4 as a prioritized list.
4. `packages/ocapn-noise/src/transports/tcp.js:130` — listener `hints` → a **priority-ordered list**, multiple hints per protocol (multiple link-layer addresses).

**Assessment:** Comments 3 & 4 **reverse the PR's own thesis** ("one hint per transport — single `tcp:url`"). Satisfying them is a coherent cross-cutting rework touching the wire/locator format (`OcapnLocation.hints`), `network.js` aggregation/selection/connect, both real transports (`tcp.js`, `ws-node.js`), the `mock.js` transport, the daemon consumer (`packages/daemon/src/networks/ocapn.js` ~279-318), `types.d.ts`, the changeset, and multiple test files — plus a genuine design seam (pluggable public-IP discovery) and a wire-format decision. Per the directive ("Route the work to a fixer/designer"), I routed it rather than half-landing a wire-format change under this budget.

**What changed:** Posted a fixer job **`endo-1072-address-review-multihint`** (tier `builder`, fallback `mentor`) to the board, confirmed live at `jobs/todo/endo-1072-address-review-multihint.md` (journal2 `b565de94b8`), directive identity `endojs/endo-but-for-bots#1072:comment:5063029094`. The spec enumerates all four asks with exact file:line anchors, quotes each maintainer directive, names every ripple file, instructs pushing to the existing PR head branch `fix/ocapn-noise-tcp-single-url-hint` (no new PR), keeping it draft, running local verify, replying on the review threads, and escalating to the maintainer if the wire-format change proves contentious rather than guessing.

**Follow-ups:** The fixer job owns all remaining implementation. No garden-repo (`main2`) changes were needed for this routing job.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-review-070ee47a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1163952 cached reads)
- Output: 24297 tokens
- Cost: $1.935158
- Wall-clock: 393s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
