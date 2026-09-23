---
ts: 2026-06-08T05:02:32Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
refs:
  - entries/2026/06/08/045800Z-dispatch-researcher-52156c.md
---

# result: researcher 52156c — `## Library and project references` for npm-`chat`-as-Endo-plugin designer dispatch

## Summary

The proposed downstream is a designer dispatch (amend-or-net-new) to
integrate the npm `chat` package (Vercel's unified bot SDK for Slack /
Teams / Discord / Telegram / Google Chat / GitHub / Linear /
WhatsApp / Telegram / Messenger / Twilio / Web) as a plugin that
bridges Endo agent mailboxes to those external platforms.

**The headline finding**: a Not-Started design already covers this
shape and explicitly names the npm `chat` package as the recommended
foundation: `designs/endoclaw-channel-bridges.md` on the `llm` branch
(183 lines, Kris Kowal prompted, 2026-03-03, parent: `endoclaw.md`).
The designer's amend-vs-new choice therefore reduces to: amend the
existing design with newer learnings (DCP delegate/connector
attenuation; daemon-message-streaming `streamId` envelope extension;
PR #125's linked-list edit-history shape; `@endo/chat` namespace
collision with the npm `chat` import) and promote it from
Not-Started toward Proposed/In-Progress, OR open a sibling design
that supersedes the current one with a narrower scope (e.g.,
`daemon-channel-bridge.md` to live under `daemon/` rather than the
`endoclaw/` umbrella). The library has no concept page for "channel
bridge" yet; the `endoclaw-channel-bridges.md` design itself is
**not yet ingested into the library**, so this refinement is the
first concrete pointer to it.

## Refinement section (for the orchestrator to inline)

```markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sources/endo-but-for-bots--llm-designs-endoclaw.md`](../../library/sources/endo-but-for-bots--llm-designs-endoclaw.md)
  — the parent design; channel bridges is one of seven Related-Designs
  spokes. Confirms the umbrella framing the channel-bridges design
  inherits from.
- [`journal/library/sources/endo-but-for-bots--llm-designs-daemon-capability-persona.md`](../../library/sources/endo-but-for-bots--llm-designs-daemon-capability-persona.md)
  (DCP) — the abstract "service connector" / "delegate" pattern.
  Names connectors as plugins that hold the platform OAuth token
  while the delegate holds only the connector Handle. Anti-
  impersonation by construction: every outbound message carries the
  epithet chain because the *connector* (not the agent) controls
  the platform credential. The npm-`chat`-bridge is a concrete
  instance of this pattern; the design should cite DCP's connector
  vocabulary.
