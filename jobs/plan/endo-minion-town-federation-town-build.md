---
gate: orchestrated
orchestrated_by: endo-minion-town-guest-locator-federation
priority: high
roadmap: endo M4 guest-locator federation
posted_by: orchestrator
posted_at: 2026-09-23T20:53:38Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 12600

# Minion Town account guest locator and deployment wiring

Predecessor: endo-minion-town-federation-endo-build. Read its actual report and candidate interfaces. Deliver reviewable minion.town changes consuming those interfaces, with no live activation. Verify the live service/socket/port topology through read-only SSM, excluding secret EnvironmentFiles and raw account data from output; reconcile it with the source before writing wiring. Read designs/mcp-endo-guest.md and existing gate evidence: do not repeat the Claude/MCP provisioning project or claim its old gates passed merely from code.

Extend the authenticated self-scoped reveal and copy UI to give a complete Endo locator for the current account guest, compatible with the predecessor CLI. Preserve existing raw identifier clients if necessary. Derive identity/type/routes from daemon/public configuration, not arbitrary caller parameters, and do not trust caller-selected guest IDs. Keep no-store, gate-secret, verified iss+sub, admission and suspended-account tests. Do not promise OAuth logout revokes an already-issued bearer. Show usable CLI instructions that avoid putting the secret in URL query strings or shell history.

Wire the public formula-fetch endpoint to the account daemon's actual formula graph using Endo's reusable mechanism and authenticated peer identity. Never demonstrate against the unrelated demo container and label it account federation. Advertise only truly served dialects; CBOR+Noise+WSS is first, Syrup/native CapTP optional when supported. Preserve demo/existing peer lanes and bounded incoming lookup; do not expose host bootstrap or foreign-node relay authority.

Prepare changes to deploy/aws/scripts/*, Caddy/systemd, and synchronized daemon/client pins, with upgrade and rollback preflight. Production pin selection must ultimately name MERGED reviewed Endo commits, not draft SHA artifacts. Because main has auto-deploy, keep activation changes on a branch/draft PR for the release-readiness gate even though routine build/config direct commits may otherwise be permitted. Any minion.town design amendment also lands by PR review, never bare main.

Test reveal authentication/isolation/no-store, actual compatible locator generation, endpoint wiring against a real local daemon, and browser copy rendering. Record exact deployment sequence/rollback, candidate pins, PRs, tests, and inherited prerequisites. Do not deploy. Stage completes at reviewable candidate artifacts with local evidence.

## Mandate and shared contract

Parent: endo-minion-town-guest-locator-federation-supervisor, maintainer directive 2026-09-23. Campaign: endo-minion-town-guest-locator-federation. Read the integration plan and dated roadmap priority note in Endo draft PR https://github.com/endojs/endo-but-for-bots/pull/1332 (design/minion-town-guest-locator-federation, initial ec51cecdcf, frozen llm-f9cbcfc), designs/daemon-locator-reference.md and designs/README.md. The acceptance criterion is: a real user browses/authenticates on minion.town, obtains their own guest formula's suitable locator, and adopts it with the endo CLI on a separate local daemon over a mutually supported CapTP/OCapN route. Start with the guest, not arbitrary object export. This overrides M3's 2026-09-03 client-side bridge first priority; it does not authorize marking all M4 complete.

Read roles/gardener/AGENT.md and the applicable role, project AGENTS.md, journal/projects/endo-but-for-bots/README.md and journal/projects/minion-town/README.md. Obtain each project checkout with ensure-project-worktree.sh YOUR-CHILD-BASE owner/repo branch. Never share a checkout with a sibling. Read predecessor reports in jobs/tada/ (or use fresh journal2 through your garden job checkout if the deployed journal is stale). Drain your own inbox. Open/adopt PRs only through ensure-pr.sh YOUR-CHILD-BASE, with pinned bases where required.

Endo producers stop at DRAFT PRs; do not un-draft, automatically stage a gauntlet, merge unreviewed work, or bypass the manual-gauntlet-trigger regime. Minion.town designs require PR review. Its main branch has deployment automation: changes that activate unreviewed dependencies must remain on a review branch. Use the existing idempotent deploy/aws/scripts/* and SSM path for production. No new deploy channel, no production state deletion, no bearer locators/IDs or credentials in committed evidence/logs. Generic reusable mechanism belongs in Endo; minion.town owns account policy/configuration/deployment.

Review/approval prerequisites are not implicit in predecessor completion: a build report may only mean a draft exists. When you are genuinely blocked on a concrete PR, call /home/kris/garden/scripts/jobs/block-job.sh YOUR-CHILD-BASE PR-URL with a self-contained resume body, notify the liaison of the exact required manual action, and return WITHOUT a completion signal. Recheck merged versus merely closed on resume. Do not repeatedly poll or spend a claim waiting. If a genuine terminal attempt fails this child's gated outcome, emit <<<GARDEN-ORCHESTRATION-FAILED>>> immediately before <<<GARDEN-JOB-COMPLETE>>>; never put the parsed failure field into prose. A successor handoff is not evidence that this stage's acceptance passed.

## Source evidence to recheck

Initial Endo llm f9cbcfc426: #340 merged 2026-08-25; #684 (efcc498729), #688 (884afffb79), #693 (c25fe20a3d), #990 (86d91b3762) are open drafts as of 2026-09-23. #1124 is an open draft at 96674df196 on kriscendobot/endo-but-for-bots:build/ocapn-nonce-locator-mechanism; it adds makeFormulaNonceLocator plus makeLocatorForSession, absent from llm. The cited designs/ocapn-nonce-locator.md does NOT exist; actual design is daemon-ocapn-external-connectivity.md section 2. Formula-only adapter refuses endo-peer-entry; composition or a separate endpoint is necessary to preserve peer protocol. Its session hook, not only shared get, enforces incoming miss bounds.

Initial minion.town main 3062124: guest-self-endpoint.ts and landing/shell copy UI expose raw /account/guest-formula-id with no-store and authenticated self-only iss+sub derivation. guest-control.ts provisions then identifyGuest; no complete external locator is returned. Caddy routes /.well-known/ocapn-cbor-np to 8931, documented as a separate demo container, whereas accounts use /run/endo-daemon/endo.sock. Do not assume these share formulas. deploy-endo-daemon.sh and captp-client.ts pins are f66505034aaa54ac46294347b2bf0e14655b088a; #111 rolled back 89481580 for a persisted-DB startup failure. Check actual box topology/revision through read-only SSM before planning an upgrade. A bare 426/101 response proves no guest redemption.
