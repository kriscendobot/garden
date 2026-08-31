---
created: 2026-08-31
updated: 2026-08-31
author: gardener
---

# OCapN nonce locator backed by daemon formulas

The public OCapN service exposes the protocol bootstrap, not the Endo daemon
bootstrap. The protocol bootstrap is a nonce locator: a peer presents a daemon
formula identifier to `fetch` and receives only that formula's capability. A
peer that presents nothing receives no application capability. A peer that
presents an unavailable identifier receives one generic rejection.

This replaces the deployed fixed `endo-bootstrap` publication. It applies to
both `/.well-known/ocapn-cbor-np` and
`/.well-known/ocapn-syrup-np`. The former chooses CBOR and the latter chooses
Syrup before the Noise session begins. Neither route negotiates a codec.

## Protocol grounding

The upstream protocol snapshot at commit `b4dbd1a` supplies the wire shape:

- `draft-specifications/Locators.md` section "Sturdyref Locator" says a
  sturdyref contains a peer locator and a Swiss number naming a specific object,
  and that possession of this information is itself a capability. Its in-band
  record is `<ocapn-sturdyref peer swiss-num>` and its URI form is
  `ocapn://<designator>.<transport>/s/<swiss-num>` with optional hints.
- `draft-specifications/CapTP Specification.md` section "The bootstrap Object"
  requires export position `0` to be the protocol bootstrap. Its `fetch` method
  accepts a Swiss number and returns the corresponding object or an error. The
  same bootstrap also carries the protocol's `deposit-gift` and `withdraw-gift`
  methods for third-party handoff.

"Nonce locator" and "formula identifier" are Endo terms, not new protocol
records. On the wire this design uses the specified sturdyref and bootstrap
`fetch` shapes. The daemon formula identifier is the Swiss number.

The draft is inconsistent about the Swiss number's scalar representation:
`Locators.md` calls it a string while the CapTP `fetch` section calls it Binary
Data. Endo already resolves that inconsistency at the codec boundary with
`SwissNum` bytes and encodes printable names with `encodeSwissnum`. This design
chooses the canonical ASCII bytes of `FormulaIdentifier` as the on-wire Swiss
number. It does not introduce a third representation. URI producers render the
same ASCII identifier in the `/s/` segment with RFC 3986 escaping as needed;
in-band producers use the ordinary `ocapn-sturdyref` record. The draft does not
assign HTTP paths or negotiate a codec, so the two well-known paths above are
deployment choices.

## Formula-backed lookup

`@endo/ocapn` already accepts a caller-owned `locator` with an asynchronous
`get(secret)` operation. `@endo/daemon` already has the other half:
`assertValidId`, the local-node check, and `provide(id)`, which lazily reads and
incarnates a persisted formula. The Endo implementation adds one adapter between
them rather than publishing an application bootstrap under a fixed Swiss
number:

```js
const locator = makeFormulaNonceLocator({
  provideLocalFormula,
  localNodeNumber,
});

const get = async swissNum => {
  try {
    const id = decodeCanonicalFormulaId(swissNum);
    const value = await provideLocalFormula(id, localNodeNumber);
    assertOcapnTarget(value);
    return value;
  } catch {
    return undefined;
  }
};
```

The sketch expresses the boundary, not the final error plumbing. The adapter:

1. accepts only canonical ASCII formula identifiers;
2. rejects identifiers for another node instead of dialing a peer;
3. reads the local formula table and incarnates the formula through the daemon's
   existing `provide` path;
4. returns the resulting OCapN-exportable target; and
5. treats malformed, foreign, absent, collected, non-exportable, corrupt, and
   failed-to-incarnate formulas as the same miss.

A miss becomes the same broken `fetch` result in every case, with one stable
message such as `sturdyref unavailable`. It never echoes the identifier, formula
type, node, lookup stage, or underlying exception. Public logs and metrics are
aggregate only. They do not record the Swiss number or a stable hash of it.
Repeated misses are bounded per authenticated Noise peer and per connection;
crossing the bound aborts the session with the same generic reason.
`@endo/ocapn`'s bootstrap is constructed per session, but its injected locator
is currently shared. The implementation therefore adds a session-scoped miss
hook (given the authenticated remote designator) or an equivalent
`makeLocatorForSession` hook. The formula adapter remains shared; only counters
and the abort decision are session-scoped.

The service does not promise constant response time. Incarnating an arbitrary
formula may perform work, so equal latency is not achievable without changing
formula semantics. Its non-oracle guarantee is narrower and enforceable: a
failed presentation reveals only that the presentation yielded no capability.
It cannot distinguish malformed from unknown, revoked, collected, disallowed,
or temporarily broken identifiers. The 256-bit unguessable formula address is
the authority, while Noise authenticates and encrypts the transport. Noise
identity alone grants no daemon object.

## Returned authority

On success, `fetch` exports exactly the incarnation associated with the
presented formula identifier. It does not return `endoBootstrap`, `EndoHost`,
`EndoGreeter`, `Gateway`, a pet-name directory above that formula, or a wrapper
with a second lookup method. Ordinary OCapN export tables then keep the returned
reference alive for the session and retire it through the existing distributed
GC rules.

This is attenuation by designation. A guest-agent identifier returns that guest
agent. A handle identifier returns that handle. A formula for a narrower facet
returns that facet. The locator does not widen any of them. A holder of the root
formula identifier can obtain the root capability because possession of that
unguessable identifier is the authority to do so; no connection receives it
ambiently. Thus the protocol bootstrap is not a bootstrap in disguise: its only
daemon-specific operation is equality-free presentation of a bearer nonce.

