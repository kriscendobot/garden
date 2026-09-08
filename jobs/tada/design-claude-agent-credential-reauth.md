Done. The design is delivered as draft PR #96.

## Completion report

**Job:** `design-claude-agent-credential-reauth` (designer role) — arc kriscendobot/garden#89 item 3.

**What I did:** Wrote `designs/claude-agent-credential-reauth.md` on `kriscendobot/minion.town` and opened it as **draft PR #96** against `main` (single-file diff, 339 additions, `ADDED` — verified via `gh pr view 96 --json`). Left it draft so the completion machinery stages the design-panel gauntlet.

**The design** turns the base `claude-agents-capability.md` decision (unplanned expiry passively "drops to `needs-auth`") into an active push, so a running Claude agent's credential loss is no longer a silent stall. It builds on the existing `needs-auth` sentinel rather than inventing a parallel signal, covering every required point:

- **Detection** — a classifier over the `infer` outcome with four disjoint classes; reauth fires **only** for credential-invalid, never for a rate limit (429), a spent usage window, a transient fault, or a bad model. Adds one new sentinel, `usage-exhausted`, to split "credential valid but out of budget" from "credential bad" (the one place the base design's single tag conflated them). Notes how subscription tokens (time-expiring, expected) and metered API keys (revoke/rotate/spend-cap, unexpected) differ.
- **Designated operator** — an indelible `@operator` send-capable handle every guest holds, established at provisioning, inherited by a whole descendant tree from the root subscription owner (forced, because only that principal can complete a reauth), reassignable only above the agent, with a `security@minion.town`-shaped admin fallback when the operator is gone.
- **The reauth capability** — a `ReauthTicket` exo (`begin()`/`status()` only), minted host-side by the per-`iss+sub` concierge (not by the confined agent, which only calls a safe new `requestReauth()`), single-use, 10-minute-expiring, carrying no secret. Argues why an interceptor gains only an inert pointer to a transaction they cannot finish (parallel to ocap-mailboxes' router-facing-string-not-bearer-reference argument).
- **Transport** — reuses `ocap-mailboxes.md`: a capability edge in-daemon, degrading to the base design's single-use account-page URL via the SES adapter for external-email operators.
- **Behavior while unauthenticated** — park-not-reject: triggering work left undismissed in the durable mailbox, inbox still drained for non-inference messages, one deduped escalation, resume on the next live-revalidated `infer`; honors the never-reject contract and loses no message.
- **Generic vs minion.town split** — classifier + operator-escalation pattern + park loop grow in `@endo/*`; HTTPS account page, Cognito `iss+sub` pinning, and the SES projection stay minion.town-side.

Four open questions (delegated operators, first-class `usage-exhausted` handling, pre-expiry advisories, browser-only-operator reach) are left explicit for maintainer decision.

**Evidence I ran:** the sole mermaid sequence diagram parses (`mermaid.parse` → `OK sequence`); style greps found no em-dashes, forbidden code points, or Latin shorthand; PR confirmed draft with the design as its only diff. This is a design (no build), so no runtime behavior is claimed verified.

**Self-improvement:** landed a one-line note on `skills/mermaid-validation/SKILL.md` (pushed to `main2`, `ed2f231cfd`) — inside a `sequenceDiagram`, an ASCII `->` in a message's text is lexed as an arrow and fails the parse, which bit me carrying a prose arrow into a diagram label.

**Follow-ups:** none blocking; PR #96 awaits its auto-staged design panel and maintainer review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-claude-agent-credential-reauth.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (3385134 cached reads)
- Output: 32919 tokens
- Cost: $3.8083650000000007
- Wall-clock: 525s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
