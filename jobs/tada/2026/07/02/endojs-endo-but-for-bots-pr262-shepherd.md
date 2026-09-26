Inbox empty. The picture is fully confirmed: `interfaces.js` documents GAPs #4/#2/#7 inline, and the tsc TS2345 at `transports.js:124` is the concrete type-level manifestation of documented **GAP #1** (farContext threading). This is a gap-revealing probe whose red CI is expected-by-design.

I have genuinely finished my diagnosis and reached a hard escalation point (per the shepherd DoD: "CI green OR a hard escalation point surfaced with a clear hand-off"). Writing my report.

---

## Shepherd report — endojs/endo-but-for-bots PR #262

**Live check state re-fetched.** PR #262 is a **DRAFT** titled *"feat(daemon,ocapn): per-agent @transports — gap-revealing prototype of #138 design"*, head `825e1c1ac`, base `design/ocapn-daemon-integration` (#138). Its PR body states plainly: *"This is a gap-revealing skeleton, not a feature build … The gap log below is the deliverable … The PR is intended to stay draft."* This is a **probe** in garden vocabulary — per CLAUDE.md, a probe "opens DRAFT and stays draft (no cleaner / judge / fixer / un-draft chain follows)." The CI-status watcher auto-dispatched this shepherd blind to that posture. All CI runs are from 2026-05-15 (6+ weeks stale; no push since).

**Failure inventory (4 red checks):**

1. **`viable-release (20.x & 24.x)`** — real tsc error, `packages/daemon/src/transports.js(124,58): error TS2345: Argument of type 'undefined' is not assignable to parameter of type 'FarContext'`. Line 124 is `return E(network).connect(locator, /** farContext */ undefined)`. This is **documented GAP #1** (cross-agent loopback / context threading): the network `connect` signature requires `farContext: FarContext` (types.d.ts:920); every real call site in daemon.js constructs `makeFarContext(context)`, but the Transports layer has no `context` to thread — which is exactly the design question the probe exists to surface. Suppressing it with an `/** @type {any} */` cast would *erase the gap the probe documents*, so that is not an appropriate shepherd action.
2. **`test-xs (20.x, 5.0.0)`** — infra flake: `esvu ✖ Some engines were not installed` (the XS/moddable engine download failed after V8 installed cleanly). Not a code issue; clears on re-run.
3. **`lint`** — Prettier style issues in 3 files. Tractable and safe, but cosmetic: fixing it alone cannot turn CI green while viable-release remains red by design, so it does not reach the shepherd's definition of done and would only add churn to a stale draft.

**Disposition — escalate; do not force-green.** This is a gap-revealing probe whose red CI is **expected-by-design**: the tsc failure IS one of the documented deliberate gaps (GAP #1), and test-xs is an operational flake. Resolving the tsc error properly requires the design decision the probe was created to surface (how `FarContext` threads through the Transports layer / the loopback distinguisher) — a **hard escalation point (Impasse: design decision needed)**. I did not push any commit: no green is achievable without either resolving the design gap or suppressing a real type error, and the job body carries no PR-comment authorization.

**`next: liaison`** — surface to the maintainer: PR #262 is a gap-revealing probe intended to stay draft; its red CI is expected (documented GAP #1 tsc error + an esvu infra flake) and should not be driven green by a shepherd/fixer. The maintainer's call is whether to keep it draft-red as the standing gap artifact or close it.

**Follow-up (garden infra, not actioned here to avoid scope-creep):** the CI-status watcher (`garden-ci-watcher@*`) auto-posted this shepherd job blind to the probe posture, and will keep firing on any probe that is intended to stay draft-red. Worth a guard: exempt gap-revealing / intended-to-stay-draft probes from red-CI auto-shepherding (e.g., detect the probe marker in the PR body, or a label), so probes don't perpetually mint shepherd jobs that can only escalate.
