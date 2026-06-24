---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/whylip/README.md
source_line_range: 1-121
source_commit: e1a5cda58e2f7686833e399da2f3cf8e699d680e
source_date: 2026-03-10
source_authors: [kumavis]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 443 designs-lane ingest. 121-line README.md for
  @endo/whylip — the interactive illustrated primer that
  runs as a mode inside Endo Chat. First designs-lane
  ingest from the whylip package; cycle 442 (chat-lane)
  ingested SceneCanvas.jsx (the Layer 6 iframe sandbox).
  One-hundred-and-thirty-third consecutive non-garden
  source after the pivot (310-443). Ninety-first AUTHORED
  conformant single-body section doc in post-refactor era.

  Single most structurally interesting move: §the-named-
  dual-backend-conversation-tree-as-mailbox-derived-
  reconstruction — the @endo/conversation-tree package
  is used by BOTH Fae and the Whylip UI, but with
  different backends. Fae uses EndoPetstoreBackend:
  nodes persist in the daemon's petname store and
  survive endo restart. Whylip UI uses MemoryBackend:
  tree is reconstructed entirely from the CapTP mailbox
  on each page load. The conversation state is
  authoritative on the Fae (daemon) side; the UI holds
  only a transient reconstruction. §the-named-daemon-
  side-as-authoritative-conversation-state as tier-3
  meta-pattern.

  §the-named-whylip-as-branching-primer-not-linear-chat
  — Whylip is specifically an interactive ILLUSTRATED
  PRIMER with branching exploration, not a general chat
  UI. Clicking any node in the conversation tree forks
  the conversation from that point; the Fae agent
  rebuilds its context window from only the messages on
  the active branch path. §the-named-branch-from-any-
  past-node-as-exploration-idiom.

  §the-named-scene-plus-narrative-json-schema — Fae's
  response format is structured JSON: { narrative, scene
  }. Narrative is text rendered below the scene area;
  scene is a self-contained HTML/CSS/JS document placed
  via srcdoc into the sandboxed iframe (Layer 6, cycle
  442). The structured response schema is the bridge
  between the LLM and the iframe sandbox. §the-named-
  structured-llm-response-as-ui-driver.

  §the-named-whylip-host-as-endo-guest-routing-layer —
  Whylip creates a new Endo host profile per book. The
  Whylip UI sends messages to the Fae agent through a
  petname reference (E(powers).send('fae', ...)) via
  CapTP. The host-profile-per-book pattern scopes the
  Fae petname reference to the book, providing
  capability isolation between books. §the-named-per-
  book-host-profile-as-cap-isolation.

  §the-named-voice-input-as-whylip-affordance — Whylip
  includes a microphone button backed by the Web Speech
  API (SpeechRecognition + SpeechSynthesis) for voice
  input. This is the first source in the library to
  ground voice-input as a first-class Endo UI affordance.

  §the-named-ninety-one-conformant-cycles-and-counting.

  Closes six citation arcs: cycle 442 (1, adjacent
  forward — SceneCanvas.jsx (Layer 6) now contextualised
  by its parent package architecture) + cycle 440 (3,
  the six-layer exfiltration defense is placed in full
  architectural context: the iframe sandbox exists to
  sandbox LLM-generated scene HTML from a Fae agent) +
  cycle 436 (3, the full whylip→fae→captp→llm pipeline
  explains WHY the six layers were designed) + cycle 429
  (3, CapTP as user-facing cross-network message bus
  confirmed in whylip→fae reference) + cycle 413 (3,
  EndoPetstoreBackend confirms daemon-side petname-store
  as durable message-threading substrate) + cycle 439
  (3, MemoryBackend reconstruction from mailbox mirrors
  liveness-revocation: mailbox IS the canonical state).
  Pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-EIGHTY-NINE (883 + 6 net new).
---

121-line `packages/whylip/README.md` — the @endo/whylip package overview. Whylip is an interactive illustrated primer that runs as a mode inside Endo Chat, connecting to a Fae agent for LLM-generated responses rendered as interactive scenes in sandboxed iframes, with a branching conversation tree for exploring topics from multiple angles. Designs-lane after cycle 442 chat-lane SceneCanvas.jsx. **Single most structurally interesting move**: §the-named-dual-backend-conversation-tree-as-mailbox-derived-reconstruction — *@endo/conversation-tree is used by BOTH Fae and the Whylip UI, but with different backends and durability models. Fae's EndoPetstoreBackend persists nodes in the daemon's petname store (survives endo restart). Whylip UI's MemoryBackend reconstructs the tree entirely from the CapTP mailbox on each page load. The conversation state is authoritative on the daemon side; the UI holds a transient reconstruction derived from the mailbox.* §the-named-daemon-side-as-authoritative-conversation-state. §the-named-whylip-as-branching-primer-not-linear-chat (branching exploration via click-any-node-to-fork; Fae rebuilds context from active branch path only); §the-named-branch-from-any-past-node-as-exploration-idiom. §the-named-scene-plus-narrative-json-schema (structured JSON {narrative, scene}; bridge between LLM and iframe sandbox); §the-named-structured-llm-response-as-ui-driver. §the-named-whylip-host-as-endo-guest-routing-layer (new host profile per book; E(powers).send('fae', ...) via CapTP; per-book-host-profile as cap isolation); §the-named-per-book-host-profile-as-cap-isolation. §the-named-voice-input-as-whylip-affordance (Web Speech API; first grounding of voice input as Endo UI affordance). §the-named-ninety-one-conformant-cycles-and-counting. Six citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-EIGHTY-NINE.

## Section list

- [endo-but-for-bots--packages-whylip-README-md--dual-backend-conversation-tree-as-mailbox-derived-reconstruction](../sections/endo-but-for-bots--packages-whylip-README-md--dual-backend-conversation-tree-as-mailbox-derived-reconstruction.md)
