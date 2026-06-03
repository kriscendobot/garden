---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
---

# Endo locator URL format with externalize↔internalize duality and LOCAL_NODE sentinel

> *An **endo locator** is a URL that identifies a formula on the
> Endo network. Locators are the external representation of
> formula identifiers, suitable for sharing between agents and
> across network boundaries. Internally, the daemon stores
> **formula identifiers** (compact `{number}:{node}` strings);
> locators are produced on demand by combining identifiers with
> type information and optional connection hints.*
>
> — `designs/daemon-locator-reference.md` §Overview

`daemon-locator-reference.md` (213 lines, *Current* status,
created 2026-03-18 by Kris Kowal in commit `f1d88c71`) is the
*canonical reference* for the Endo locator URL format. Pairs
with cycle 49's `daemon-locator-terminology` design which
specified the *rename* (Node Number → Peer Key, Formula Number →
Formula Address, Formula Identifier → Formula Key); this design
is the concrete *what the format actually is* document.

## The §three-locator-format family

The §Locator Format section defines three URL shapes:

### Standard locator

```
endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}
```

| Component | Description |
|-----------|-------------|
| `nodeNumber` | 64-char hex Ed25519 public key of the peer that hosts the formula |
| `formulaNumber` | 64-char hex formula number (SHA-256 content address or random capability address) |
| `formulaType` | `host` / `guest` / `handle` / `worker` / `directory` / `remote` |

The §standard locator is the *minimum-required* form for sharing
a formula across network boundaries: *who hosts it* (the
nodeNumber, an Ed25519 public key) + *which formula* (the
formulaNumber) + *what kind of thing it is* (the type).

### Locator with connection hints

```
endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}&at={address1}&at={address2}
```

The §`at` parameters are *repeated query parameters* providing
transport addresses where the peer can be reached. *Hints are
ephemeral* — they reflect the peer's *current* network
configuration and may change over time.

### Invitation locator

```
endo://{nodeNumber}/?id={invitationNumber}&type=invitation&from={hostHandleNumber}&at={address1}
```

Invitation locators extend the standard format with a `from`
parameter naming *the host's handle formula number* (used by the
accepting peer to identify the inviting host).

The §invitation-locators-parsed-separately discipline:

> *`parseLocator` validates standard locators (allowing only
> `id`, `type`, and `at` parameters), while invitation locators
> are parsed directly via `new URL()` in the invitation acceptance
> code paths.*

The §two-parsing-paths shape: standard locators go through the
strict `parseLocator` validator (rejects unknown params);
invitation locators bypass `parseLocator` because they have an
extra `from` parameter. The *two-path-validation* discipline lets
the canonical parser stay strict while the invitation flow has
its own validation in `daemon.js` and `host.js`.

## The §internal-formula-identifier format

The §Formula Identifiers section names the *internal* form:

```
{formulaNumber}:{nodeNumber}
```

Both halves are 64-character hex strings; the colon separator is
fixed. The §internal-vs-external distinction:

- **Internal**: `{number}:{node}` — *compact*, single-string,
  no protocol scheme, no query params. Storage-efficient. Used
  in daemon state, pet stores, formula graphs.
- **External**: `endo://{node}/?id={number}&type={type}` — *URL-
  shaped*, suitable for clipboard / chat / network sharing. Used
  on the wire and at user interfaces.

The §`LOCAL_NODE` sentinel:

```js
const LOCAL_NODE = '0'.repeat(64);
```

*All-zeros is never a valid Ed25519 public key, making it a safe
sentinel for "this daemon".* The §safe-sentinel-via-impossibility-
in-the-domain discipline. Local formulas use `LOCAL_NODE` as the
node number; remote formulas use the actual peer's public key.
This lets one storage format cover both *this-daemon* and
*another-daemon* references — the local case just has a
distinguishable node-number value.

## The §externalize-internalize duality

The §Externalization and Internalization section names the *two
operations* that bridge internal and external forms:

