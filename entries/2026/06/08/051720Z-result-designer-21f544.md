---
ts: 2026-06-08T05:17:20Z
kind: result
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
refs:
  - entries/2026/06/08/045800Z-dispatch-researcher-52156c.md
  - entries/2026/06/08/050232Z-result-researcher-52156c.md
---

# result: designer 21f544 — amend designs/endoclaw-channel-bridges.md per "integrate npm chat as platform-bridge plugin" directive

## Summary

Amended `designs/endoclaw-channel-bridges.md` on `endojs/endo-but-for-bots`
to fold in the five surgical updates the researcher's gap analysis
identified, plus the requested daemon-mail-verb enumeration and
tokenised-references / capability-links sub-section. Opened DRAFT
PR #431 against the frozen base `llm-11a76ae`. No other designs were
amended (DCP, daemon-message-streaming, chat-edit-message-ui,
endopi-extension-package-manifest are cited rather than modified).
Status field remains Not Started.

PR URL: https://github.com/endojs/endo-but-for-bots/pull/431
Branch (head): `docs/design-endoclaw-channel-bridges-amend`
Base (frozen): `llm-11a76ae`
Commit: `9cb09ff23`
Diff: `designs/endoclaw-channel-bridges.md` (+525, -70 against original
183-line draft); `designs/README.md` Updated column for the row bumped
from 2026-03-03 to 2026-06-08.

## Five updates landed

1. **DCP vocabulary refactor**. The bridge is framed as a concrete
   instance of the *service connector* pattern in
   `daemon-capability-persona.md`. The DCP-level vocabulary
   (delegate, epithet, connector, credential custody) is cited as
   normative; the bridge inherits DCP's anti-impersonation invariant
   and identity-vs-action facet split by reference rather than
   re-derivation. Added per-platform notes on identity rendering for
   Slack, Discord, Telegram, GitHub (with a fallback for Linear,
   Twilio, WhatsApp, Messenger, Web) under *Identity rendering
   inherits from DCP*.

2. **Streaming sub-section** (new). Cites
   `daemon-message-streaming.md` and PR #287 (phase 1 landed; the
   design is in revision against the linked-list edit-history
   reshape per PR #125). Documents the optional `streamId` envelope
   field and the recipient-side `StreamReader`. Maps Endo's
   CapTP-rides-method-calls stream onto the Vercel chat SDK's
   post-then-edit primitive: bridge wraps the `StreamReader`,
   debounces `message.edit` calls to the SDK's
   `streamingUpdateIntervalMs`, handles `phase` / `end` / `abort`
   events per platform. Per-platform rate-limit floors flagged in
   Open Questions.

