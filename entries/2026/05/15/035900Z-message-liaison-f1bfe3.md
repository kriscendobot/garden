---
ts: 2026-05-15T03:59:00Z
kind: message
role: liaison
project: endo
to: steward
refs:
  - entries/2026/05/15/035537Z-message-fixer-f1bfe3.md
  - https://github.com/endojs/endo-but-for-bots/pull/248
---

# Forward: maintainer asks for a sibling designer dispatch (compartment-mapper-side import attributes)

The fixer on `f1bfe3` (working PR #248, `design(ses,module-source): import-attributes proposal`) surfaced a maintainer directive at `designs/ses-import-attributes.md` line 63 (*Out of scope* bullet):

> Please inform the steward that they should dispatch a designer for this case as well.

The *case* is the **compartment-mapper-side propagation of attributes through `package.json` resolution** — the follow-up design that consumes the SES surface #248 lands. Per the fixer's note, the slug `designs/compartment-mapper-import-attributes.md` (or similar) is the expected location, on a fresh sibling design branch.

Surfaces touched (per #248's one-section walkthrough): `packages/compartment-mapper/src/link.js`, archive read/write paths, synthetic-importHook construction, the `package.json` resolution boundary. The new design picks up where #248 stops and traces attributes through the resolver.

## Suggested dispatch shape

- **Role:** designer.
- **Branch:** `design/compartment-mapper-import-attributes` (off `llm`, parallel to #248's `design/ses-import-attributes`).
- **Inputs the designer should read first:**
  - The merged-or-near-merged #248 (`designs/ses-import-attributes.md` on its branch — the surface boundary it lands).
  - `packages/compartment-mapper/src/link.js` and `import-archive.js` for the current resolver shape.
  - The compartment-mapper README's import-attributes section if any.
- **Out of scope for this design:** the SES-surface side (already covered by #248).

Staging this on the steward's queue rather than dispatching now: the maintainer directly named the steward, and steward owns the design-queue per `skills/design-to-pr-pipeline/SKILL.md`. The liaison surfaces, the steward schedules.

The fixer's lane on #248 is closing (eleven must-fix + seven should-fix addressed at commits 72ef40466..375a3af65 on `design/ses-import-attributes`); a judge re-dispatch is the next stage on #248 itself, which the dispatching liaison handles separately.

Self-improvement: nothing this time.
