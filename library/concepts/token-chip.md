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
and chat-components). Subsequent chat-design ingests are likely to
extend the concept — particularly `chat-edit-message-ui.md` (chip
behaviors in editable messages) and `chat-spaces-gutter.md` (whether
the spaces gutter uses chip-like affordances or a different surface).