### `externalizeId(id, formulaType, agentNodeNumber, addresses?)`

> *Replaces `LOCAL_NODE` with the agent's own public key so that
> recipients know which peer to contact.*

```
internal id:  {number}:{LOCAL_NODE}
    → locator: endo://{agentKey}/?id={number}&type={type}
```

The §LOCAL_NODE-replaced-by-agentKey discipline: *when producing
a locator for an external audience, swap in the actual agent's
public key — the recipient must know which peer to contact*. The
sentinel is *internal-only*; external audiences see the real key.

Remote identifiers (where the node is not `LOCAL_NODE`) *pass
through with the node number unchanged*.

### `internalizeLocator(locator, isLocalKey)`

> *Recognizes any known local agent key and normalizes it to
> `LOCAL_NODE`.*

```
locator: endo://{agentKey}/?id={number}&type={type}&at={addr}
    → id: {number}:{LOCAL_NODE}
    → formulaType: {type}
    → addresses: [{addr}]
```

The §normalize-incoming-local-agent-key-to-LOCAL_NODE discipline:
*when receiving a locator, if its node is one of this daemon's
own keys, normalize to LOCAL_NODE in storage*. The reverse of
externalize. The `isLocalKey` predicate uses the daemon's
`localKeys` set (*containing all known local agent public keys*).

### The §round-trip invariant

> *For local formulas: `internalId → externalizeId →
> internalizeLocator → internalId  ✓`*

The *information-preserving-round-trip* invariant. For remote
formulas, the node number is preserved through both operations.
The discipline ensures *internal storage is canonical* — two
agents on the same daemon both store *the same internal id* for
the same remote formula, regardless of whose key was in the
incoming locator.

## The §nine-method taxonomy

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

## The §LOCAL_NODE sentinel — *safe-by-impossibility-in-the-domain*

The §LOCAL_NODE section makes the sentinel's safety argument
explicit:

```js
const LOCAL_NODE = '0'.repeat(64);
```

*All-zeros is never a valid Ed25519 public key, making it a safe
sentinel for "this daemon".*

The §safe-by-impossibility-in-the-domain discipline: the sentinel
value is *not* a tagged or namespaced value — it's a *value that
the domain itself rules out*. Ed25519 public keys are derived
from random scalars; the probability of any specific public key
being all-zeros is *cryptographically negligible*. The sentinel
is safe *because the domain's structure prevents collision*, not
because of a separate marker bit.

Cycle 51's `daemon-agent-network-identity` (already ingested as
§dani section) named this as the *origin of the LOCAL_NODE
sentinel and the `0.0.0.0`-as-this-host analogy*. This design
codifies the sentinel's *operational* role: the daemon maintains
a `localKeys` set + `isLocalKey(node)` predicate; *any key in
this set* normalizes to `LOCAL_NODE` on internalization.

## The §parseLocator validation discipline

The §Locator Validation section names the *strict* validation
rules for standard locators:

- Protocol must be `endo://`
- Node (hostname) must be a valid 64-char hex string
- Required parameters: `id` (formula number) and `type` (formula
  type)
- Allowed parameters: `id`, `type`, `at`
- *Any other parameter causes validation failure*

The §reject-unknown-parameters discipline is the strict-parser
default. The §invitation-locators-bypass clause names the
exception: invitation locators have a `from` parameter that
`parseLocator` *would reject* — so they go through the separate
invitation-acceptance code paths in `daemon.js` and `host.js`.

The §strict-parser-with-known-exceptions pattern lets the
canonical parser stay narrow without preventing the broader
protocol from carrying extension parameters.

## The §connection-hints-are-ephemeral discipline

The §Connection Hints and Peer Info section names the *transport-
addresses-are-ephemeral* discipline:

> *Connection hints (`at` parameters) are ephemeral transport
> addresses.*
>
> *1. The formula identifier is extracted and stored durably*
> *2. The hints are forwarded to the peer info system via
>    `addPeerInfo`*
> *3. Hints are not stored with the formula — they are looked up
>    fresh when producing a locator for sharing*
>
> *When producing a locator for sharing (`locate`), the current
> hints for the peer are fetched from the network layer and
> appended as `at` parameters.*

The §hints-stored-separately-from-formula-identity discipline:
the *identity* of the formula (who, which one, what kind) is
durable; the *transport hints* are *replaceable*. When sharing a
locator, the system *looks up fresh hints* — it doesn't
*re-share old hints*.

This is the §addressing-is-not-identity discipline: peer A's
network address may change (Wi-Fi vs cellular vs Tor), but A's
public key doesn't. Locators carry the durable identity in
parameters that *don't change* (`nodeNumber`, `id`, `type`); the
ephemeral parameters (`at`) carry the *currently-reachable*
addresses.

## The §eight-file index

The §Files table names where each piece of locator machinery
lives:

| File | Key exports |
|------|-------------|
| `locator.js` | `parseLocator`, `formatLocator`, `formatLocatorForSharing`, `externalizeId`, `internalizeLocator`, `idFromLocator`, `addressesFromLocator`, `LOCAL_NODE` |
| `formula-identifier.js` | `parseId`, `formatId`, `isValidNumber` |
| `formula-type.js` | `isValidFormulaType`, `assertValidFormulaType` |
| `directory.js` | `makeDirectoryMaker` (provides `locate`, `writeLocator`, etc.) |
| `host.js` | `makeHostMaker` (carries up directory methods) |
| `guest.js` | `makeGuestMaker` (carries up directory methods) |
| `mail.js` | `makeMailboxMaker` (externalizes message identifiers to locators) |
| `daemon.js` | `makeInvitation` (constructs invitation locators) |

The §three-layered-decomposition: *parsing/formatting primitives*
(locator.js, formula-identifier.js, formula-type.js) →
*directory-level method-providers* (directory.js) →
*host/guest method-carriers* (host.js, guest.js, mail.js) →
*invitation-specific construction* (daemon.js).

## How this file relates to cycle 49 / 51 / 60

The locator-design cluster across cycles:

- **cycle 49** — `daemon-locator-terminology` (a rename design;
  Node Number → Peer Key, Formula Number → Formula Address,
  Formula Identifier → Formula Key; bridging-via-type-aliases
  discipline)
- **cycle 51** — `daemon-agent-network-identity` (the
  per-agent-NETS + LOCAL_NODE sentinel origin)
- **cycle 60** — `daemon-256-bit-identifiers` (256-bit identifier
  migration; Ed25519 public key as node ID; CryptoPowers
  interface)
- **cycle 135 (this cycle)** — `daemon-locator-reference` (the
  concrete URL format spec)

The four designs cover the locator topology: cycle 60 set the
*256-bit-identifier* width; cycle 51 introduced the
*LOCAL_NODE* sentinel and per-agent NETS; cycle 49 ratified the
*terminology* across types; this cycle is the *concrete spec*
that ties the rest together.

## Related sections

- cycle 49 (§dlt-terminology-rename)
  [[endo-but-for-bots--llm-designs-dlt--terminology-rename]]
  — the *rename* design that this reference document follows
  (Node Number → Peer Key, etc.); *Strict invariant — no
  existing method signatures change*; *Bridging-via-type-aliases
  discipline*.
- cycle 51 (§dani-per-agent-networks-and-NETS)
  [[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]
  — the origin of the LOCAL_NODE sentinel and the
  `0.0.0.0`-as-this-host analogy.
- cycle 60 (§d256-per-agent-keypairs)
  [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]
  — the 256-bit identifier migration; Ed25519 public key as
  node ID; CryptoPowers interface that establishes the keys this
  locator format encodes.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-as-message-router design that uses these locators
  on the wire; the envelope protocol carries locator-tagged
  capabilities.