- [`journal/library/sources/endo-but-for-bots--llm-designs-daemon-message-streaming.md`](../../library/sources/endo-but-for-bots--llm-designs-daemon-message-streaming.md)
  — `streamReply` / `StreamWriter` / `StreamReader` + optional
  `streamId` envelope field (PR #287 phase 1 open). The npm `chat`
  SDK has its own streaming primitive (`streamingUpdateIntervalMs`,
  post-then-edit fallback); the bridge must map Endo's CapTP-rides-
  method-calls stream into the SDK's post-and-edit model. Cite when
  the design discusses streaming.
- [`journal/library/sources/endo-but-for-bots--llm-designs-chat-edit-message-ui.md`](../../library/sources/endo-but-for-bots--llm-designs-chat-edit-message-ui.md)
  — chat-side `editMessage` + `messageHistory`. PR #125 (in
  CHANGES_REQUESTED, kriskowal's 2026-06-08T04:47Z review answered
  the fixer's 4 questions) re-shapes message edit-history as a
  linked list via a new `previous` field or a new `message-revision`
  formula type, with persistence-on-`done:true` only and chain-walk
  on `loadMailboxState`. A platform bridge that round-trips edits
  (Slack edit -> Endo edit -> Slack edit-back) inherits this
  structural change; cite PR #125 explicitly so the designer
  decides whether the bridge maps platform edits to the linked-
  list shape or treats edits as new messages.
- [`journal/library/sources/endo-but-for-bots--llm-designs-endopi-extension-package-manifest.md`](../../library/sources/endo-but-for-bots--llm-designs-endopi-extension-package-manifest.md)
  — the Endo guest-plugin shape (`endo install` + bounded
  authority + compartment-mapper-mediated import resolution). The
  channel-bridges design says "the bridge plugin is a standard Endo
  guest module (`make(powers)`)"; cite this for the plugin idiom
  and the contrast with Pi-style ambient-authority extensions.
- [`journal/library/concepts/dehydrate-hydrate.md`](../../library/concepts/dehydrate-hydrate.md)
  — the dehydrate-at-ingestion / hydrate-at-presentation discipline
  for capability references. A bridge that round-trips token chips
  embedded in Endo messages to Slack `@`-mentions (or vice versa)
  is doing the same dehydrate-hydrate move at the platform
  boundary; cite for the chip-mapping discussion.
- [`journal/library/concepts/token-chip.md`](../../library/concepts/token-chip.md)
  — the chip's identity is the locator, not the displayed pet
  name. Carries into the platform-bridge case: a Slack `@user`
  expanded into an Endo token chip must preserve the underlying
  capability locator across platform-side display drift.
- [`journal/library/concepts/space.md`](../../library/concepts/space.md)
  — the *space* abstraction (`SpaceConfig` with `profilePath`,
  `mode`, `order`, etc.) that the chat UI uses to switch between
  agent contexts. Cite for whether a bridged platform thread maps
  to a new space, joins an existing space, or is space-orthogonal.
- [`journal/library/sources/endo-but-for-bots--llm-designs-chat-spaces-inbox.md`](../../library/sources/endo-but-for-bots--llm-designs-chat-spaces-inbox.md)
  — per-space inbox view; unread-count badges; in-space message
  context. Cite for how a bridged platform conversation surfaces
  in the chat UI as a space.
- [`journal/library/sources/endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge.md`](../../library/sources/endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge.md)
  — the *transport-agnostic-agent* discipline: stdio and WebSocket
  are two transports to the same underlying daemon agent. A
  channel bridge is a third transport; cite for the precedent that
  the daemon already enforces *what an agent can do, independent
  of how it was invoked*.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md)
  § *Rules of engagement* — designs land on the `llm` branch as
  draft PRs per `roles/designer/AGENT.md` § Operating norms.
  § *Standing authorizations* — the maintainer's "you are
  generally authorized to post freely on endo-but-for-bots"
  framing covers PR comments and reviews the designer may post.
- **Project design (existing, the load-bearing reference)**:
  `designs/endoclaw-channel-bridges.md` on `llm` (183 lines,
  Status: Not Started, Parent: `endoclaw.md`, Author: Kris Kowal
  prompted, Created/Updated 2026-03-03). This design **already
  proposes the npm `chat` package as the foundation**, enumerates
  the seven adapters, lays out the Endo-guest-plugin architecture
  diagram, maps four Endo message types to platform renderings,
  and flags the SES-compatibility audit as the open work. The
  designer's first question is *amend this design or supersede
  it?* — not *write a new one from scratch*. See "Why each
  reference is relevant" below for the amend-or-supersede gap
  analysis the maintainer asked for.
- **Project design (parent)**: `designs/endoclaw.md` on `llm`
  (444 lines, Status: Reference). Channel bridges sit under the
  endoclaw "feature parity with OpenClaw" umbrella; this is the
  current home of the bridge design. A net-new alternative might
  reframe the bridge as a `daemon/`-layer concern (e.g.,
  `designs/daemon-channel-bridge.md`) rather than an
  endoclaw-feature; cite this design when motivating either
  promotion or re-parenting.
- **Project design (sibling, DCP)**:
  `designs/daemon-capability-persona.md` on `llm`. The connector
  pattern + delegate/epithet vocabulary the channel-bridges design
  inherits. A net-new design would supersede the connector text in
  channel-bridges by citing DCP directly.
- **Project design (sibling, streaming)**:
  `designs/daemon-message-streaming.md` on `llm`. Phase 1 open as
  PR #287. The bridge's streaming-to-platform path depends on
  this; cite for the integration shape.
- **Project design (sibling, edit-history)**:
  `designs/daemon-message-streaming.md` § (linked-list edit
  history reshape) as resolved by kriskowal's 04:47Z answers on
  PR #125. The bridge's platform-edit-roundtrip behavior depends
  on which shape the daemon lands; the designer should cite the
  PR and pick one of the two bridge stances (round-trip platform
  edits as linked-list `previous` entries vs. treat as new
  messages).
