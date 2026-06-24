---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §nine-method taxonomy
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Method Taxonomy organizes the locator-related directory
methods into four families:

### Name Resolution (three methods)

| Method | Returns |
|--------|---------|
| `identify(...path)` | internal formula identifier |
| `locate(...path)` | locator (external URL) |
| `lookup(...path)` | the formula's value (the live presence) |

The §three-resolution-targets: *identifier* (storage form),
*locator* (sharing form), *value* (live presence). Same path
input; three different output types.

### Reverse Resolution (three methods)

| Method | Returns |
|--------|---------|
| `reverseIdentify(id)` | all pet names for an identifier |
| `reverseLocate(locator)` | all pet names for a locator |
| `reverseLookup(presence)` | all pet names for a live value |

The §symmetric-six discipline: *each forward method has a reverse
counterpart*. The reverse methods return *all* matching pet names
(not just the first), because multiple pet names can refer to the
same identifier.

### Enumeration (three methods)

| Method | Returns |
|--------|---------|
| `list(...path)` | pet names in a directory |
| `listIdentifiers(...path)` | unique identifiers in a directory |
| `listLocators(...path)` | `Record<name, locator>` mapping |

The §three-enumeration-types parallel the three resolution-types:
*just names*, *deduplicated identifiers*, *name-to-locator map*.

### Writing (two methods)

| Method | Accepts |
|--------|---------|
| `write(path, id)` | internal identifier only |
| `writeLocator(path, locatorOrId)` | locator string OR identifier |

The §writeLocator-is-the-canonical-public-write discipline:

> *`writeLocator` is the canonical write method exposed through
> exos. It accepts either a locator string (starting with
> `endo://`) or a raw formula identifier. When given a locator,
> it calls `internalizeLocator` to extract the identifier before
> delegating to `write`. This method is defined once in
> `directory.js` and carried up through `host.js` and `guest.js`
> via destructuring — not re-implemented at each layer.*

The §define-once-destructure-up discipline: implement once in
`directory.js`; the layer above (`host.js`, `guest.js`) carries
the method up by destructuring. *Not re-implemented at each
layer*. The contrast with copy-paste implementation is structural:
one fix at the bottom layer propagates to all consumers
automatically.

### Subscription (two methods)

| Method | Returns |
|--------|---------|
| `followNameChanges(...path)` | `AsyncIterator<NameChange>` |
| `followLocatorNameChanges(locator)` | `AsyncIterator<LocatorNameChange>` |

The §subscription-pair lets observers track name changes either
*by path* (within a directory) or *by locator* (for a specific
remote formula).