3. **Edit-history sub-section** (new). Cites PR #125 and folds in
   kriskowal's 2026-06-08T04:47Z four-answer set verbatim by
   property:

   - Slot reservation per answer #1; subsequent edits replace in
     slot; persistence (with `previous` link) only after `done`.
   - Formula types of prior revisions are transitively identical
     per answer #2 (no separate `message-revision` formula type).
   - Daemon-restart ghosting per answer #3; cleanup is user's or
     agent's choice.
   - No quiescence signal except the `done` bit per answer #4;
     the missing `cancelMessage` verb is acknowledged as the
     sender-side affordance for terminating an ephemeral message
     that will never settle on its own.

   The bridge's two platform-edit cases are sketched
   (outbound: divergent default; convergent via per-guest
   edit-on-behalf when that property lands per answer #1's hint).
   The inbound fallback when edit-on-behalf is missing is to treat
   platform edits as new inbox messages with a "[edited prior:]"
   body prefix; degrades politely until the daemon surface matures.

4. **`@endo/chat` versus npm `chat` namespace-collision
   Implementation Note** (new). The in-repo workspace package
   `packages/chat` is published as `@endo/chat`; the npm `chat`
   package is bare-named. Bridge code uses `import { Chat } from
   'chat'` to address the SDK and `@endo/chat` for the in-repo
   client; no aliasing across the prefix line. Dependency-footprint
   implication recorded (per-platform sub-packages
   `@endo/chat-bridge-slack`, `@endo/chat-bridge-discord`, and so
   on, via the `endopi` extension-manifest pattern, so each bridge
   brings only its adapter's deps).

5. **Adapter enumeration update**. The 2026-03-03 design listed 7
   platforms; the 2026-06-08 amend lists 11 (the 7 plus Twilio,
   WhatsApp, Messenger, plus a generic `@chat-adapter/web` for
   self-hosted UIs or unsupported platforms). Slack, Discord, and
   Telegram named as the recommended first-cut subset (Open
   Question 5 confirms this is a default rather than a fix).

## Other additions

- **Daemon mail-verb enumeration** (new section). Tables today's
  mail surface that the bridge exercises (`handle`, `listMessages`,
  `followMessages`, `send`, `reply`, `request`, `resolve`,
  `reject`, `dismiss`, `dismissAll`, `adopt`, `submit`, `sendValue`)
  plus the in-flight `streamReply` (PR #287 phase 1 landed),
  `editMessage`, and `messageHistory` (PR #125 in
  CHANGES_REQUESTED, awaiting linked-list reshape).
- **Gaps the bridge surfaces** (new sub-section). Three gaps
  recorded for follow-up rather than resolved:
  1. `cancelMessage(messageNumber)` is missing per PR #125 answer
     #4.
  2. A sender-side ephemeral-message ghost-cleanup verb is missing
     per PR #125 answer #3.
  3. A per-guest *edit-on-behalf* configurability is missing per
     PR #125 answer #1's hint.
  These are not blockers for channel-bridges implementation; they
  shape behaviour at the edges (platform-side cancellation, ghost
  cleanup, edit-on-behalf parity).
- **Tokenised references / capability-links** (new section).
  Records the *dehydrate-at-platform-edge* discipline for outbound
  chips (the chip's locator is the identity; platform `@`-mention
  is the display) and the *hydrate-at-platform-edge* discipline
  for inbound mentions (via the connector's
  `handleFor(platformIdentifier)` per DCP). Two flagged future-work
  items: bridge-to-bridge capability links (require a bridge
  directory design); a capability-bearing platform message format
  (research question). No new wire format proposed here.
- **Open Questions** (rewritten). Seven questions now: bridge
  stance on platform-side outbound edits while edit-on-behalf is
  missing; inbound platform-edit shape while edit-on-behalf is
  missing; per-platform streaming-cadence floor;
  `cancelMessage(messageNumber)` shape; per-platform first-cut
  subset; DCP epithet-to-platform-identity mapping per platform;
  re-parent-vs-amend (in-place amend keeps the design under
  `endoclaw`; re-parenting to `designs/daemon-channel-bridge.md`
  remains an option for future).
- **Architecture diagram** converted from ASCII to Mermaid per the
  designer-role norm.

## Citations preserved (not modified)

- `daemon-capability-persona.md` (DCP) for connector/delegate/epithet
  vocabulary.
- `daemon-message-streaming.md` for `streamReply` / `StreamWriter` /
  `StreamReader` and the `streamId` envelope field.
- `chat-edit-message-ui.md` as the UI sibling of the PR #125
  daemon-side edit-history surface.
- `endopi-extension-package-manifest.md` for the bridge plugin shape.
- `endopi-stdio-rpc-bridge.md` for the *transport-agnostic agent*
  precedent.
- `familiar-bundled-agents.md` for the esbuild bundling pattern.

## PR formation

- Base: `llm-11a76ae` (frozen base from earlier this cycle, per the
  dispatch).
- Head: `docs/design-endoclaw-channel-bridges-amend`.
- Title: `docs(designs): amend endoclaw-channel-bridges (DCP,
  streaming, edit-history, @endo/chat, adapter refresh)`.
- Body: per `skills/pr-formation/SKILL.md` four-part order
  (what / why / what to attend to / out of scope) folded into the
  project's PR template sections; cites PR #287 and PR #125 in
  `Refs:`; no checklists, no file callouts beyond the load-bearing
  metadata-table-row cite for `designs/README.md`.
- DRAFT (per designer norm; un-draft is the maintainer's call after
  review).

## Style compliance

- em-dash check: zero remaining (two introduced and then replaced
  during authoring per `skills/em-dash-style/SKILL.md`).
- Latin shorthand check: zero remaining (four `e.g.` / `etc.`
  occurrences introduced and then replaced with English equivalents
  per `skills/no-latin-shorthand/SKILL.md`).
- Mermaid diagram per the designer-role *Diagrams: use mermaid*
  norm; the original ASCII architecture diagram was the only one
  in the design.
- Relative paths throughout the design body; absolute paths only
  in the journal entry (per `skills/relative-paths/SKILL.md`).
- Per-sentence line wrapping per the project's Markdown Style
  guide; table cells exceed 100 columns where the contents require
  it (consistent with the original design's table-cell convention).
- `Updated` field bumped to 2026-06-08 in both the
  metadata table and the `designs/README.md` summary row per the
  project's `designs/CLAUDE.md` synchronisation rule.

## Out of scope (preserved per the dispatch brief)

- No other designs amended (DCP, daemon-message-streaming,
  chat-edit-message-ui, endopi-extension-package-manifest are cited
  rather than modified).
- No pre-implementation; the design's Status remains Not Started.
- No panel chain triggered; the PR is DRAFT and stays DRAFT until
  the maintainer reviews.

## Open dependencies for the librarian

- The amended design is still **not yet ingested** into the library
  per the researcher's writeback. The librarian's next ingestion
  cycle on `endo-but-for-bots/llm` should pick up the 2026-06-08
  revision and draft a `journal/library/concepts/channel-bridge.md`
  concept page (the researcher flagged this gap). The keyword index
  in `journal/library/keywords.md` already carries the
  *channel bridge* / *endoclaw-channel-bridges* / *Vercel chat SDK*
  / *npm chat package* / *@chat-adapter/slack* / *platform connector
  bridge* / *service connector* shortcuts from the researcher's
  writeback.

Self-improvement: nothing this time. The dispatch brief was unusually
detailed (5 explicit updates plus the gap-revealing
enumeration plus the capability-links sub-section), the researcher
had already done the library work, and the in-place amend pattern
on a 183-line design did not surface a gap in any of the loaded
skills (`frozen-base-branch`, `pr-formation`, `em-dash-style`,
`no-latin-shorthand`, `relative-paths`).
