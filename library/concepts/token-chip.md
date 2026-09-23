---
id: token-chip
aliases: ["token chip", "token chips", "@-prefix chip", "pet-name chip", "named-value chip", "path chip", "removable chip", "token autocomplete"]
topics: [chat-ui]
---

# token-chip

A **token chip** is the chat client's visual representation of a
*pet-name reference* — a styled, removable, clickable chip with an
`@` prefix. Each chip is the rendered surface of a single underlying
formula identifier in the daemon: typing `@name` in the command bar
produces a chip; including a value reference in a sent message
produces a chip in the recipient's inbox; multi-value path fields
accumulate chips as the user adds entries.

What a chip *is*:

| Property | Meaning |
|---|---|
| **Visual** | Styled inline element with `@` prefix, distinct background, optional icon |
| **Identity** | Backed by one formula identifier (one capability in the daemon's address space) |
| **Clickable** | Opens the value-inspection modal — the chip is the "what is this?" button |
| **Removable** | × affordance (mouse) or Backspace-in-empty-field (keyboard); per the keyboard-manual parity invariant |
| **Autocompleted** | Created through `token-autocomplete.js` / `petname-path-autocomplete.js` / `petname-paths-autocomplete.js` per the autocomplete list-navigation invariant |

A chip is **not** a string. The textual `@name` is the input grammar
that *creates* the chip; once the chip exists, the underlying
formula identifier is what travels through the daemon — names are
unforgeable mappings the host wrote into the agent's pet store, and
the chip travels by identity, not by re-parsing the name on the
receiving side.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [chat-invariants/overview-and-six-invariants](../sections/endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants.md) | Token chips appear across send mode, autocomplete dropdowns, and modeline hints; the *autocomplete list-navigation* invariant standardizes how a chip-bearing dropdown navigates. |
| [chat-invariants/principles](../sections/endo-but-for-bots--llm-designs-chat-invariants--principles.md) | Names the *token chip* and *path chip* as visual-feedback affordances; lists keyboard mechanics (`@` to start a chip, Tab/Space to commit, Backspace in empty field to remove). |
| [chat-components/inventory-and-messages](../sections/endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md) | All three message kinds (package, eval-proposal, request) embed token chips; clicking inspects, dragging initiates multi-recipient flows. The chip is the address of the value the user is inspecting. |
| [chat-components/file-structure-and-component-map](../sections/endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map.md) | `token-autocomplete.js` + `petname-path-autocomplete.js` + `petname-paths-autocomplete.js` form the autocomplete-component family that produces chips. |
| [chat-markdown-render/package-extraction-and-typed-ast](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) | The Private-Use-Area placeholder character (``) marks a chip slot in the source text *before* the parser runs. `@endo/markmdown` classifies the rune as regular non-whitespace non-punctuation so the chip mechanism composes with the parser; `@endo/chat` post-processes the rendered DOM to swap placeholders for `md-chip-slot` spans. |
| [chat-markdown-render/delimiter-realignment-and-flanking-rules](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) | The placeholder-as-regular-character classification means `**@alice**` bolds a chip without breaking the flanking rules; users can use any emphasis around chips. |
| [chat-edit-message-ui/design-decisions](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions.md) | Decision 4 extends the chip's *identity is the chip, not the name* rule to edit-mode: when an embedded token in the original body refers to a pet name since renamed or removed, the edit form renders the chip carrying the underlying locator/identifier, not the stale pet name. An edit operation that re-rendered chips from pet names alone would silently rewrite the *capability* the message references. |
| [chat-edit-message-ui/problem-and-authority](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority.md) | The edit form's body field reuses `send-form.js`; embedded `@petName` tokens work exactly as in a fresh send, producing chips through the existing autocomplete mechanism. The pre-populated body carries chips for any embedded references the original message carried. |

## See also

- [[producer-typed-shape-consumer-rendering]] — the chip is the *rendering* side; the formula identifier is the typed shape the daemon carries. A consumer that wanted to render references in chat markup, log output, or JSON would each produce a different rendering of the same typed reference.
- [[dehydrate-hydrate]] — the chat's pet-name + chip layer is the human-readable rendering; the daemon's formula key is the durable substrate. Long-stored message content stores the formula key, not the chip; the chip is reconstituted at render time.
- [[pass-invariant-handle-equality]] — when two pet names resolve to the same backing identity, they produce two visually-distinct chips that are *equality-equal* under the daemon's reference comparison — the chip's visual identity (the name shown) and its capability identity (the formula identifier) are deliberately separable.

## Design properties the chip embodies

1. **Confinement by structure**: a chip can only exist for a name the host has granted to the agent's pet store. The agent cannot fabricate a chip for a name it does not hold — the autocomplete only offers what exists.
2. **Identity is the chip, not the name**: clicking inspects the value; dragging operates on the capability. Two chips that show the same name but represent different formula identifiers are *different chips*. Conversely, two chips with different displayed names representing the same backing identity are equal under capability comparison.
3. **Removable without ambient effect**: removing a chip is a UI-side operation; it does *not* remove the underlying capability from the agent's pet store. The pet-store removal is a distinct action (the inventory's × button, also subject to keyboard-manual parity).
4. **Multi-chip composition**: path chips and endowment chips compose multiple references into a structured input; the path is the same multi-segment pet-name path the daemon's `send(["bob", "slack"], ...)` API consumes.

## Provenance note

Concept added cycle 55.5 at maintainer request, after token-chip
appeared as a distinct affordance in two chat sources (chat-invariants
and chat-components). Cycle 68 (chat-edit-message-ui) extended the
concept's *identity is the chip, not the name* rule to the edit-mode
form: when a pet name has drifted (renamed or removed) since the
message was sent, the chip carries the underlying locator and not
the stale name, so the capability survives the edit. The same source's
sibling section (problem-and-authority) confirms that the edit form
reuses `send-form.js`'s autocomplete, so chips compose with edit-mode
exactly as in fresh-send mode.
