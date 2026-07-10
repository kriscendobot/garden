---
kind: message
role: liaison
host: endolin-garden2-5bcdff64
at: 2026-07-10T16:25:36Z
---
# Recommended maintainer review/merge order — unblock the most fleet work first

Compiled 2026-07-10 by the liaison (endolin-garden2 follower) from the 42 unread
maintainer-inbox messages. **The inbox is dominated by one signal: the foreman
reported six times (21:22, 23:43, 04:59, 05:13, 09:57, 15:59) that the fleet has
no buildable M3 work left — every next increment is stacked behind ready PRs that
sit green, non-draft, and unmerged on the fork's `llm` branch.** Forward progress
is a review/merge decision, not more building.

Every PR in the ordered list below was verified **OPEN, non-draft, MERGEABLE,
mergeStateStatus=CLEAN** at compile time. The stacks are linear (each follower's
`base` is its predecessor's head), so merge **bottom-up from each root**; merging a
root is the single action that unblocks its whole stack (each follower then
retargets/rebases onto `llm`).

## Ordered review list (top unblocks the most)

### Tier 1 — stack roots (one merge each frees a whole stack)
1. **endojs/endo-but-for-bots#650** — mount-revocation caretaker + deny patterns (PR A of #127), base `llm`. **Highest leverage:** root of the entire daemon-mount stack — unblocks #652, #653→#655→#657, the rust-parity #654, and #656/#658. https://github.com/endojs/endo-but-for-bots/pull/650
2. **endojs/endo-but-for-bots#609** — endoclaw-timer Phase 1 (interval-scheduler formula), base `llm`. Root of the timer stack — unblocks #617→#619. https://github.com/endojs/endo-but-for-bots/pull/609
3. **endojs/endo-but-for-bots#618** — daemon-agent-tools Phase 4 (dynamic capability-tool discovery + form provisioning), base `llm`. Standalone; unblocks the Lal/Fae coding-capabilities follow-ons. https://github.com/endojs/endo-but-for-bots/pull/618

### Tier 2 — daemon-mount stack, merge order after #650
4. **#653** — mount glob (PR B), base `feat/mount-revocation`. Unblocks #654/#655/#657. https://github.com/endojs/endo-but-for-bots/pull/653
5. **#655** — mount grep (PR C), base `feat/mount-glob`. Unblocks #657. https://github.com/endojs/endo-but-for-bots/pull/655
6. **#657** — mount JSON read/write (PR D), base `feat/mount-grep` (leaf). https://github.com/endojs/endo-but-for-bots/pull/657
7. **#652** — CLI `--deny/--no-deny` for mount deniedSegments, base a frozen `#650` snapshot; after #650 lands it needs a `rebase #652` → `run the gauntlet #652` → merge. https://github.com/endojs/endo-but-for-bots/pull/652
   (plus the remaining stacked mount followers #654 rust-parity, #656, #658.)

### Tier 3 — endoclaw-timer stack, after #609
8. **#617** — timer Phase 2 (deliver interval ticks as mail + TickResponse exo), base `#609` head. https://github.com/endojs/endo-but-for-bots/pull/617
9. **#619** — timer Phase 3 (startup recovery re-arms intervals + coalesced catch-up tick), base `#617` head. https://github.com/endojs/endo-but-for-bots/pull/619

### Tier 4 — agoric-sdk fork keystone
10. **kriscendobot/agoric-sdk#8** — regenerate `fetched-chain-info.js` (clear test-codegen). MERGEABLE (UNSTABLE = a non-required check). Merging it clears the **global codegen drift** that is the *only* red on both #10 (docs/beans-v2) and #9 (ymax-critical prototype); each then just needs a weave/rebase onto master. https://github.com/kriscendobot/agoric-sdk/pull/8

## NOT review-ready — need a DECISION or a FIX, not a merge (don't burn review time expecting to approve)
- **endojs/endo-but-for-bots#644** (git commit amend/reword) — panel returned **CHANGES_REQUESTED**: a real correctness bug in `reword('HEAD')` folding a staged index into a "message-only" amend. The **0xpatrickbot fleet is actively pushing fixes to the same branch** — needs the fix loop, not review. Blocks the git-verb stack #645→#646.
- **#661** (`provideHttpClient`/`makeHttpTool` gauntlet) — reaper-**poisoned** (requeue-exhausted), parked go-ahead-gated in `jobs/plan/`. Its blocking lint red (#594 ceiling) now shows green — needs your **promote-plan** call to re-run. This is the M3 "confined outbound HTTP" criterion.
- **#671 vs #403** (mvs-resolver home) — architectural decision: the resolver lives in BOTH `@endo/daemon/registry.js` (#671) and `@endo/exo-npm` (#403), and #564 was closed ruling it belongs at the package boundary. **The fleet is colliding with itself** — pick the home before any more MVS build.
- **#286** (http-client Phase 1) — a real **Node-22-specific** bug (undici `Headers` lazy `Symbol(headers map sorted)` frozen by hardening → CapTP error-decode throws). Needs a **fixer**, not review.
- **kriscendobot/agoric-sdk #12 / #13 / #14** — four **within-consensus decisions** await you: golden-snapshot-hash regen vs. hold, `METER_TYPE` xs-meter-36→37 bump, Leg-4 `force:integration` waiver (Depot-gated, infeasible on the fork), and whether draft #14 (park-on-fail, green) counts as "landed" for garden#33.
- **kriscendobot/minion.town#7** (endo-root-host) — reviewable on its own merits, but live validation is gated behind human **Gate 1** (Claude ↔ live MCP OAuth) that only you can complete.

## Operational note (deferring to the leader host)
The leader (`endolin-garden-ece02cb4`) reported its **foreman pump handler failing rc=1**
twice (08:09, 14:04): `foreman-claude.sh: line 92: designer: command not found` /
`builder: command not found` — the board pump may be starving. Self-heal also hit a
session limit ~08:06–08:36Z. Flagging for the leader's liaison; not this follower's to fix.
