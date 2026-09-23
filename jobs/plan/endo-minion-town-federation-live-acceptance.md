---
gate: orchestrated
orchestrated_by: endo-minion-town-guest-locator-federation
priority: high
roadmap: endo M4 guest-locator federation
posted_by: orchestrator
posted_at: 2026-09-23T20:54:21Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 12600

# Real-account browser and endo CLI federation acceptance

Predecessor: endo-minion-town-federation-deploy. Read deployment attestations and the release manifest. This is the final production acceptance gate, not a mocked demo and not code review.

Use an authorized real minion.town account and an actual browser session. Browse to minion.town and complete its real authentication flow; observe the rendered locator/copy surface for that account's own guest. If interactive identity-provider login requires the human, request participation through message-user.sh YOUR-CHILD-BASE and keep this gate incomplete; never substitute an injected header/test identity for the browser step. Do not print or commit the bearer, cookies, tokens, or passwords.

From a distinct local Endo daemon on another host, use the released endo CLI command to adopt the copied locator, with no custom bridge script/manual wire JSON. Invoke the real remote guest, perform a benign reversible test-object round trip scoped to that account, and verify the result through the same account's remote surface. Clean up only the test object you created. Observe the actual selected network/codec layers and authenticated identity; test reconnect and local daemon restart/re-acquisition, malformed/unknown locator and wrong-peer identity rejection, and unsupported-first-hint fallback where supported. Ensure this is the account guest daemon, not the old demo container. Do not restart all production guests merely to manufacture evidence; any remote restart follows the deployment runbook.

Commit a redacted reproducible runbook/evidence report under minion.town docs (or the existing deployment evidence convention): browser observations, exact CLI commands with secret placeholders, timestamps, both source revisions and actual running pins, selected layers, method results and failure-case observations. Update deployment status from evidence. If warranted, propose a narrow Endo ledger status update via draft PR; do not mark the whole M4 milestone complete while its broader exit work remains.

Pass only when all three maintainer acceptance steps actually succeeded. If any fails, retain concrete diagnosis and durable corrective successor work, emit the orchestration failure signal for a terminal failed attempt, and leave the campaign's acceptance explicitly NOT VERIFIED. No partial/mock success or completed-successor inference may satisfy this gate.

## Mandate and shared contract

Parent: endo-minion-town-guest-locator-federation-supervisor, maintainer directive 2026-09-23. Campaign: endo-minion-town-guest-locator-federation. Read the integration plan and dated roadmap priority note in Endo draft PR https://github.com/endojs/endo-but-for-bots/pull/1332 (design/minion-town-guest-locator-federation, initial ec51cecdcf, frozen llm-f9cbcfc), designs/daemon-locator-reference.md and designs/README.md. The acceptance criterion is: a real user browses/authenticates on minion.town, obtains their own guest formula's suitable locator, and adopts it with the endo CLI on a separate local daemon over a mutually supported CapTP/OCapN route. Start with the guest, not arbitrary object export. This overrides M3's 2026-09-03 client-side bridge first priority; it does not authorize marking all M4 complete.

Read roles/gardener/AGENT.md and the applicable role, project AGENTS.md, journal/projects/endo-but-for-bots/README.md and journal/projects/minion-town/README.md. Obtain each project checkout with ensure-project-worktree.sh YOUR-CHILD-BASE owner/repo branch. Never share a checkout with a sibling. Read predecessor reports in jobs/tada/ (or use fresh journal2 through your garden job checkout if the deployed journal is stale). Drain your own inbox. Open/adopt PRs only through ensure-pr.sh YOUR-CHILD-BASE, with pinned bases where required.

Endo producers stop at DRAFT PRs; do not un-draft, automatically stage a gauntlet, merge unreviewed work, or bypass the manual-gauntlet-trigger regime. Minion.town designs require PR review. Its main branch has deployment automation: changes that activate unreviewed dependencies must remain on a review branch. Use the existing idempotent deploy/aws/scripts/* and SSM path for production. No new deploy channel, no production state deletion, no bearer locators/IDs or credentials in committed evidence/logs. Generic reusable mechanism belongs in Endo; minion.town owns account policy/configuration/deployment.

Review/approval prerequisites are not implicit in predecessor completion: a build report may only mean a draft exists. When you are genuinely blocked on a concrete PR, call /home/kris/garden/scripts/jobs/block-job.sh YOUR-CHILD-BASE PR-URL with a self-contained resume body, notify the liaison of the exact required manual action, and return WITHOUT a completion signal. Recheck merged versus merely closed on resume. Do not repeatedly poll or spend a claim waiting. If a genuine terminal attempt fails this child's gated outcome, emit <<<GARDEN-ORCHESTRATION-FAILED>>> immediately before <<<GARDEN-JOB-COMPLETE>>>; never put the parsed failure field into prose. A successor handoff is not evidence that this stage's acceptance passed.

## Source evidence to recheck

Initial Endo llm f9cbcfc426: #340 merged 2026-08-25; #684 (efcc498729), #688 (884afffb79), #693 (c25fe20a3d), #990 (86d91b3762) are open drafts as of 2026-09-23. #1124 is an open draft at 96674df196 on kriscendobot/endo-but-for-bots:build/ocapn-nonce-locator-mechanism; it adds makeFormulaNonceLocator plus makeLocatorForSession, absent from llm. The cited designs/ocapn-nonce-locator.md does NOT exist; actual design is daemon-ocapn-external-connectivity.md section 2. Formula-only adapter refuses endo-peer-entry; composition or a separate endpoint is necessary to preserve peer protocol. Its session hook, not only shared get, enforces incoming miss bounds.

Initial minion.town main 3062124: guest-self-endpoint.ts and landing/shell copy UI expose raw /account/guest-formula-id with no-store and authenticated self-only iss+sub derivation. guest-control.ts provisions then identifyGuest; no complete external locator is returned. Caddy routes /.well-known/ocapn-cbor-np to 8931, documented as a separate demo container, whereas accounts use /run/endo-daemon/endo.sock. Do not assume these share formulas. deploy-endo-daemon.sh and captp-client.ts pins are f66505034aaa54ac46294347b2bf0e14655b088a; #111 rolled back 89481580 for a persisted-DB startup failure. Check actual box topology/revision through read-only SSM before planning an upgrade. A bare 426/101 response proves no guest redemption.
