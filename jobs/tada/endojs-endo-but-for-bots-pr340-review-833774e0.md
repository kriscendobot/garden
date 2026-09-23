All checks green where they matter: **22 pass, 5 pending, 0 fail**. The lint leg that had failed now passes, and the daemon test suite (including the new `formatHostPort` tests) passes. The 5 pending are long-running legs (browser-tests, coverage, test262, guile-interop) unrelated to this change. The job is complete.

---

## Completion report — Review directive on endojs/endo-but-for-bots PR #340

**Review:** kriskowal, `CHANGES_REQUESTED` (id 4951338822), 6 inline comments on `packages/daemon/src/networks/ocapn.js`. The preflight returned PROCEED (no prior peer resolution). I addressed the whole review — all 6 items — with code changes plus cited replies, and drove the affected CI legs green.

**Pushed to PR head `claude/endo-daemon-ocapn-FkmHO`** (3 commits, HEAD `b24aaee614`):

1. **Swissnum-for-bootstrap (comment 1) — verified & corrected.** The reviewer is right: OCapN's bootstrap is the implicit first export at **position 0**, reached via `session.getBootstrap()` with no swissnum; the spec provides none. In `@endo/ocapn` that position-0 object is protocol-fixed (`makeBootstrapObject`: `fetch`/`deposit-gift`/`withdraw-gift`), so application objects are reached *through* it by a swissnum (`makeSturdyRef`/`enlivenSturdyRef`). Our object was mislabeled "the bootstrap" — renamed `EndoOcapnBootstrap`/`BOOTSTRAP_SWISSNUM` → `EndoPeerEntry`/`PEER_ENTRY_SWISSNUM` (`'endo-peer-entry'`) and rewrote the module docs with citations.
2. **`@endo/bytes` (comment 2).** Replaced the local `TextEncoder`/`concatBytes` helpers with `bytesFromText` + `concatBytes` from `@endo/bytes` (the repo has no `@endo/utf8`; the utf8 encode lives in `@endo/bytes/from-string.js`, the existing daemon idiom).
3. **Bootstrap shape (comment 3) — explained** in a reply and via the rename: the conventional CapTP daemon bootstrap *is* the greeter; the conventional OCapN bootstrap is the position-0 `fetch`/gift surface; ours is neither (an app entry-point carrying the agent-binding attestation).
4. **`formatHostPort` via URL (comment 4).** Empirically found URL *cannot construct* the authority (the `hostname` setter silently drops bare IPv6 literals); documented why, and instead drove *validation* through URL (round-trip check → meaningful errors on invalid host/port). **Exported it** and added round-trip + failure-mode tests. Also fixed a latent bug this surfaced: `URL.hostname` returns IPv6 bracketed, so I strip brackets at both host-read sites to avoid double-bracketing.
5. **Peer auth at network layer (comment 5) — design reply.** The Noise layer already authenticates the peer key (`exchangeIdentity`, exposed as `remoteLocation`/`remotePublicKeyBytes` → `peer.publicKey`); the deliberate gap is that the persistent agent identity is kept off the ephemeral Noise key (`@keypair` discipline), which the `getAgentBinding` attestation bridges. I laid out options (a) keep attestation w/ docs vs (b) a follow-up threading the peer id up from ocapn-noise, and left the direction to the maintainer rather than refactoring two packages unilaterally.
6. **Factor out closure (comment 6).** Moved `supports` to module scope (it captured no lexical names).

**Replies:** posted one reply per comment (ids 3796600405, …607, …842, 3796601038, …242, …419).

**Verification:** prettier + syntax verified locally (full install/eslint/tsc/ava were unrunnable here — native-toolchain gap then an EMLINK hardlink error, an environment limit). CI is authoritative: **lint pass, test pass, 0 failures** on `b24aaee614` (the previously-failing lint leg recovered after the prettier fix); remaining legs are long-running and unrelated.

**Follow-up owned by maintainer:** comment 5's (a)/(b) direction — I offered to open the ocapn-noise peer-id follow-up if they pick (b).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr340-review-833774e0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 168 tokens (11293644 cached reads)
- Output: 79679 tokens
- Cost: $10.075832750000005 (2 engagement(s) unpriced)
- Wall-clock: 1927s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
