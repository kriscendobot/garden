# PR #343 — conduct (merge) the approved @endo/gateway design, then post the next-phase job

**Repo:** `endojs/endo-but-for-bots` (bot direct push; bot identity).
**PR:** https://github.com/endojs/endo-but-for-bots/pull/343 — *design(gateway): overarching
@endo/gateway package integrating the gateway/weblet/Noise cluster* — **APPROVED** by kriskowal
(review 4604609454, 2026-06-30T22:56Z), head `design/gateway-package`, base **`llm`**.

**Maintainer directive (compound — execute BOTH, reliably; not a queued option):**
> Please conduct and post a job for the next phase.

The PR lands the design docs (`designs/gateway-package.md`, `designs/endo-gateway.md`,
`designs/forge-gap-analysis.md`) **plus a `packages/gateway/` skeleton** (index.js, README,
changeset `add-endo-gateway-skeleton`).

**1. Conduct (merge).** Merge the approved #343 into `llm` (conductor role — do NOT name the
merge method; the conductor's canonical norm chooses it). Confirm mergeable / CI green first.

**2. Post the next-phase job.** Read the merged design's **"## Feature Decomposition"** and its
phase markers in `designs/gateway-package.md` to pick the **first implementation increment**:
- Feature 2 — *Virtual hosting (Host header → Weblet formula)* — explicitly **"Phase 1"**.
- Feature 4 — *UDS bootstrap for local CapTP relay registration* — already has concrete exo
  shapes spec'd (`GatewayBootstrap`, `Registration`, `UserDaemon`), so it's implementation-ready.
- Feature 1 phase 1 (payment-token integration); Feature 3 is Phase 3 (defer).

Post a **build job** for the lowest-numbered / readiest phase-1 increment (virtual hosting
and/or the UDS-bootstrap exos), **targeting the `packages/gateway/` skeleton this PR established**,
grounded in the named design section. Deterministic basename (e.g.
`ebfb-endo-gateway-phase-1-<feature>`).

**Report BOTH outcomes:** the merged SHA of #343 and the basename of the posted next-phase job.
Scope: bot fork; no upstream-of-endo contact.
