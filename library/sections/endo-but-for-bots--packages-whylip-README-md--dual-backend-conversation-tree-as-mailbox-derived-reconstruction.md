---
source: endo-but-for-bots--packages-whylip-README-md
cycle: 443
lane: designs
ingested: 2026-06-22
repo: endo-but-for-bots
branch: llm
package: whylip
cluster: pivot
shape: readme
shape_subtype: package-architecture-overview
authored_conformant: true
post_refactor_era: true
post_refactor_sequence: 91
---

The 121-line `packages/whylip/README.md` is the architectural overview for `@endo/whylip` — an interactive illustrated primer that runs as a mode inside Endo Chat. Whylip connects to a Fae agent as its LLM backend and renders LLM-generated responses as interactive scenes inside sandboxed iframes, with a branching conversation tree that lets users explore topics from multiple angles. Cycle 443's single most structurally interesting move introduces a durability asymmetry that was invisible from the code alone: the conversation tree is backed by two different backends with different persistence semantics, and the daemon side is the authoritative state. §the-named-dual-backend-conversation-tree-as-mailbox-derived-reconstruction names the pattern.

The `@endo/conversation-tree` package is used by BOTH Fae and the Whylip UI, but with different backends. Fae's side uses `EndoPetstoreBackend`: conversation nodes persist in the daemon's petname store and survive `endo restart`. The Whylip UI side uses `MemoryBackend`: the tree is reconstructed entirely from the CapTP mailbox on each page load. The conversation state is authoritative on the Fae (daemon) side; the UI holds a transient reconstruction derived from the mailbox. This means a Whylip UI reload never loses conversation history — the mailbox is the canonical source — but the UI never independently stores conversation state. §the-named-daemon-side-as-authoritative-conversation-state names the durability model as tier-3 meta-pattern.

This is a new shape in the library. Previous sources established the mailbox as a message-passing substrate (cycle 413's agent-facing messaging.md) and the daemon's petname store as a capability-naming layer (cycles 394, 439). Cycle 443 grounds a third use of the petname store: as a durable conversation-history substrate, where each conversation node is stored as a named value that persists across restarts. The petname store is not just for capability references; it is a general-purpose persistent object store that Whylip repurposes for branching conversation state. §the-named-petname-store-as-general-persistent-object-store.

Whylip is specifically an interactive ILLUSTRATED PRIMER with branching exploration, not a general chat UI. The sidebar shows the full conversation tree as an indented outline; `›` markers are user messages, `◆` markers are assistant responses. Clicking any node forks the conversation from that point; the Fae agent rebuilds its context window from only the messages on the active branch path. This branching model is explicitly compared to Pi's `/tree` command in the README. §the-named-whylip-as-branching-primer-not-linear-chat names the distinction; §the-named-branch-from-any-past-node-as-exploration-idiom names the mechanism: the user can fork from any past point without losing previous branches.

The LLM response schema is structured JSON: `{ narrative, scene }`. Narrative is text rendered below the scene area as Markdown-like content. Scene is a self-contained HTML/CSS/JS document placed via `srcdoc` into the sandboxed iframe. This structured response schema is the bridge between the LLM and the iframe sandbox established in cycle 442 (Layer 6 of the six-layer exfiltration defense). §the-named-scene-plus-narrative-json-schema names the format; §the-named-structured-llm-response-as-ui-driver names the role: the LLM output is a UI driver, not free text. The iframe sandbox (`sandbox="allow-scripts"`) confines the scene; the structured schema confines the LLM output to a known rendering path.

Whylip creates a new Endo host profile per book. The Whylip UI sends messages to the Fae agent through a petname reference (`E(powers).send('fae', ...)`) via CapTP. The `fae` petname is written into the book's host profile during book creation by the chat package's `add-space-modal.js`. This per-book host profile scopes the Fae petname reference to the book, providing capability isolation between books: a message sent from one book's Whylip host cannot reach another book's Fae agent by construction. §the-named-whylip-host-as-endo-guest-routing-layer names the routing architecture; §the-named-per-book-host-profile-as-cap-isolation names the isolation property.

The full message pipeline, as the README spells it out:

```
User input
  → Whylip host sends to "fae" petname (E(powers).send('fae', ...))
  → Fae agent receives message, assembles context from ConversationTree
  → LLM responds with JSON { narrative, scene }
  → Fae replies via endo messaging
  → Whylip host receives reply in its mailbox
  → Whylip UI adds to local tree, renders scene + narrative
```

This pipeline integrates five prior library concepts in one diagram: CapTP messaging (cycle 413), petname-based routing (cycle 394), Fae's inbox/LLM loop (not yet directly ingested as a source), structured LLM response driving UI rendering (this cycle), and the iframe sandbox for the scene (cycle 442). The CapTP mailbox that backs `MemoryBackend` reconstruction is the same mailbox that carries Fae's reply; the conversation-tree and the message-bus are the same substrate.

Whylip includes a microphone button backed by the Web Speech API (`SpeechRecognition + SpeechSynthesis`) via a `useSpeech` hook in `src/hooks/useSpeech.js`. This is the first source in the library to ground voice input as a first-class Endo UI affordance. The browser-native Web Speech API is used rather than a daemon capability; the voice path enters the same text-input pathway and is not a separate CapTP surface. §the-named-voice-input-as-whylip-affordance names the capability.

§the-named-ninety-one-conformant-cycles-and-counting marks the session-level observation: ninety-first AUTHORED conformant single-body section doc in post-refactor era (cycles 353-443). §one-hundred-and-thirty-three-cycles-with-named-pivot-domain-stay (310-443).

Closes six citation arcs. Cycle 442 (1, adjacent forward — SceneCanvas.jsx now contextualized by its parent package architecture: the sandboxed iframe exists to confine LLM-generated scene HTML from a Fae agent). Cycle 440 (3, the six-layer exfiltration defense placed in full architectural context: Layer 6 sandbox exists specifically for the { narrative, scene } response schema). Cycle 436 (3, the whylip→fae→captp→llm→iframe pipeline explains why the six defense layers exist and for what threat model). Cycle 429 (3, CapTP at user-facing cross-network layer confirmed: E(powers).send('fae', ...) is the CapTP send from the Whylip host). Cycle 413 (3, EndoPetstoreBackend confirms daemon-side petname store as durable message-threading substrate, extending cycle 413's agent-facing messaging framing). Cycle 439 (3, MemoryBackend reconstruction from mailbox mirrors liveness-revocation pattern: the mailbox is the canonical state; the UI's local tree is derived and transient). Pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-EIGHTY-NINE (883 + 6 net new).

**The @endo/whylip package establishes a new pattern in the library: the dual-backend conversation tree where daemon-side persistence (EndoPetstoreBackend, petname store) is the authoritative state and UI-side reconstruction (MemoryBackend, mailbox) is a derived cache. The structured JSON { narrative, scene } schema bridges LLM output to the iframe sandbox established in cycle 442. The per-book host profile provides capability isolation between books at the CapTP routing layer.**
