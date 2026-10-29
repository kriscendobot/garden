---
posted_at: 2026-10-29T03:19:37Z
role: designer
arc: minion-town-ui
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town (design lands as `designs/clip-governor-column.md`). Maintainer direction from a live liaison session (kriskowal, 2026-10-29); the vision is saved in the liaison's memory `minion-town-chrome-vision`.

# Design the smallest increment: a governor column to the left of a clip

Context. minion.town is the online Familiar: a chrome (the unforgeable powerbox boundary, `designs/clip-shell-framework.md` § 4, PR https://github.com/kriscendobot/minion.town/pull/179) around confined clips. The maintainer wants a Niri/Miller-columns layout in which windows fold out left to right with graduated trust, and **a clip governs the clip to its right**. A fresh agent must hold no express or implicit authority over the user's powerbox; subagents are created with limited powers delegated explicitly, as one attaches a file to a chat message. A self-modifying clip cannot police itself, so the surface that shows and governs its powers must live outside what the agent can edit. Inference config is user-level (set once, applies to all future clips); a clip only ever holds an attenuated "may ask the model" capability, never the key.

Scope: **increment 1 only.** Specify the smallest change from today's shell (one 56px gutter, one main iframe) that delivers the governor model:
1. A two-column layout for an agent-bearing or New Clip: chrome-owned **governor column** at left, the **governed clip** at right. Include the responsive rule (the shell's shorter-axis rule, § 5 of the shell framework) and how it degrades to one column on mobile.
2. What the governor column shows, read-only to start: the governed clip's current powers (held pet names/facets), plus one chrome operation, **Clone**. Freeze, grant/revoke, and subagent columns are explicitly later increments; say where each would attach so this one does not foreclose them.
3. The trust invariant: the governor column is rendered by the chrome, not by any clip; the governed clip cannot read, cover, or restyle it. Reuse the unforgeable-chrome arguments of shell § 4 rather than restating them.
4. The title-spoofing hazard: gutter names come from the clip's own `<title>` (PR #179), so a self-modifying clip can name itself "Settings". Propose the minimal mitigation (for example chrome-owned labels for chrome surfaces and a visible untrusted-name marker).
5. Reconcile with https://github.com/kriscendobot/minion.town/pull/228 (agent chat Clip design): its open question 2 (one chat Clip per owner or per agent) and 3 (attachments) are answered by this model in the maintainer's framing: per-agent clips each with its own nonce locator (keeps #88's no-ambient-`back` rule), and attachment-as-delegation is the grant gesture (a later increment). State the proposed answers and what #228 / the parked Phase 4 job `claude-api-p4-agent-factory` should change; do not edit those.
6. Name the first builder-sized slice and its tests (Chromium rendered-DOM coverage per `skills/minion-town-clip-browser-testing`-style recipe), as the design's build plan.

Out of scope: freeze, grant/revoke UI, subagent spawning, the primer, pet icons, federation. List them as deferred increments in order.

Open questions the maintainer must decide (put these in `## Open questions`; this makes the design a review PR per the garden carve-out, mark the PR body with `<!-- garden-design-open-questions -->`): (a) is the New Clip itself the governor of an agent in a child column, or does the chrome always render a governor beside any agent-bearing clip (the liaison leans to the former); (b) may a governor read its child's mail or only grant/revoke; (c) is "persona bounded to the clip" a data boundary (conversation history held by the governor).

Do not use GitHub to talk to other instances (garden instances use the message bus). Spec only: no live change.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-29T03:19:49Z
