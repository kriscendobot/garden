---
title: "endoclaw-skill-registry — §no-new-abstractions + §capability-declaration-via-directory-structure + §decentralized-by-default + §no-ambient-authority + §federation-by-reference + §named-Endo-Idiom-section"
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-skill-registry — Skills Directory built on EndoDirectory

A 252-line **Not Started** design (created and updated 2026-03-03). §Parent-design: [endoclaw](endoclaw.md). The most structurally interesting move: §the-design-introduces-no-new-abstractions — a skill registry is *just an EndoDirectory*. The §named-Endo-Idiom-section enumerates the five disciplines that fall out of that choice.

## §The-Parent-link in frontmatter

```
| **Parent** | [endoclaw](endoclaw.md) |
```

§Parent-pointer-as-explicit-frontmatter-field. §Sibling to:
- Cycle 216 lal-transcript-memory-management's §Predecessor-section (parent-child via narrative section heading).
- Cycle 218 familiar-chat-weblet-hosting's §sibling-Ready-in-two-part-Status (peer relationship).
- Cycle 220 familiar-localhttp-protocol's §three-state-Status + §design-deviations (the inverse: this is the parent referenced by another design's two-part-Status).
- Cycle 222 endoclaw-skill-registry's §Parent-frontmatter-field (parent-child via metadata).

§Four-different-shapes-for-naming-design-relationships in 2026-06 cluster (216 narrative + 218 status + 220 inverse + 222 metadata).

§Twentieth-honest-design-evolution-record family member with §a-new-shape: §parent-pointer-as-explicit-frontmatter-field.

## §The-no-new-abstractions discipline

The §Endo-Idiom section opens with the load-bearing principle:

> **No new abstractions.** The registry is an EndoDirectory. Skill descriptors are EndoDirectories. Metadata entries are string values stored via `write`. Everything uses the existing pet-name storage system — `list`, `lookup`, `write`, `followNameChanges`.

§The-three-recursive-levels: registry = directory + descriptors = directories + metadata = string values. §Borrowable-pattern: §when-a-feature-could-be-its-own-system, §see-if-it-fits-inside-an-existing-primitive-instead. §The-design-rejects-inventing-a-skill-format + §reuses-the-pet-name-storage-shape.

§Three-cycles-with-no-new-abstractions discipline now in library:
- Cycle 211 @endo/common (§tree-shaking-friendly via §one-file-per-export — no new build system, just convention).
- Cycle 214 lal-reply-chain-transcripts (§no-daemon-changes-required — leverages existing API).
- Cycle 222 endoclaw-skill-registry (§the-registry-IS-the-directory).

§Three-different-substrates-where-the-discipline-applies (package shape / agent loop / capability storage). §The-discipline-is-the-same-across-substrates.

## §The-three-recursive-EndoDirectory-levels

```
skills/                            (EndoDirectory)
├── gmail-bridge                   → skill descriptor
├── telegram-bridge                → skill descriptor
└── ...

gmail-bridge/                      (EndoDirectory — skill descriptor)
├── code                           → guest module (installable bundle)
├── description                    → string value
├── requires                       → directory of capability declarations
│   ├── oauth                      → string value: "gmail"
│   └── network-fetch              → string value: "https://gmail.googleapis.com"
├── version                        → string value
├── author                         → string value
└── homepage                       → string value
```

§Three-recursive-levels: registry (a directory of descriptors) → descriptor (a directory of metadata) → requires (a directory of capability declarations). §Each-level-is-the-same-shape (EndoDirectory) but §with-a-different-meaning.

§Borrowable-pattern: §uniform-shape-with-recursive-nesting — the same primitive (directory + string-value) suffices at every level. §Recursive-nesting-with-uniform-semantics; §you-don't-need-to-learn-three-vocabularies-because-everything-uses-the-same-three-operations (list / lookup / write).

§Sibling to cycle 211 @endo/common's §tree-shaking-friendly (uniform shape with file-per-export); §different-substrates-same-discipline.

## §Capability-declaration-via-directory-structure

```
gmail-bridge/
└── requires                       → directory
    ├── oauth                      → string value: "gmail"
    └── network-fetch              → string value: "https://gmail.googleapis.com"
```

§Capabilities-are-pet-name-entries-with-string-scope-hints. §Inspectable-with-the-same-tools — `endo list skills gmail-bridge requires` works because `requires` is just another directory.

§Borrowable-pattern: §encode-structured-metadata-as-directory-structure + §don't-invent-a-new-metadata-format. §The-directory-IS-the-schema. §No-JSON-schema-needed; §no-YAML-parser-needed; §the-existing-tooling-already-knows-how-to-walk-it.

§Sibling to cycle 197 panic's §registered-symbol-as-emulated-private-state (different mechanism, same §use-the-existing-primitive-rather-than-invent-a-new-one discipline).

## §No-ambient-authority

> Installing a skill from the registry creates a confined guest. The skill receives only explicitly granted capabilities. The `requires` directory informs the host's grant decision but does not automatically provision capabilities.