The fixed names `endo-bootstrap` and `endo-peer-entry` are not accepted by the
public formula locator. They are guessable publications used by earlier
daemon-to-daemon experiments. Peer discovery and the signed agent-binding
protocol remain separate from formula presentation and must not reintroduce one
of those names on either public route.

## Two routes, one authority map

Both routes terminate WebSocket and Noise and inject the same formula locator:

| Route | OCapN codec | Encoding-specific behavior |
| --- | --- | --- |
| `/.well-known/ocapn-cbor-np` | canonical CBOR | Records use the OCapN CBOR record convention; the Swiss number is a CBOR byte string. |
| `/.well-known/ocapn-syrup-np` | canonical Syrup | Records use Syrup record syntax; the Swiss number is a Syrup byte string. |

Codec selection affects parsing, canonical bytes used by signed protocol
structures, and the advertised connection hint. It does not affect identifier
validation, lookup, miss behavior, rate limits, or the capability returned.
Because codec choice is out of band, the daemon runs a separately configured
OCapN endpoint for each route. Caddy routes each path to its matching loopback
listener. A client must use the location advertised for that route and must not
rewrite a CBOR location into a Syrup location by changing only the URL.

No legacy alias may bypass this rule. `/ocapn-daemon` and `/ocapn` either remain
contained or point to one of these nonce-locator endpoints. They never point to
the old fixed-bootstrap service after public cutover.

## Repository ownership

- `endojs/endo-but-for-bots` owns the reusable mechanism: the
  `@endo/daemon` formula-locator adapter, construction of CBOR and Syrup
  `makeOcapn` endpoints over Noise/WebSocket, opaque failure mapping, limits,
  and unit and integration tests. `@endo/ocapn` already supplies the protocol
  bootstrap and injected-locator seam; it changes only if the common adapter
  contract needs a small reusable hook.
- `kriscendobot/minion.town` owns deployment: pinned Endo build or image,
  loopback listeners, Caddy routes, the containment drop-in, deployment order,
  rollback, and live probes. It contains no formula-table lookup logic. The
  authenticated guest-identifier reveal may continue issuing a caller's own
  identifier, but it must return the daemon's canonical `FormulaIdentifier`
  byte-for-byte rather than a bare formula number or a second token. It is not
  part of OCapN authentication.

## Migration without a public bootstrap window

The existing public daemon route stays contained until the last step:

1. Land and test the Endo adapter and both codec endpoints. The test matrix must
   prove a valid guest formula fetch on CBOR and Syrup, generic failures for all
   miss classes, and refusal of the old fixed Swiss numbers.
2. Deploy both new endpoints on loopback ports while the Caddy containment
   override continues returning `404` for every public OCapN daemon path.
3. Prove direct loopback Noise sessions against both endpoints. Inspect export
   position `0`: it has only the protocol `fetch`, `deposit-gift`, and
   `withdraw-gift` behaviors plus standard introspection. Fetch a known guest
   formula and invoke only that guest's methods.
4. Land the durable minion.town service and Caddy configuration for both paths.
   Validate the Caddy configuration offline, but keep the containment override
   active. Point or contain every legacy alias in the same change.
5. Switch the hidden Caddy upstreams from the legacy fixed-bootstrap process to
   the new nonce-locator processes. Re-run the loopback tests through the exact
   upstream addresses. At this point rollback still means only switching a
   hidden backend.
6. Remove containment for both well-known routes in one deployment. Immediately
   run public CBOR and Syrup success and miss probes, confirm the fixed
   `endo-bootstrap` name fails, and confirm no alias reaches the legacy service.
7. Only after those probes pass, stop and remove the legacy fixed-bootstrap
   listener. Retain the ability to restore containment independently of the
   daemon processes.

Rollback always restores containment first, verifies public `404`, and only
then changes a backend or image. No rollback procedure ever republishes the full
daemon bootstrap.

## Acceptance tests

- Protocol fixtures encode and decode the specified
  `<ocapn-sturdyref peer swiss-num>` shape and deliver `fetch` to export
  position `0` for both codecs.
- A known local guest formula identifier returns the same guest capability on
  both routes; method introspection shows the guest surface, not host or gateway
  methods.
- Malformed ASCII, noncanonical form, foreign node, absent formula, collected
  formula, non-exportable value, and incarnation failure all produce the same
  peer-visible error class and text with no identifier. Aggregate counters may
  differ internally only by non-secret operational category.
- Connecting and completing Noise without calling `fetch` grants no application
  capability. Fetching `endo-bootstrap` and `endo-peer-entry` fails.
- Repeated misses trigger the documented per-peer/session bound without
  affecting a different authenticated peer holding a valid identifier.
- Production cutover evidence includes direct loopback and public WebSocket,
  Noise, codec, sturdyref-fetch, and method-invocation probes for both routes,
  plus public `404` evidence captured before containment is lifted.

## Considered and rejected

- **Publish the full Pet-Daemon bootstrap.** Rejected because connection plus
  Noise identity would convey ambient host authority.
- **Publish one attenuated application bootstrap.** Rejected because it creates
  a second authority namespace and cannot represent every formula capability.
- **Put the formula identifier in the WebSocket URL or Noise handshake.**
  Rejected because the protocol already specifies bootstrap `fetch` and the URL
  is more likely to leak through access logs.
- **Implement only CBOR first.** Rejected by the maintainer directive. The two
  codecs cut over together.
