---
ts: 2026-06-08T05:07:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--21f544
refs:
  - entries/2026/06/08/045800Z-dispatch-researcher-52156c.md
  - entries/2026/06/08/050232Z-result-researcher-52156c.md
---

# dispatch: designer — amend `designs/endoclaw-channel-bridges.md` (npm chat plugin integration, 5 substantive updates since 2026-03-03)

User directive (2026-06-08T04:51Z):

> Please dispatch a designer to create or modify (or acknowledge
> that the design already exists) that integrates
> https://www.npmjs.com/package/chat as a plugin for bridging
> chat with other platforms. Review the daemon's chat verbs, the
> exposed chat interface, and identify gaps. Note the ongoing
> work for editing messages in flight. Note the need for
> tokenized references (capability links). Discuss options. This
> may simply be amendments to existing designs that are open for
> review, or a new design PR if necessary.

## Headline finding from researcher `52156c`

**The design already exists**: `designs/endoclaw-channel-bridges.md`
on `origin/llm@11a76ae6` (183 lines, Not Started, Kris Kowal
prompted, 2026-03-03, parent `endoclaw.md`). It explicitly names
the npm `chat` package (Vercel's unified bot SDK) as the
recommended foundation, enumerates the seven adapters, lays out
the bridge-as-confined-guest architecture, maps four Endo message
types to platform renderings, and flags SES-compatibility as the
open audit work.

The designer's choice reduces to **amend that design** vs **open
a sibling that supersedes it**. Per the researcher's gap analysis,
amend is the right call — there are 5 substantive updates since
2026-03-03, each surgical.

## 5 substantive updates needed (from researcher)

1. **DCP** (`designs/daemon-capability-persona.md`) landed and
   supplies the connector/delegate vocabulary the channel-bridges
   design re-derives inline. Refactor to cite DCP rather than
   re-derive.
2. **daemon-message-streaming** (PR #287 phase 1 open) added
   `streamId` envelope extension + CapTP-rides-method-calls
   streaming substrate. Bridge must map this into Vercel chat's
   `streamingUpdateIntervalMs` post-then-edit fallback.
3. **PR #125 edit-history linked-list reshape** (kriskowal
   answered the 4 fixer questions 2026-06-08T04:47Z): initial
   message reserves slot, edits replace in place, persist chain
   on `done` by capturing `previous` link, accept ephemeral
   hang-ups, add `cancelMessage` verb. The bridge's platform-
   edit-roundtrip stance needs updating.
4. **`packages/chat` exists in-repo as `@endo/chat`**, raising
   a bare-name namespace concern for `import { Chat } from
   'chat'` (the npm `chat` package's recommended import shape).
   Resolve as part of the amendment (rename, alias, or note the
   collision).
5. **npm `chat` package matured** from v? to v4.30.0; adapter
   list expanded from 7 to 10 (added github / linear / twilio /
   web / whatsapp / messenger). Update the enumeration.

## State at dispatch time

- **Bot llm tip**: `11a76ae6042ef0994f9cb3f2ec722a0ec05e127b`.
- **Target design file**: `designs/endoclaw-channel-bridges.md`
  on `llm`.
- **Open PRs that the amendment may interact with**:
  - PR #287 (daemon-message-streaming) — cite streamId
  - PR #125 (editMessage + linked-list shape) — cite the
    settled schema
  - PR #404 (chat-inventory-create-menu) — cite (the bridge
    is a downstream consumer of the inventory's provider
    rows)
  - PR #305 (chat-edit-message-ui) — cite if relevant
  - PR #89 (genie-integration) — Pi-vs-Endo split touches the
    channel bridge's connector/delegate split

## Task

In your `project/` worktree on bot llm tip `11a76ae6`:

1. **Read the existing design** at
   `designs/endoclaw-channel-bridges.md` carefully. Understand
   its current shape (parent: endoclaw; status: Not Started;
   architecture: bridge-as-confined-guest with adapter
   plugins).
2. **Read the researcher's full inlined section** at
   `journal/entries/2026/06/08/050232Z-result-researcher-52156c.md`
   for the library references and gap analysis.
3. **Mint frozen base** `llm-11a76ae` (existing this cycle from
   prior dispatches; reuse).
4. **Create amend branch** off the frozen base, e.g.,
   `docs/design-endoclaw-channel-bridges-amend`.
5. **Apply the 5 substantive updates** above. For each:
   - **DCP refactor**: replace inline connector/delegate
     vocabulary with citations to
     `designs/daemon-capability-persona.md`.
   - **Streaming**: add a sub-section under § Platform-edit-
     roundtrip on how `streamId` maps to Vercel chat's
     `streamingUpdateIntervalMs` post-then-edit fallback. Cite
     PR #287.
   - **Edit-history linked list**: add a sub-section on how
     the bridge handles in-flight edits per kriskowal's just-
     settled schema (initial-reserves-slot; edits replace; chain
     on `done`; `cancelMessage` for sender-side cancel). Cite
     PR #125 + kriskowal's reply
     <https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4645600186>.
   - **`@endo/chat` collision**: add an Implementation Note
     resolving the bare-name `chat` import shape (rename the npm
     package's import locally, alias, or call out the namespace
     collision as a constraint on the implementation).
   - **Adapter enumeration update**: expand 7 → 10 adapters,
     name the new three (github, linear, twilio, web, whatsapp,
     messenger — pick the canonical three for the design's
     intent).
6. **Address the user's verbatim asks**:
   - **Daemon's chat verbs**: enumerate and identify gaps. The
     researcher's notes give you the list (`sendMessage`,
     `editMessage`, `messageHistory`, planned `cancelMessage`).
     Note gaps the bridge needs (cross-platform identity, attach-
     ment fidelity, reaction semantics, threading).
   - **Tokenized references / capability links**: discuss the
     bridge's need to encode pet-name handles for cross-platform
     sharing. Cite dehydrate-hydrate and space-references.
   - **Discuss options**: surface the rename-vs-alias-vs-collision-
     constraint trade-off for `@endo/chat` vs npm `chat`.
7. **Update `designs/README.md`** if the row needs status update
   (Not Started → ... or amendment-marker as appropriate).
8. **Push** the amend branch to origin.
9. **Open the PR DRAFT** with base `llm-11a76ae`, head
   `docs/design-endoclaw-channel-bridges-amend`, title
   `docs(designs): amend endoclaw-channel-bridges (DCP, streaming,
   edit-history, @endo/chat, adapter refresh)`. Body should:
   - Cite the user's directive and the researcher's gap analysis.
   - Enumerate the 5 substantive updates by sub-section.
   - Cite the cross-referenced open PRs (#287, #125, #404, #305,
     #89).
   - State this is an amendment to an existing design; no
     supersession.

## Authorizations (per-action, forwarded by steward)

- **Push** amend branch.
- **Open the DRAFT PR** on bot fork with base `llm-11a76ae`.
- **Post the draft-PR body** (`endo-but-for-bots` standing
  broad-comment authorization).

## Out of scope

- Do NOT amend other designs in the same PR (the 5 cited
  designs/* files are referenced, not modified).
- Do NOT touch packages outside `designs/`.
- Do NOT pre-implement the bridge.
- Do NOT trigger panel/judge/fixer chain.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- Frozen-base + amend-branch + opened PR number/URL.
- Per-update section: the diff size and which library/PR cites
  were added.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
