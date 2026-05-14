# Topic: spec-to-implementation

> Abstract: A concordance mapping the upstream OCapN protocol spec sections to their Endo realizations. Built up across cycles 16-20 as the scholar ingested all 5 OCapN draft specifications. This page is a cross-cutting index for an agent wondering "where is this spec'd concept implemented in Endo?" or "which spec section governs this Endo behavior?". Distinct from the per-topic pages (which cluster by concept) and from the per-source pages (which cluster by document).

## How to use

For each row, the spec section names the wire-level requirement; the Endo realization is the JavaScript implementation. The mapping is sometimes 1:1, sometimes 1:N (one spec concept realized across multiple Endo packages), and sometimes incomplete (a spec section without a current Endo counterpart). The "Notes" column flags semantic differences, known mismatches, or implementation status.

## Value model (Model.md)

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [Model overview](../sections/ocapn--draft-specifications-model--overview.md) | [pass-style topic](pass-style.md) overall | Direct overlap: every OCapN model atom maps to a pass-style. |
| [Atom types](../sections/ocapn--draft-specifications-model--atom-types.md) | [pass-styles enumeration](../sections/endo--pkg-pass-style-readme--pass-styles.md) | OCapN splits Integer + Float64; Endo merges into JS number + bigint. |
| [Container: List](../sections/ocapn--draft-specifications-model--container-list.md) | [copyArray guarantees](../sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md) | Direct match. |
| [Container: Struct](../sections/ocapn--draft-specifications-model--container-struct.md) | [copyRecord guarantees](../sections/endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md) | **Key-type mismatch**: OCapN Struct keys are Symbols; copyRecord keys are strings. |
| [Container: Tagged](../sections/ocapn--draft-specifications-model--container-tagged.md) | [makeTagged](../sections/endo--pkg-pass-style-readme--maketagged.md) | Direct match. |
| [Reference: Target](../sections/ocapn--draft-specifications-model--reference-target.md) | [pass-by-presence](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md), [convertValToSlot](../sections/endo--pkg-marshal-readme--convert-val-slot.md) | Endo's slot-bridge callbacks realize the spec's identity rules. |
| [Reference: Promise](../sections/ocapn--draft-specifications-model--reference-promise.md) | [HandledPromise](../sections/endo--pkg-eventual-send-readme--handled-promise.md), [E.when](../sections/endo--pkg-eventual-send-readme--e-when.md) | Wire-level promise semantics realized via HandledPromise. |
| [Error](../sections/ocapn--draft-specifications-model--error.md) | [errors topic](errors.md); [distributed diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | Endo's distributed-error plans extend the spec's wire shape with identifier correlation. |
| [Pass Invariant](../sections/ocapn--draft-specifications-model--pass-invariant.md) | [copyArray-guarantees](../sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md), [frozen-objects-only](../sections/endo--pkg-marshal-readme--frozen-objects-only.md) | Round-trip stability is enforced in marshal's harden() requirement. |
| [JSON Invariants](../sections/ocapn--draft-specifications-model--json-invariants.md) | [smallcaps beyond-JSON](../sections/endo--pkg-marshal-readme--beyond-json.md), [smallcaps cheatsheet](../sections/endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) | Smallcaps extends JSON with the prefix-encoded extensions this spec requires. |

## Notation (Notation.md)

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [Notation overview + meta](../sections/ocapn--draft-specifications-notation--overview.md) | (no direct counterpart) | Notation is spec-side syntax; no Endo realization. |
| [Value and atoms notation](../sections/ocapn--draft-specifications-notation--value-and-atoms.md) | [pass-style README](../sections/endo--pkg-pass-style-readme--pass-styles.md) | Parallel coverage of the same value types at different abstraction levels. |
| [Containers notation](../sections/ocapn--draft-specifications-notation--containers.md) | (none) | **Record/Tagged mismatch** with Model.md (Notation has Record; Model has Tagged). Worth flagging upstream. |

## Locators (Locators.md)

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [peer-locator](../sections/ocapn--draft-specifications-locators--peer-locator.md) | `@endo/syrups` + `@endo/syrup-frame` packages (not yet ingested) | Syrup serialization referenced; Endo packages implement it. |
| [sturdyref-locator](../sections/ocapn--draft-specifications-locators--sturdyref-locator.md) | [durable-exo make-vs-prepare](../sections/endo--pkg-exo-docs-exo-taxonomy--make-vs-prepare.md), [virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | Sturdyrefs are the wire-level basis for durable-exo serialization. |

## Netlayers (Netlayers.md)

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [Netlayer introduction](../sections/ocapn--draft-specifications-netlayers--introduction.md) | `@endo/netstring` (framing) + `@endo/stream` / `@endo/stream-node` (transport) + noise-protocol netlayer (integrity+conf) | The Endo realization is split across 3+ packages. |
| [Tor Onion netlayer](../sections/ocapn--draft-specifications-netlayers--tor-onion-netlayer.md) | (none current) | Endo does not yet ship a Tor netlayer implementation. |

## CapTP (CapTP Specification.md)

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [CapTP overview](../sections/ocapn--draft-specifications-captp--captp-overview.md) | [@endo/captp Usage](../sections/endo--pkg-captp-readme--usage.md) | The spec's sessions/messages/ending maps to makeCapTP's dispatch/getBootstrap/abort. |
| [Promises](../sections/ocapn--draft-specifications-captp--promises.md) | [HandledPromise](../sections/endo--pkg-eventual-send-readme--handled-promise.md), [Promise Pipelining](../sections/endo--pkg-eventual-send-readme--promise-pipelining.md) | Wire-level spec matches the JS-level implementation. |
| [Cryptography](../sections/ocapn--draft-specifications-captp--cryptography.md) | (no direct Endo realization yet) | Spec-only; Endo's CapTP implementation does not yet ship the cryptographic primitives. |
| [Third Party Handoffs](../sections/ocapn--draft-specifications-captp--third-party-handoffs.md) | (no direct realization) | Spec-only; the application-level pattern in Endo achieves the same outcome differently. |
| [bootstrap-object](../sections/ocapn--draft-specifications-captp--bootstrap-object.md) | [@endo/captp Usage](../sections/endo--pkg-captp-readme--usage.md), [@endo/daemon](../sections/endo--pkg-daemon-readme--overview.md) | makeCapTP's getBootstrap returns this object; daemon's user-agent is the durable case. |
| [Operations](../sections/ocapn--draft-specifications-captp--operations.md) | Implemented inside `@endo/captp` (no per-op Endo section) | Wire-protocol only; not application-visible. |
| [Descriptors](../sections/ocapn--draft-specifications-captp--descriptors.md) | Implemented inside `@endo/captp` (no per-desc Endo section) | Wire-protocol only; the desc:sig-envelope shape is what `Cryptography` cryptographic primitives populate. |

## OCapN README

| Spec section | Endo realization | Notes |
|--------------|------------------|-------|
| [What is this?](../sections/ocapn--readme--overview-and-what-is-this.md) | [endo top-level README](../sections/endo--readme--overview.md) | The two project READMEs map their distinct framings of the same family. |
| [History](../sections/ocapn--readme--history.md) | [hardenedjs-story](../sections/endo--docs-guide--hardenedjs-story.md) | Both trace E and earlier ocap lineage; complementary perspectives. |

## Known disagreements (re-stated)

These were surfaced during ingestion and remain unresolved:

1. **Integer/Float64 split**: OCapN distinguishes; Endo merges into JS number + bigint.
2. **Struct key types**: OCapN uses Symbols; pass-style copyRecord uses strings.
3. **Record vs Tagged terminology**: Notation.md uses Record; Model.md uses Tagged; possible spec inconsistency.
4. **Promise resolution wire-level**: OCapN spec covers fulfilled/rejected/resolved-to-remote; Endo's HandledPromise matches in shape but specific wire-level details may differ.

A maintainer-led review pass could promote one or more of these to formal `message` entries for upstream attention.

## See also

- [`ocapn`](ocapn.md): the per-topic page for OCapN material.
- [`pass-style`](pass-style.md), [`marshal`](marshal.md): the Endo-side topics with the most overlap.
- [`captp`](captp.md): the cross-cutting protocol topic.
- [`conventions.md`](../conventions.md) § Soft-flag for cross-source overlap: the convention this concordance realizes.
