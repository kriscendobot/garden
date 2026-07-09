Run the gauntlet on endojs/endo-but-for-bots#621 (base `llm`).

https://github.com/endojs/endo-but-for-bots/pull/621

PR #621 (`design: refine endoclaw-oauth as the connector credential foundation`,
branch `design/endoclaw-oauth-foundation`) refines `designs/endoclaw-oauth.md`.
It is the **design gate** for the `@endo/exo-google-sheets` connector tree
(design #612, merged): the two new packages `@endo/google-sheets` and
`@endo/exo-google-sheets` ride the `OAuth` exo this design specifies, over the
already-merged `endoclaw-network-fetch` substrate (`@endo/http-confine` +
`@endo/exo-http-client`, PR #566). The OAuth exo has no implementation yet;
landing this refined foundation design unblocks building it.

State at post: DRAFT, CI all green (build/lint/test/browser-tests/zizmor SUCCESS),
no reviews yet. The design settles the deferred first-mint flow (#612 Resolved
Question 5): authorization-code + PKCE against a loopback redirect, device-code
fallback. Two remaining Open Questions (remote headless redirect; who registers
the OAuth client) are explicitly deferred with recommended v1 defaults
(gateway route deferred to M5; per-host client registration) and do NOT block
this design landing — do not reopen them.

Task: resume the pr-creation-flow chain (clean -> panel review -> fix-loop ->
un-draft) and drive #621 to a mergeable, un-drafted state in the maintainer's
review queue. This is a DESIGN PR (docs only) — the panel reviews the design's
soundness/completeness as a build foundation, not code. Read-only on upstream
otherwise; standard bot-identity push to the PR head branch.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 11
  claimed_at: 2026-07-09T18:52:45Z
