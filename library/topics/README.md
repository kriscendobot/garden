# Topics

Concept-keyed taxonomy of the library's section files. An agent looking for material on a concept arrives here, scans the abstracts, and follows the matching topic page to its section table. Each topic page lists the sections currently filed under it with a one-line abstract per row.

The taxonomy below is the **seed** from the pilot ingestion (2026-05-13). It will grow and refactor as the corpus expands. The `conventions.md` document on `journal/library/` describes when to add a new topic, when to split, and when to merge.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [agent-conventions](agent-conventions.md) | Repository-specific instructions written for AI agents working in a project. | 15 |
| [repository-governance](repository-governance.md) | Contribution rules, security policy, commit conventions, repository structure. | 34 |
| [typescript-conventions](typescript-conventions.md) | TypeScript rules in a `.js`-runtime + `.ts`-consumer repository. | 12 |
| [exo](exo.md) | The Exo class API: `makeExo`, `defineExoClass`, `defineExoClassKit`. | 25 |
| [testing](testing.md) | How to run and write tests in endo. | 10 |
| [security-disclosure](security-disclosure.md) | Vulnerability reporting channels and timelines. | 9 |
| [errors](errors.md) | SES's tamed `Error` + `assert` + causal `console` system. | 18 |
| [hardened-javascript](hardened-javascript.md) | SES substrate: frozen intrinsics, lockdown, taming. | 77 |
| [capability-security](capability-security.md) | Object-capability discipline as practiced in Endo / Agoric. | 42 |
| [compartments](compartments.md) | SES compartments: isolated guest-code subtrees in a realm. | 22 |
| [eventual-send](eventual-send.md) | `E()` and `E.when` for messaging local or remote objects. | 38 |
| [captp](captp.md) | Capability Transport Protocol: cross-process eventual-send. | 35 |
| [ocapn](ocapn.md) | The OCapN protocol family: CapTP + marshal + transports. | 60 |
| [marshal](marshal.md) | Pass-style serialization layer; smallcaps wire format. | 43 |
| [streams](streams.md) | Async-iterator-based stream abstraction; transport substrate. | 5 |
| [pass-style](pass-style.md) | Marshal's classification system for how values cross a serialization boundary. | 39 |
| [daemon](daemon.md) | The Endo daemon: per-user persistent host for HardenedJS workers. | 4 |
| [patterns](patterns.md) | The @endo/patterns shape-matching language; method guards. | 19 |
| [getting-started](getting-started.md) | The on-ramp into Endo: install, first encounters, confinement walk-through. | 15 |
| [tooling](tooling.md) | Endo's developer-facing tooling and assorted single-purpose packages. | 41 |
| [bundles](bundles.md) | Module bundling, Compartment module loading, bundle-source / compartment-mapper family. | 24 |
| [spec-to-implementation](spec-to-implementation.md) | Cross-cutting concordance: OCapN spec sections ↔ Endo realizations. | (meta) |

## Seed-but-not-yet-populated topics

The taxonomy in `conventions.md` lists additional topics expected to fill in as more of the endo corpus is ingested:

(no remaining seed-but-empty topics — streams is now populated by the stream + stream-node ingestion)

These will appear when the next ingestion batches (the flagship package READMEs queued in the inbox) create sections that file under them.
