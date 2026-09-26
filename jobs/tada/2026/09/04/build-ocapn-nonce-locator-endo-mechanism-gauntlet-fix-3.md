Confirmed: head is my fix commit `f72ab327e`, **0 failures, 0 pending, MERGEABLE**. The fix stage is complete and CI is green.

## Completion report — FIX round 3, endojs/endo-but-for-bots PR #1124

Applied the panel round-3 must-fix set to the nonce-locator mechanism, pushed as review-feedback follow-up commit `f72ab327e` on the PR head (`kriscendobot:build/ocapn-nonce-locator-mechanism`), and watched CI to a **green** terminal state.

**Blocking findings addressed (all 10):**
1. Per-session gate rewritten to order only *misses* against the bound via a synchronous in-flight counter (admit while `misses + inFlight < missBound`); hits run concurrently and one non-settling `provideLocalFormula` can no longer wedge the whole session.
2. Added a pipelined-**burst** regression test (fires `missBound + K` concurrently; asserts exactly one abort and that a valid id after the bound is refused) — reddens on the unserialized body.
3. Rewrote the over-the-wire test to assert **real transport severance** (`connection.isDestroyed` on a held prober session) instead of counting its own wrapper's callback — a bookkeeping-only teardown now fails it.
4. Throwing embedder `abortSession` caught/logged locally, never propagated as an oracle; + test.
5. Changeset rewritten to the honest property (uniform only *below* the bound; crossing severance observable) with the `logger` param, `missBound ≥ 1` throw, and post-abort lockout.
6. `remoteDesignator` qualified as the peer's *claimed*, spoofable-without-`verifyPeerLocation` designator across the README and `makeOcapn` JSDoc (prefer the verified public key).
7. `makeLocatorForSession` factory's declared return widened so its `get` keeps the `string | Uint8Array` secret (was silently erased to `string`).
8. `assertOcapnTarget` → `assertCapability`: capability-only stated as **policy**, not a nonexistent OCapN-exportability constraint.
9. Test binding `endpoint` → `locator`; dropped "endpoint" from the changeset's first sentence.
10. Design citation repointed to `designs/daemon-ocapn-external-connectivity.md` § 2; `endo-peer-entry` framing reconciled (a live well-known swissnum, just not a formula identifier).

**Should-fix also applied:** miss log now names only the error *class* (never the presented secret); loopback-listening endpoint test gated on `netListenAllowed`; typist nits (`…`→`...`, `a`→`an`); one PR summary comment posted acknowledging all three responding pushes.

**Local verification:** 13/13 daemon nonce-locator tests pass (6 unit incl. the two new tests + 7 endpoint), `tsc` clean for both `@endo/daemon` and `@endo/ocapn`, eslint 0 errors, prettier clean.

**CI:** all 28 checks complete, 0 failures, 0 pending, MERGEABLE. (Two intermediate reaper requeues occurred while the long CI queue drained under a transient gh rate-limit; the fix commit was pushed once and never re-applied.)

**Follow-ups:** none required for this stage. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 184 tokens (10284825 cached reads)
- Output: 73018 tokens
- Cost: $17.65077025
- Wall-clock: 4485s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
