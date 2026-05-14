# Topics

Concept-keyed taxonomy of the library's section files. An agent looking for material on a concept arrives here, scans the abstracts, and follows the matching topic page to its section table. Each topic page lists the sections currently filed under it with a one-line abstract per row.

The taxonomy below is the **seed** from the pilot ingestion (2026-05-13). It will grow and refactor as the corpus expands. The `conventions.md` document on `journal/library/` describes when to add a new topic, when to split, and when to merge.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [agent-conventions](agent-conventions.md) | Repository-specific instructions written for AI agents working in a project. | 7 |
| [repository-governance](repository-governance.md) | Contribution rules, security policy, commit conventions, repository structure. | 6 |
| [typescript-conventions](typescript-conventions.md) | TypeScript rules in a `.js`-runtime + `.ts`-consumer repository. | 2 |
| [exo](exo.md) | The Exo class API: `makeExo`, `defineExoClass`, `defineExoClassKit`. | 14 |
| [testing](testing.md) | How to run and write tests in endo. | 1 |
| [security-disclosure](security-disclosure.md) | Vulnerability reporting channels and timelines. | 4 |
| [errors](errors.md) | SES's tamed `Error` + `assert` + causal `console` system. | 13 |
| [hardened-javascript](hardened-javascript.md) | SES substrate: frozen intrinsics, lockdown, taming. | 23 |
| [capability-security](capability-security.md) | Object-capability discipline as practiced in Endo / Agoric. | 9 |
| [compartments](compartments.md) | SES compartments: isolated guest-code subtrees in a realm. | 5 |
| [eventual-send](eventual-send.md) | `E()` and `E.when` for messaging local or remote objects. | 4 |
| [captp](captp.md) | Capability Transport Protocol: cross-process eventual-send. | 4 |
| [ocapn](ocapn.md) | The OCapN protocol family: CapTP + marshal + transports. | 1 |
| [marshal](marshal.md) | Pass-style serialization layer; smallcaps wire format. | 8 |
| [pass-style](pass-style.md) | Marshal's classification system for how values cross a serialization boundary. | 20 |
| [daemon](daemon.md) | The Endo daemon: per-user persistent host for HardenedJS workers. | 2 |
| [patterns](patterns.md) | The @endo/patterns shape-matching language; method guards. | 12 |
| [getting-started](getting-started.md) | The on-ramp into Endo: install, first encounters, confinement walk-through. | 6 |
| [tooling](tooling.md) | Endo's developer-facing tooling and assorted single-purpose packages. | 1 |

## Seed-but-not-yet-populated topics

The taxonomy in `conventions.md` lists additional topics expected to fill in as more of the endo corpus is ingested:

- `bundles`: bundle-source, compartment-mapper, import-bundle, module-source.
- `streams`: stream, stream-node, async iteration.

These will appear when the next ingestion batches (the flagship package READMEs queued in the inbox) create sections that file under them.
