---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Build the app-shell framework the maintainer specced live in a liaison session on 2026-09-03 (verbatim intent below). This repo currently has no rich frontend to extend — the only existing web-facing assets are `deploy/aws/www/{index.html,connect.html}` and the oauth2-proxy templates — so this is greenfield app-shell work, not a refactor.

## Borrow extensively from @endo/chat

The interface this is headed toward resembles the Endo Chat application (`endojs/endo-but-for-bots` @ `llm`, `packages/chat/`), but generalized: minion.town is not limited to Chat/Inventory views. Read and reuse its patterns before inventing your own:
- `packages/chat/chat-chrome.js`, `channel-list.js`, `add-space-modal.js` — the existing chrome/gutter/space-creation components.
- `designs/chat-spaces-gutter.md` — the precedent for exactly this repo's left column: a persistent, orderable "spaces" gutter (48px, `--gutter-width`), each space a bookmark/pet-store value, one-click switch between top-level navigation targets. Borrow the gutter concept and its component style (template-literal HTML/CSS, factory functions returning API objects, direct DOM manipulation, JSDoc types) rather than pulling in a framework.
- `designs/chat-spaces-home.md`, `designs/chat-inventory-create-menu.md` — related precedent for the add-space / create-menu affordance.

Translate "space" → "clip" throughout: each entry in minion.town's left column is one of the user's clips, not a pet-store bookmark into the Chat/Host graph.

## The shell

- **Left column ("gutter"):** lists the user's clips. A **`+` add button** creates a new clip and adds it to the user's list. The new clip is backed by **the guest's own powers** (wire it through the existing publish/guest-control path — `src/endo/gateway/publish.ts`, `src/endo/guest-control.ts` — the same guest-scoped authority the rest of the gateway already uses; do not invent a parallel authority model). The clip must describe itself well enough that an agent could connect over MCP, or a client over OCapN, to evolve it later — for THIS job, a placeholder clip (a stub `front`/`back` pair, or an inert placeholder page) is enough; do not build out real clip-authoring tooling or content here. Call this deferred scope out explicitly in the PR body.
- **Main pane:** an `<iframe>` showing the selected clip, sourced from its `*.ocap.site` origin (per `designs/clip-ocap-synthesis.md`'s identity model — each clip's origin is its own formula-id-keyed capability URL).
- **Bottom-left settings/authentication button:** the single entry point for everything currently classed as high-permission "chrome" in the security-UX sense. Clicking it reveals what minion.town shows today, consolidated: login/logout, account information, credits/payment (Stripe — `src/billing/*`), and the rest of settings (`src/auth/*`). Nothing in this dialog set is new functionality; it is today's scattered surfaces gathered behind one deliberate entry point.

## The chrome must be credibly unforgeable by iframe content

The settings/auth dialog has to communicate, unmistakably, that it comes from the high-permission left column and not from a confined clip. Implement it as an overlay painted in the **top-level document**, above the iframe's stacking context (so a sandboxed, cross-origin clip literally cannot paint over or into it), with a **speech-bubble treatment that visually expands from the bottom-left corner button** — anchored and animated from that specific screen region as a consistent, recognizable visual language for "this is genuinely privileged chrome," not an incidental modal style. State in the PR body exactly why this is unspoofable (the iframe cannot paint outside its own box; anchoring/animating from a chrome-owned corner the iframe's box never reaches is what makes the signal credible) and what CSS/DOM technique you used to guarantee the layering (stacking context, containment, whatever you chose).

## Responsive: axis-based layout selection

On mobile, the gutter of clips runs along the **bottom** instead of the left, and scrolls **horizontally** instead of vertically. Select which layout applies by comparing the viewport's own **width vs. height — whichever is the shorter axis** — rather than a fixed pixel breakpoint, so the layout follows orientation/aspect ratio directly. Document the exact comparison you implement (e.g. a `resize`-aware check or a CSS technique) and its rationale in the PR body.

## Theming

Automatic light/dark mode is preserved **implicitly** — no manual toggle for this pass. Use `prefers-color-scheme` / `color-scheme: light dark` consistently across the gutter, the main pane wrapper, and the chrome overlay.

## Deploy the draft for interactive review

This repo's deploys are SSM-driven (`DEPLOYMENT.md`) directly onto the live box. Land this build so the maintainer can interact with it live **without disrupting today's production login-gated flow for other users** — a distinct path, subdomain, or a feature-flagged route reachable only when opted into (your call which; document it). Report the exact reachable URL, and how to opt in if you gated it, in the PR body and in your completion report. This is a draft for interactive review, not a replacement of the current default experience — do not remove or hide any existing route.

## Design record

This is a foundational architecture decision for the repo, and the project convention is that new design docs land as PR review (`journal/projects/minion-town/README.md` § Rules of engagement, kriskowal directive 2026-07-10). Write a short `designs/<slug>.md` (repo header-block convention, mermaid not ASCII) capturing the shell architecture above — the clip-gutter model, the iframe/ocap.site boundary, the unforgeable-chrome property and why it holds, the axis-based responsive rule. Land it alongside this implementation in the same PR, or open it first as its own PR if you judge the decision substantial enough to want dedicated review before the build proceeds — your call; state which you chose and why in the report.

## Scope boundary

Out of scope for this job: real clip-authoring tooling, the MCP/OCapN self-description implementation for a live (non-placeholder) clip, any view beyond the shell itself. Flag these as named follow-ups in the completion report rather than attempting them here.

Deliver as a draft PR on the fork and run the gauntlet per the usual build flow.

<!-- garden-reaped: 0 -->

<!-- garden-productive-cycle -->
<!-- garden-transient-elapsed: kind=exit0 through=0 values=489 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T07:27:09Z