- **Project package (existing in-repo, namespace-clash risk)**:
  `packages/chat/` is `@endo/chat` (the existing in-repo web chat
  client). The npm `chat` package shares the bare name `chat`.
  The bridge plugin's `import 'chat'` will resolve to the npm
  package only after install; the designer must note the import-
  path discipline (use `'chat'` for the SDK; never alias
  `@endo/chat` to `chat`) and the dependency-graph implication
  that adding `chat` + `@chat-adapter/*` widens the Endo
  dependency footprint substantially.
- **Project package (extension manifest precedent)**:
  `designs/endopi-extension-package-manifest.md`. The bridge is a
  guest plugin; this design covers the keyword + install command
  + per-kind confinement shape. If the bridge ships as a
  first-class plugin (vs. an in-tree experiment), cite this.

### Why each reference is relevant

- **endoclaw-channel-bridges (the gap-analysis headline)**: the
  design already exists, already names the npm `chat` package as
  the foundation, already enumerates the seven platform adapters,
  and already sketches the bridge-as-confined-guest architecture.
  Maintainer's "or acknowledge that the design already exists"
  clause resolves to: *yes, it exists at
  `designs/endoclaw-channel-bridges.md`*. The amend-vs-new
  decision is therefore informed by *what has changed since
  2026-03-03 that the existing design does not yet reflect*:
  (1) DCP landed as a sibling and supplies the connector/delegate
  vocabulary the channel-bridges design glosses; (2)
  daemon-message-streaming added the `streamId` envelope field
  and CapTP-rides-method-calls streaming substrate; (3) PR #125
  is reshaping edit-history as a linked-list of revisions, which
  changes the bridge's platform-edit-roundtrip stance; (4)
  `packages/chat` exists in-repo as `@endo/chat`, raising a
  bare-name namespace concern for `import { Chat } from 'chat'`;
  (5) the npm `chat` package itself has matured to v4.30.0 with
  ten platform adapters (vs. the seven enumerated in the
  2026-03-03 design — adapter-github + adapter-linear +
  adapter-twilio + adapter-web + adapter-whatsapp + adapter-
  messenger have appeared). An **amend** is the right call if
  these additions fold cleanly into the existing scaffold; a
  **net-new sibling** is the right call if any of them changes
  the architecture (most likely candidate: the DCP integration
  changes the connector contract enough that the bridge design
  wants a smaller, sharper rewrite).
- **DCP**: the connector pattern is the abstract form of the
  bridge. Channel-bridges design pre-dates DCP and should be
  amended to cite DCP rather than re-derive the connector
  vocabulary inline.
- **daemon-message-streaming**: the bridge maps Endo's CapTP-
  rides-method-calls stream into Vercel chat's post-then-edit
  fallback (`streamingUpdateIntervalMs`). The 2026-03-03 design
  does not address streaming because streaming did not yet
  exist; this is the strongest amend signal.
- **PR #125 edit-history linked-list**: the bridge's behavior
  when a user edits a message on Slack (and the bridge propagates
  the edit back into Endo) is undefined in the existing design;
  the designer must take a position now that the daemon shape
  is being decided this week.
- **endopi-extension-package-manifest**: the bridge is a guest
  plugin. This design provides the install/confinement vocabulary
  the channel-bridges design uses casually; cite for precision.
- **dehydrate-hydrate / token-chip / space**: the bridge crosses
  three vocabulary boundaries (capability references, embedded
  chips, agent-context grouping). Each concept page is a one-
  paragraph primer the designer can drop a `[[concept-id]]` link
  to rather than re-explain.
- **endopi-stdio-rpc-bridge**: precedent for *the daemon enforces
  what an agent can do, independent of how it was invoked*. The
  bridge inherits this discipline; a Slack message arriving via
  the bridge has the same capability-grant shape as a chat-UI
  message arriving via the WebSocket gateway. Cite for the
  transport-agnostic-agent framing.
- **endoclaw (the parent)**: motivates the bridge as an
  OpenClaw-parity feature. Re-parenting (moving the bridge out
  from under endoclaw and into a daemon-layer design) is one of
  the amend-vs-new axes; the maintainer's call.
