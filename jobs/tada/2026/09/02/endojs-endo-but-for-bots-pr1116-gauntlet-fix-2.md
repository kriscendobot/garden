Inbox empty. Work is complete.

## Completion report

**Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #1116** (design PR: `designs/guest-native-invitations.md`)

Applied the round-2 design panel's must-fix items once, pushed as a follow-up commit (`7f2207af22`) to the PR head `design/guest-native-invitations`, and watched CI to terminal: **GREEN** (5/5 checks, 0 failed).

### Must-fixes applied (verified against source before writing)
- **§6 concurrency (critic + skeptic):** corrected the false serialization claim. `withFormulaGraphLock` is a reentrant *module-level* depth counter (`manager.js:563`) — a second top-level `accept` arriving during the first's `await formulaGraphJobs.enqueue` window sees `depth > 0` and runs inline/unqueued, so it does **not** serialize top-level accepts. Named the real serialization point (enqueue the critical section directly on the serial `formulaGraphJobs` queue) plus a compare-and-set on the pet-store entry.
- **§5 consume-once (critic + skeptic):** made the durable record GC-independent. Confirmed formula collection is off by default (`manager-node.js:43` `ENDO_GC` unset → `onCollect` early-returns at `manager.js:877`). Reworked consume-once so the `peerName` entry resolving to the acceptor's bound handle is the positive "consumed" fact a racing accept re-reads; collection is orthogonal cleanup, not correctness. Fixed the snippet to show the `storeLocator` overwrite and serial-queue enqueue; flagged the current no-callback `withFormulaGraphLock()` no-op.
- **§2/§3 connection hints (critic):** now composes with `daemon-agent-network-identity.md` (verified it prescribes per-agent `@nets`, empty = deliberate anonymizing default) instead of silently overriding it — hints source from the inviting agent's own `@nets`, cross-daemon reachability stated as a host-`move` precondition. Added that design to Dependencies.
- **§1 observability (ergonomist):** stated the pending-vs-redeemed affordance (`followNameChanges`/`followLocatorNameChanges`) and the revocation-only-while-pending rule at the surface section.
- **Problem statement (novice):** stated that today's `host.accept` mints a fresh `@pins/guest-*` guest (the baseline §2 contrasts against).
- **§4/step-2 locator (novice/copyeditor/pedant):** added `&handleNode=` to the displayed locator so "all shown in step 2's locator" is true.

### Should-fixes also folded in
Inviter-side overwrite guard on both writes/both sides (§3); shared daemon-core `acceptInvitation` helper + bind-vs-mint policy on the persisted formula + deprecated `hostNameFromGuest` + host-param rename note (§9, decomplector/ergonomist); `gcEnabled:false` consume-once test + attenuation/taxonomy tests (§8); reflow to one-sentence-per-line (CONTRIBUTING), em-dashes 22→0, `reincarnate` closed, full GitHub URLs, README tally reconciliation + dependency-graph edge + M8 row.

Did **not** re-run the panel (per stage instructions — the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3477848 cached reads)
- Output: 36798 tokens
- Cost: $3.6893219999999993
- Wall-clock: 955s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
