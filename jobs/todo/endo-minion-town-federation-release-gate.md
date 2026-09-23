---
role: gardener
tier: mentor
handler-timeout: 12600
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-23T22:40:04Z cleared=none -->

---
role: gardener
tier: mentor
handler-timeout: 12600
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-23T22:37:08Z cleared=none -->

---
role: gardener
tier: mentor
handler-timeout: 12600
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-23T22:31:05Z cleared=none -->

---
role: gardener
tier: mentor
handler-timeout: 12600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-09-23T21:37:04Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 12600

# Gate: reviewed and deployable federation release

Predecessors: endo-minion-town-federation-endo-build and endo-minion-town-federation-town-build. Read both reports and plan PR #1332. This gate owns the review-to-deployment gap: producer completion does not authorize an unreviewed release.

Build an explicit matrix of REQUIRED plan/design/implementation PRs and exact dependencies. Check current maintainer review, gauntlet evidence, CI, draft state, merge state, and resulting commit containment; closed-unmerged is not success. Do not require unrelated #688/#693/#990 merely because the ledger named them; adopt their relevant tests if needed, and explain actual dependencies. For every missing review/merge, request the specific manual action via liaison and use block-job.sh on the next concrete PR; return without completing. Never trigger an unrequested gauntlet or un-draft to accelerate. If the approved design requires revision, send the exact work to its owner or post a named corrective successor, keeping deployment held.

When all required Endo work is reviewed/landed, reconcile minion.town's candidate pins to the merged source, repeat package compatibility gates, and get any required town review/landing through existing conventions. Account for main auto-deploy before merging/pushing activation: coordinate the following deployment owner and inspect whether a merge itself already triggered the approved SSM deploy path. Do not issue a merge merely because a PR is non-draft; use the existing authorization/conductor discipline.

Pass ONLY with a durable release manifest: approved/merged PR URLs, exact Endo and town SHAs, CI evidence, state-schema/native-dependency compatibility evidence against the currently deployed f665050 lineage, deploy and rollback commands, and an available live validation account/browser access plan (no credentials in manifest). A safe copy/staging database check must not destroy or modify live account state. Explicitly cover minion.town #111's prior registry startup regression and the fix on current llm (#1329), rather than assuming latest is safe. Commit/publish this non-secret manifest in minion.town documentation or a journal result. Then and only then complete successfully to release deployment.

## Mandate and shared contract

Parent: endo-minion-town-guest-locator-federation-supervisor, maintainer directive 2026-09-23. Campaign: endo-minion-town-guest-locator-federation. Read the integration plan and dated roadmap priority note in Endo draft PR https://github.com/endojs/endo-but-for-bots/pull/1332 (design/minion-town-guest-locator-federation, initial ec51cecdcf, frozen llm-f9cbcfc), designs/daemon-locator-reference.md and designs/README.md. The acceptance criterion is: a real user browses/authenticates on minion.town, obtains their own guest formula's suitable locator, and adopts it with the endo CLI on a separate local daemon over a mutually supported CapTP/OCapN route. Start with the guest, not arbitrary object export. This overrides M3's 2026-09-03 client-side bridge first priority; it does not authorize marking all M4 complete.

Read roles/gardener/AGENT.md and the applicable role, project AGENTS.md, journal/projects/endo-but-for-bots/README.md and journal/projects/minion-town/README.md. Obtain each project checkout with ensure-project-worktree.sh YOUR-CHILD-BASE owner/repo branch. Never share a checkout with a sibling. Read predecessor reports in jobs/tada/ (or use fresh journal2 through your garden job checkout if the deployed journal is stale). Drain your own inbox. Open/adopt PRs only through ensure-pr.sh YOUR-CHILD-BASE, with pinned bases where required.

Endo producers stop at DRAFT PRs; do not un-draft, automatically stage a gauntlet, merge unreviewed work, or bypass the manual-gauntlet-trigger regime. Minion.town designs require PR review. Its main branch has deployment automation: changes that activate unreviewed dependencies must remain on a review branch. Use the existing idempotent deploy/aws/scripts/* and SSM path for production. No new deploy channel, no production state deletion, no bearer locators/IDs or credentials in committed evidence/logs. Generic reusable mechanism belongs in Endo; minion.town owns account policy/configuration/deployment.

Review/approval prerequisites are not implicit in predecessor completion: a build report may only mean a draft exists. When you are genuinely blocked on a concrete PR, call /home/kris/garden/scripts/jobs/block-job.sh YOUR-CHILD-BASE PR-URL with a self-contained resume body, notify the liaison of the exact required manual action, and return WITHOUT a completion signal. Recheck merged versus merely closed on resume. Do not repeatedly poll or spend a claim waiting. If a genuine terminal attempt fails this child's gated outcome, emit <<<GARDEN-ORCHESTRATION-FAILED>>> immediately before <<<GARDEN-JOB-COMPLETE>>>; never put the parsed failure field into prose. A successor handoff is not evidence that this stage's acceptance passed.

## Source evidence to recheck

Initial Endo llm f9cbcfc426: #340 merged 2026-08-25; #684 (efcc498729), #688 (884afffb79), #693 (c25fe20a3d), #990 (86d91b3762) are open drafts as of 2026-09-23. #1124 is an open draft at 96674df196 on kriscendobot/endo-but-for-bots:build/ocapn-nonce-locator-mechanism; it adds makeFormulaNonceLocator plus makeLocatorForSession, absent from llm. The cited designs/ocapn-nonce-locator.md does NOT exist; actual design is daemon-ocapn-external-connectivity.md section 2. Formula-only adapter refuses endo-peer-entry; composition or a separate endpoint is necessary to preserve peer protocol. Its session hook, not only shared get, enforces incoming miss bounds.

Initial minion.town main 3062124: guest-self-endpoint.ts and landing/shell copy UI expose raw /account/guest-formula-id with no-store and authenticated self-only iss+sub derivation. guest-control.ts provisions then identifyGuest; no complete external locator is returned. Caddy routes /.well-known/ocapn-cbor-np to 8931, documented as a separate demo container, whereas accounts use /run/endo-daemon/endo.sock. Do not assume these share formulas. deploy-endo-daemon.sh and captp-client.ts pins are f66505034aaa54ac46294347b2bf0e14655b088a; #111 rolled back 89481580 for a persisted-DB startup failure. Check actual box topology/revision through read-only SSM before planning an upgrade. A bare 426/101 response proves no guest redemption.