§The-requires-section-is-advisory-not-authoritative. §Borrowable-pattern: §the-application-declares-its-needs + §the-host-decides-what-to-grant. §The-host-is-the-authority + §the-application-is-the-petitioner.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §power-levels-as-selectable-options (NONE / @endo / @host / Custom) and cycle 208 familiar-bundled-agents' §The-Powers-Problem-with-three-option-analysis. §Three-cycles-on-the-host-grants-capabilities-application-doesn't-take-them discipline.

§Borrowable-pattern: §when-an-installable-application-declares-capability-requirements, §those-requirements-MUST-be-advisory + §the-host-MUST-explicitly-grant.

## §Five-step-CLI-installation composing existing verbs

```bash
endo list skills                                 # Browse
endo list skills gmail-bridge requires           # Inspect
endo adopt skills gmail-bridge code gmail-bridge-code  # Adopt
endo install gmail-bridge-code --name gmail-bridge     # Install
endo grant gmail-bridge oauth my-gmail-oauth     # Grant
endo grant gmail-bridge network-fetch gmail-http
```

§No-new-verbs — every step uses an existing CLI verb (list / adopt / install / grant). §Borrowable-pattern: §the-design-of-a-new-feature-is-a-composition-of-existing-verbs, §not-an-introduction-of-new-ones.

§Plus-an-optional-convenience-wrapper: `endo hub install gmail-bridge --from skills` — §single-command-encapsulating-the-five-steps + §interactive-confirmation-prompt with the description + requires + `Install and grant? [y/N]`.

§Two-shapes-for-the-same-operation: §explicit-five-step-flow + §single-convenience-command. §Borrowable-pattern: §provide-the-explicit-flow-and-the-convenience-wrapper; §the-explicit-flow-teaches-the-shape + §the-convenience-wrapper-makes-it-easy.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §every-UI-action-also-has-a-command — same §three-surfaces-for-the-same-action discipline.

## §Decentralized-by-default

> Any agent can create a registry directory and share it. There is no central authority. The built-in `skills` is a convenience, not a gatekeeper. Users can `endo install` from any source without going through a registry.

§The-built-in-registry-is-convenience-not-authority. §Borrowable-pattern: §when-shipping-a-built-in-registry-or-catalog, §name-it-as-convenience-not-gatekeeper. §The-built-in-registry-MUST-NOT-be-the-only-path; §users-MUST-be-able-to-bypass-it.

§Sibling to cycle 200 worker-rust-xs's §retention-path-notation (any path can be a reference; no central registry needed) and cycle 220 familiar-localhttp-protocol's §per-weblet-origin-isolation (each weblet has its own origin; no central origin).

§Three-cycles-on-decentralized-by-default discipline.

## §Federation-by-reference

Because registries are just directories, §federation-is-natural:

- §Multiple-registries-under-different-pet-names (`skills`, `community-hub`, `company-hub`) — §the-host-curates-its-own-set.
- §Cross-agent-references via the formula system — §any-registry-can-include-entries-from-another-registry-by-writing-their-formula-identifiers.
- §Curated-registry-via-copy — §a-curated-registry-can-`copy`-entries-from-an-upstream-registry, §creating-a-filtered-view.

§Borrowable-pattern: §federation-by-reference rather than §federation-by-protocol. §The-formula-system-is-the-cross-registry-reference-mechanism; §no-new-federation-protocol-needed.

§Three-named-federation-patterns: §multiple-roots + §cross-reference + §filtered-view-via-copy. §Each-pattern-uses-the-existing-primitives.

## §Live-discovery via followNameChanges

```js
const changes = E(registry).followNameChanges();
for await (const change of changes) {
  if ('add' in change) { /* new skill */ }
  if ('remove' in change) { /* skill removed */ }
}
```

§The-same-mechanism-the-Chat-UI-uses-to-watch-inbox-changes. §Borrowable-pattern: §when-an-existing-primitive-already-provides-event-streaming, §use-it-everywhere — §don't-introduce-a-second-event-mechanism.

§Sibling to cycle 213 stream-node's §self-referential-asyncIterator (the §unified-iterator-shape across stream contexts).

## §Two-named-change-events: §add + §remove

`if ('add' in change) ... if ('remove' in change) ...`

§Discriminated-union-on-key-presence. §Borrowable-pattern: §discriminated-union-via-key-presence-not-discriminator-string — the consumer checks `'add' in change` not `change.kind === 'add'`. §This-is-rare-and-load-bearing: §if-the-format-grows-a-third-event-the-existing-handlers-skip-it-rather-than-falling-into-a-default-case.

## §Built-in-registry as Specials-mechanism

§Built-in `skills` registry §uses-the-same-Specials-mechanism-as-`@apps`, `@lal`, `@fae`. §Borrowable-pattern: §pre-existing-bundled-resources-flow-through-the-same-substrate-as-user-created-resources. §The-pre-existing-and-user-created-resources-look-identical-from-the-API.

## §Publishing-flow as §send-to-registry-operator