- **`packages/chat/` namespace collision**: a load-bearing
  technical detail the existing design predates. `import
  { Chat } from 'chat'` resolves to the npm package only; the
  in-repo `@endo/chat` keeps the workspace prefix. Designer
  must call this out so the implementer does not accidentally
  shadow.

### Open questions (terms the prompt's subject mentions but
the library does not yet cover)

- *npm `chat` package* — no library concept page; no source page.
  The 2026-03-03 design is the only project-side reference and
  is not ingested. **Library gap**: a concept page
  `journal/library/concepts/channel-bridge.md` would be load-
  bearing if the bridge design proceeds; flag for scholar /
  librarian.
- *Vercel adapter SDK pattern* — the SDK's adapter shape
  (`createSlackAdapter`, `createMemoryState`, `Chat` constructor)
  is unique to this package and is not covered by any existing
  Endo precedent. The amend-or-new designer will be the first to
  formalize the SDK boundary in an Endo context.
- *Platform-side identity mapping* — DCP's epithet chain is
  Endo-internal; mapping it to Slack `bot.userName`, Discord bot
  bio, etc., is left implicit in the channel-bridges design and
  by DCP's "the connector renders the epithet chain into the
  platform's identity fields" hand-wave. The designer should
  surface this as a sub-question and decide whether to defer.
- *SES compatibility of `unified` / `remark-parse` / `remark-
  stringify`* — the channel-bridges design flags this as the
  open audit work but does not resolve it. Whether the bridge
  ships as confined-guest or unconfined-plugin depends on the
  audit outcome; the designer should keep both branches open
  in the amend or surface the choice in the new design.
```

## Library writeback

Added six keyword shortcuts to `journal/library/keywords.md` (all
pointing at the not-yet-ingested project design and the DCP source,
with the *NOT YET INGESTED* discipline applied to the project-design
pointers so future readers know to grep `journal/projects/` rather
than `journal/library/sources/`):

- `channel bridge` -> project design (not yet ingested)
- `endoclaw-channel-bridges` -> project design (not yet ingested)
- `Vercel chat SDK` -> project design (not yet ingested)
- `` npm `chat` package `` -> project design (not yet ingested)
- `` `@chat-adapter/slack` `` -> project design (not yet ingested)
- `platform connector bridge` -> DCP source
- `service connector` -> DCP source

No concept page drafted (the term is load-bearing but the channel-
bridges design is itself unindexed; the right move is a librarian
ingest of `endoclaw-channel-bridges.md` first, then a concept-page
draft that references both the source page and the DCP source).

## Open questions

- `endoclaw-channel-bridges.md` is **not yet ingested** into the
  library. This is the only project-side design that names the npm
  `chat` package and the only one that lays out the bridge-as-
  guest-plugin shape. **Library gap**: librarian / scholar should
  pick up ingestion on a near-term cycle so the next researcher
  invocation on this topic resolves via `library/sources/` rather
  than via `worktrees/.../designs/`.
- The npm `chat` package's adapter list has expanded from the
  seven enumerated in the 2026-03-03 design to ten (adapter-github,
  adapter-linear, adapter-twilio, adapter-web, adapter-whatsapp,
  adapter-messenger now exist). The designer should pull the
  current adapter list from `https://github.com/vercel/chat/tree/main/packages`
  and decide which subset the bridge design supports in its first
  pass.
- DCP's "the connector renders the epithet chain into the
  platform's identity fields" is a Slack-shaped intuition; whether
  the same mapping is meaningful for Telegram, Discord, GitHub,
  etc., is open. The designer should either resolve per platform
  or defer to per-bridge implementation.

Self-improvement: the project-design-not-yet-ingested case is now
recurrent (this is the third researcher invocation in two weeks
whose load-bearing pointer is a project design rather than a
library source). The keyword-index discipline of writing `(see
project design: <repo>@<branch>:<path>; NOT YET INGESTED)` rather
than the more usual `(see source: ...)` form is the right
workaround; surfacing it here so the next researcher invocation
adopts the same idiom without re-inventing it. Routing as a
message to librarian / gardener if it recurs once more.
