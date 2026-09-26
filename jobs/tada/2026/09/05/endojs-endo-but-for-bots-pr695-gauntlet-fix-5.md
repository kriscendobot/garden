CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** FIX round 5 of the endojs/endo-but-for-bots PR #695 gauntlet (design PR: `designs/sturdy-refs-agent-surface.md`, agent provide/accept surface for sturdyrefs).

**Panel round-5 must-fix / should-fix items applied** (one follow-up commit `b4a30778e3`, "design(sturdy-refs): address panel round 5 review"):

- **critic (Phase 2 gap):** The design asserted attenuated-worker mail attachments arrive as sturdyrefs but scheduled no step for the daemon's outbound-mail serialization (`externalizeForMessage`/`externalizeMessage` in `packages/daemon/src/mail.js`). Corrected § Distributed confinement and Phase 2 to scope attenuated-worker mail attachments **out**: the recipient-confinement-aware serialization is named as separate daemon mail-pipeline follow-on, not work this surface completes; Phase 2 only removes `lookupByLocator` (which creates the narrowing).
- **skeptic #1 (GC-auditability):** Case 1 ("no retention edge for same-turn") now states explicitly that the formula stays reachable through its pre-existing formula-graph root during the turn, not via GC-timing luck, reconciling it with case 2's disqualification of GC substitutes.
- **skeptic #2 + decomplector (turn defined in Lal-only terms):** Rewrote § Tool-layer escrow to define the turn boundary as a **value-level monotonic turn epoch** stamped on each render-map entry and checked at redemption, and enumerated each agent's actual turn-completion point (Lal `runOneRound`, Fae `runAgent`, Genie each `runUserPrompt`/`runHeartbeat` dispatch, heartbeat treated as its own turn). Phase 4 / acceptance criteria now require the negative test run against each agent's actual loop shape.
- **ergonomist #1 (unknown vs stale):** Handle-redemption failure now distinguishes **unknown** (fabricated text) from **stale** (valid prior-epoch entry), with distinct remediations; added to acceptance criteria.
- **ergonomist #2 (disclosure text):** Pinned a single shared handle-contract description fragment in `@endo/agent-tools`, consumed verbatim by all three agents, alongside the shared grammar constant; added to Phase 4 and acceptance criteria.
- **copyeditor / novice (render map defined ~300 lines late):** Added a forward-pointer gloss at first use in the Summary.
- **copyeditor (spelling):** "defence in depth" → "defense in depth".
- **novice (unglossed terms):** Added one-sentence glosses for **facet**, **`EndoGuest`**, and flagged the **locator** term-collision at its point of reuse in § One passable representation.
- Bumped **Updated** to 2026-09-05. Verified no em-dashes / typist-hostile code points introduced.

**Push & CI:** advanced `origin/design/sturdy-refs-agent-surface` `a5a62d75e9 → b4a30778e3` via `safe-push-pr-head.sh`. Bounded CI watch returned **rc 0 — GREEN** (5/5 checks, 0 failed).

**Follow-ups:** none for this stage; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (2351628 cached reads)
- Output: 21512 tokens
- Cost: $2.535634
- Wall-clock: 691s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
