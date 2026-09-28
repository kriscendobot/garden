---
gate: orchestrated
orchestrated_by: npm-minion-town-dev-registry-orch
priority: normal
role: designer
posted_by: producer
posted_at: 2026-09-28T23:15:22Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a served, npm-protocol-compatible registry proxy deployable at
https://npm.minion.town, for staging `-dev-YYYY-MM-DD` tagged releases of
endojs/endo-but-for-bots packages so they can be installed cross-repo via a
registry override, ahead of any future promotion to production npm.

## Context — read before designing

- Foundation: `designs/endor-npm-registry-proxy.md` on endojs/endo-but-for-bots
  — the CAS-backed npm **consumption** proxy for the `endor` runtime
  (fetch/CAS/MVS/assembly+execute/offline+.npmrc; all 5 phases landed on
  `llm`). Review-side PRs #857/#860/#873/#875/#876/#877/#878 are green and
  draft-by-design, blocked since 2026-08-01 on maintainer ruling
  endojs/endo-but-for-bots#879 (endor's own runtime identity / default
  `exports` condition set for EXECUTING a fetched package inside `endor`).
  Determine explicitly whether #879 blocks THIS design's serving path at all
  — it should not, since #879 is about how `endor run` executes a package,
  not about hosting/serving one to an ordinary `npm`/`yarn` client — and say
  so plainly in the design rather than leaving it ambiguous.
- Related, newer design: `designs/npm-registry-as-directory-tree.md` reframes
  the same registry machinery as a directory-tree capability (root -> npm hub
  -> package -> version -> immutable CAS tree). It explicitly lists npm
  dist-tags as a NON-GOAL for that tree presentation. This new design's
  publish/dist-tag surface is therefore additive to that shape, not in
  conflict with it — read it so the served registry's read path reuses that
  tree rather than duplicating it.
- Deploy target: kriscendobot/minion.town, new subdomain
  https://npm.minion.town. A prior *.minion.town subdomain effort (the
  weblet-gateway increment, PR #23) went CI-green but stalled before going
  live on a namespace/TLS-collision arbitration blocker. Check the CURRENT
  DNS/TLS provisioning mechanism for a new minion.town subdomain before
  assuming a new one is automatic, and design around whatever that mechanism
  actually requires today.

## What the design must specify

1. **Publish path.** Accept `npm publish` (with credentials appropriate to
   the garden's bot identity) against https://npm.minion.town, writing into
   the existing CAS + registry-table machinery, recording an explicit
   dist-tag rather than only a version — e.g.
   `npm publish --tag dev-2026-09-28`. Specify the paired semver scheme: npm
   requires a unique version per publish, so a prerelease identifier such as
   `<version>-dev.<date>` is the natural fit — pick and justify one.
2. **Serve path.** Serve `npm install`/`yarn install` against
   https://npm.minion.town via the ordinary npm registry HTTP protocol
   (package metadata + dist-tags + tarball GET), resolving a package's full
   transitive dependency graph from the same store. This is the piece the
   existing client-side (endor-consumption) design does not need, because the
   consumer being validated here is a real `npm`/`yarn` client, not `endor`.
3. **Non-goals, explicit.** No production-npm promotion mechanics for staged
   `-dev` packages (deferred future work — say so plainly, don't leave it
   silently unaddressed); no change to endor's own runtime identity/exports
   conditions (that stays on #879, untouched by this design).
4. **Repo split.** State plainly which repo(s) carry which pieces. The
   registry-SERVING logic most naturally extends endo-but-for-bots' existing
   `@endo/exo-npm` / registry-table machinery; the minion.town-side deploy
   (hosting, DNS/TLS, process supervision, publish-auth secret) belongs in
   kriscendobot/minion.town. Decide whether this needs one design PR or two,
   and which base each lands on — design PRs land on each project's roadmap
   branch (`llm` for endo-but-for-bots) per
   `skills/pr-creation-flow/SKILL.md` § Designs versus implementations.
5. **Validation shape.** Describe concretely how a later build will prove:
   publishing a handful of real endo-but-for-bots packages under a dated dev
   tag to npm.minion.town, then from a machine/worktree with no prior
   npm.minion.town cache, installing one of those packages plus its full
   transitive dependency tree purely via a registry override pointed at
   npm.minion.town — with no reliance on npm's default registry and no
   reliance on a pre-warmed local cache.

Post this as a normal design job (open draft PR(s) per the repo split above);
the standard design-only-PR gauntlet variant applies to each. This job's
deliverable is the design(s), not the implementation.
