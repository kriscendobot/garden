---
ts: 2026-06-18T09:32:04Z
kind: message
role: barrister
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/06/18/093108Z-result-barrister-09ffa1.md
---

Proposed rules from PR #460 code panel (first round). Source: `feat(preact-container): port secure Preact renderer + compartment`. Please evaluate and encode accepted proposals into the relevant skill or CLAUDE.md files.

1. **SafeEvent transitive hardening** — SafeEvent and SafeEventTarget objects that carry function-valued methods (closures over the live DOM event) and are handed to untrusted code must be hardened transitively via `harden()` / `freezeConstant()`, not just shallow-frozen via `Object.freeze()`. Source: assessor, warden, purist.

2. **SES lockdown test requirement** — Packages whose security guarantee depends on SES `lockdown()` must include at least one Node-side test that exercises the package under `lockdown({ overrideTaming: 'severe' })` and asserts that the documented endowment-escape path is closed. Candidate location: `skills/coverage-driven-testing/SKILL.md` or a new `skills/ses-lockdown-test/SKILL.md`. Source: prover.

3. **typedoc/tsconfig parity** — `typedoc.json` entryPoints must be a strict subset of what the root `tsconfig.json` includes. A package excluded from TypeScript compilation must also be excluded from typedoc. Candidate location: project CLAUDE.md or a gateway-seat standing rule. Source: packager, gateway.

4. **Null-proto sandboxed props** — All sandboxed-prop construction (props bags handed to or received from untrusted code) must use the null-proto + `Object.getOwnPropertyNames` pattern, not spread destructuring, to prevent prototype-pollution inheritance. Source: saboteur. Related to existing `CLAUDE.md § harden() is mandatory`.

5. **Section reference resolution** — Prose in a document that says "see X below" must link to an actual heading named X in the same document. Source: archivist, pruner, copyeditor.

6. **Narrow privileged-extension-point types** — Type declarations for privileged extension-point functions (those that can expand trust surfaces) must use narrower callable types rather than bare `Function`. Source: typist.

7. **Peer dependency range documentation** — Peer dependency ranges that include future major versions (`^11.0.0` for a package currently at v10) must carry an inline comment noting the range is unverified against that version. Source: migrator.

8. **Exported privileged extension points on `./internal` subpath** — When a package is prepared for publish, any exported function that is a privileged internal extension point (not part of the documented public API) should be on a dedicated `./internal` subpath export to prevent accidental consumer dependencies. Source: curator.