```bash
# Author creates descriptor
endo make-directory gmail-bridge-descriptor

# Populate metadata
endo store "Read and manage Gmail via OAuth" --name description-text
endo write gmail-bridge-descriptor description description-text
# ... (more population) ...

# Send to registry operator for review
endo send registry-operator "Please list gmail-bridge" \
  --attach gmail-bridge-descriptor:gmail-bridge-descriptor

# Registry operator reviews and adds
endo adopt <message> gmail-bridge-descriptor submitted-gmail-bridge
endo write skills gmail-bridge submitted-gmail-bridge
```

§The-publishing-flow-is-a-mail-message-with-attachment. §Borrowable-pattern: §publishing-as-a-mail-message-not-an-RPC. §The-registry-operator-receives-the-descriptor-as-an-Endo-message + §reviews-it + §adds-it. §No-special-publish-API-needed.

§Two-actors-with-different-roles: §author (creates and sends) + §operator (receives and adds). §The-mail-message-is-the-handoff-point.

## §The-Depends-On section as §four-named-existing-implementations

```
- EndoDirectory (packages/daemon/src/directory.js) — already implemented
- Guest plugin infrastructure (endo install) — already implemented
- String value storage (endo store) — already implemented
- Capability categories being defined enough for meaningful `requires` entries
```

§Three-already-implemented + §one-not-yet-precondition. §Borrowable-pattern: §the-Depends-On-section-with-status-per-dependency. §The-three-already-implemented-bullets-are-load-bearing-because-they-prove-the-no-new-abstractions-claim; §the-one-precondition-bullet-is-the-only-remaining-gating-question.

§Different-from cycle 220's §implementation-status-per-affected-package — cycle 220 tracks the implementation status of *this design's* packages; cycle 222 tracks the implementation status of the *dependencies* this design needs.

## §The-five-named-Endo-Idiom-disciplines

The §Endo-Idiom section names five disciplines:

1. **§No-new-abstractions** — the registry, descriptors, and metadata all reuse EndoDirectory.
2. **§Capability-declaration-via-directory-structure** — `requires/` subdirectory enumerates needs as pet-name entries.
3. **§Decentralized-by-default** — any agent can create a registry; no central authority.
4. **§No-ambient-authority** — installing creates a confined guest; requires informs grant decisions but doesn't auto-provision.
5. **§Live-discovery** — `followNameChanges` for real-time notification without polling.

§Borrowable-pattern: §a-named-Idiom-section-listing-the-design-principles-that-emerge-from-the-substrate-choice. §The-principles-aren't-imposed-from-outside; §they-fall-out-of-using-the-existing-primitives. §Borrowable-shape: §when-a-design-fits-into-an-existing-substrate, §write-the-Idiom-section-that-names-which-principles-emerge.

§Sibling to cycle 212 outliner-design-doc's §what-it-gains-vs-loses-with-pragmatic-substitute. §Different-rhetorical-shape but §same-purpose (name-the-design-philosophy-that-emerges-from-the-substrate-choice).

## §Twentieth-honest-design-evolution-record family member

§A-new-shape: §parent-pointer-as-explicit-frontmatter-field. The 2026-06 cluster now has §five-different-shapes-of-design-evolution-record:

| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose ("This is getting complex. Let's simplify:") |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section heading |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section recording divergence between design and implementation |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |

§Five-different-shapes-for-naming-design-relationships in the 2026-06 cluster.

## Related material in the library

- **endoclaw** (the parent design, not yet ingested): §the-design-this-is-a-component-of.
- **cycle 211 @endo/common**: §no-new-abstractions via tree-shaking-friendly file-per-export sibling.
- **cycle 214 lal-reply-chain-transcripts**: §no-daemon-changes-required sibling.
- **cycle 208 familiar-bundled-agents**: §The-Powers-Problem-with-three-option-analysis sibling — both designs grapple with §how-much-authority-to-grant-an-installed-application.
- **cycle 218 familiar-chat-weblet-hosting**: §power-levels-as-selectable-options sibling; §every-UI-action-also-has-a-command sibling (this design has both explicit-five-step-flow and convenience-wrapper).
- **cycle 220 familiar-localhttp-protocol**: §per-weblet-origin-isolation sibling — both designs decentralize a previously-centralized concept.
- **cycle 200 worker-rust-xs**: §retention-path-notation sibling (decentralization-by-reference).
- **cycle 213 stream-node**: §followNameChanges-as-unified-event-stream sibling.
- **cycle 197 panic**: §use-the-existing-primitive-rather-than-invent-a-new-one sibling.
- **cycle 212 outliner-design-doc**: §what-it-gains-vs-loses-with-pragmatic-substitute sibling (different-rhetorical-shape, same purpose).
- **cycle 216 lal-transcript-memory-management**: §Predecessor-section sibling; §inherit-don't-redescribe sibling.

## §Library-reaches-728-sections at cycle 222 (designs-lane endoclaw-skill-registry).

## §Fifty-sixth consecutive designs-chat alternation cycles 166-222.
