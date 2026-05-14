# Topics

Concept-keyed taxonomy of the library's section files. An agent looking for material on a concept arrives here, scans the abstracts, and follows the matching topic page to its section table. Each topic page lists the sections currently filed under it with a one-line abstract per row.

The taxonomy below is the **seed** from the pilot ingestion (2026-05-13). It will grow and refactor as the corpus expands. The `conventions.md` document on `journal/library/` describes when to add a new topic, when to split, and when to merge.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [agent-conventions](agent-conventions.md) | Repository-specific instructions written for AI agents working in a project. | 7 |
| [repository-governance](repository-governance.md) | Contribution rules, security policy, commit conventions, repository structure. | 5 |
| [typescript-conventions](typescript-conventions.md) | TypeScript rules in a `.js`-runtime + `.ts`-consumer repository. | 2 |
| [exo](exo.md) | The Exo class API: `makeExo`, `defineExoClass`, `defineExoClassKit`. | 1 |
| [testing](testing.md) | How to run and write tests in endo. | 1 |
| [security-disclosure](security-disclosure.md) | Vulnerability reporting channels and timelines. | 4 |
| [errors](errors.md) | SES's tamed `Error` + `assert` + causal `console` system. | 13 |
| [hardened-javascript](hardened-javascript.md) | SES substrate: frozen intrinsics, lockdown, taming. | 20 |
| [capability-security](capability-security.md) | Object-capability discipline as practiced in Endo / Agoric. | 1 |
| [compartments](compartments.md) | SES compartments: isolated guest-code subtrees in a realm. | 3 |
| [eventual-send](eventual-send.md) | `E()` and `E.when` for messaging local or remote objects. | 2 |
| [captp](captp.md) | Capability Transport Protocol: cross-process eventual-send. | 1 |
| [marshal](marshal.md) | Pass-style serialization layer; smallcaps wire format. | 1 |

## Seed-but-not-yet-populated topics

The taxonomy in `conventions.md` lists topics expected to fill in as more of the endo corpus is ingested. They are not yet present here because the pilot batch (`AGENTS.md`, `docs/security.md`, `docs/errors.md`) did not exercise them:

- `ocapn`: OCapN protocol family (netstring, noise, codecs).
- `patterns`: shape matching, kind kinds.
- `bundles`: bundle-source, compartment-mapper, import-bundle, module-source.
- `daemon`: endo daemon, capability bank, process model.
- `streams`: stream, stream-node, async iteration.
- `tooling`: where, zip, lp32, base64, hex, cjs-module-analyzer, eslint-plugin.
- `getting-started`: tutorials, install, first-steps.

These will appear when the next ingestion batch (likely the package READMEs and `/docs/get-started.md`) creates sections that file under them.
