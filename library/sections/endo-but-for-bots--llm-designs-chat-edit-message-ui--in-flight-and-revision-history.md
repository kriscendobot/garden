---
title: Edit while in flight, the "edited" caption, and the revision panel
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Covers two coupled surfaces: the in-flight visual state for an edit
  the daemon has not yet acknowledged, and the read-only revision panel
  that renders the array returned by `E(profile).messageHistory(number)`.
---

`editMessage` is an ordinary eventual send. The user may issue a
second `/edit` against the same message number while a prior edit is
still in flight. The chat UI does not gate this. The daemon's revision
log is append-only, and the recipient resolves ordering from the
revision timestamps, so a "racing edits from the same sender" scenario
degrades to *last edit wins* rather than to a broken envelope.

## In-flight visual state

While an edit is in flight, the message envelope renders with a faint
"saving" affordance, reusing the same indeterminate-progress style used
for not-done messages per
[[endo-but-for-bots--llm-designs-daemon-message-streaming]]. The
affordance clears when the edit settles. The choice to share the
not-done style is deliberate: a not-done streaming send and a not-yet-
acknowledged edit are the *same kind of state* from the recipient's
point of view — content is in motion, the envelope has not settled —
and reusing the visual idiom keeps the chat's affordance vocabulary
small.

## The "edited" caption

A message that has been edited at least once carries an `edited
<timestamp>` caption in its envelope footer, where `<timestamp>` is the
time of the most recent edit. The caption *replaces* (rather than
supplements) the original send timestamp, since a reader who wants the
original time can open the revision panel. This is a deliberate
trade-off in favor of compactness: a typical message envelope footer
has room for one timestamp without crowding, and the revision panel
carries the full history anyway.

## The revision panel

Hover or click on the `edited` caption opens a revision panel that
calls `E(currentProfile).messageHistory(number)` and renders the array
oldest-first:

```
┌───────────────────────────────────────────────┐
│  Revisions of #42                       [×]   │
├───────────────────────────────────────────────┤
│  2026-05-05 14:31:02   (done)   <body>        │
│  2026-05-05 14:30:58            <body>        │
│  2026-05-05 14:30:55            <body>  ← now │
└───────────────────────────────────────────────┘
```

Each revision renders its payload through the same Markdown-and-tokens
pipeline as the live envelope (see
[[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]]).
The current revision is marked. The panel is *read-only*; restoring a
prior revision is just another `/edit` against the latest body. That
choice keeps the panel a passive viewer rather than another mutation
surface, and avoids the "two ways to write the same edit" problem.

## Interaction with focus chains

Editing a message does not change its `messageId`, its `replyTo`
linkage, or its message number. The reply-chain visualization in
[[endo-but-for-bots--llm-designs-chat-focus-message]] is unaffected.
The focused message stays focused across an edit. If the user edits
the focused message, the envelope re-renders with the new body but
retains the `.focused` class and ring highlight.

This is an instance of *identity is more durable than rendering*: the
typed message identity (number + reply linkage) survives the surface
change (body text + revision-history accretion). A consumer (the
focus-chain visualizer, the inbox-position lookup) that walks
identities does not need to be re-walked when a body changes; only the
rendering surface re-renders. The producer-typed-shape /
consumer-rendering split (see [[producer-typed-shape-consumer-rendering]])
applies here as it does to the chip mechanism.

## Implications for Endo

The append-only revision log on the daemon side, paired with the
*last edit wins* race-resolution rule on the recipient side, mirrors
the CRDT-shape patterns elsewhere in Endo's persistence story (see
[[crdt-in-formula-persistence]] for the abandoned-but-instructive
bidirectional version): a producer can re-send arbitrarily often, the
substrate accumulates history without coordination, and consumers read
the latest. The chat UI's "racing edits degrade to last-edit-wins"
rule is the consumer-side complement to the daemon-side append-only
log. Future surfaces that surface daemon-state in the chat client can
borrow the same shape: hide ordering questions inside the daemon, let
the UI render the latest, expose the history through a read-only
panel.

## See also

- [[endo-but-for-bots--llm-designs-daemon-message-streaming]] — provides `editMessage` and `messageHistory`; this section describes the chat-side rendering of both.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]] — the rendering pipeline the revision panel reuses for each historical payload.
- [[crdt-in-formula-persistence]] — the broader pattern of append-only logs + consumer-side latest-wins resolution.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
