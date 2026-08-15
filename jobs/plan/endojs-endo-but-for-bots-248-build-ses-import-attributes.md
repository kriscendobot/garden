---
gate: deferred
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-08-15T06:04:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: SES import attributes (design #248)

Implement the accepted design `designs/ses-import-attributes.md` in
`endojs/endo-but-for-bots` (base branch `llm`). PR #248 (the design) is
approved by @kriskowal, who asked to "build this at the foreman's leisure."

Design doc (authoritative spec):
https://github.com/endojs/endo-but-for-bots/blob/llm/designs/ses-import-attributes.md
Design PR: https://github.com/endojs/endo-but-for-bots/pull/248

Scope, per the doc's sections:
- Normalized attribute representation: frozen plain object, sorted keys,
  clone-then-freeze; JSON-stringified memo form with an empty-case sentinel
  (§ Normalized attribute representation).
- Module-memo key extension: `<fullSpecifier> + '\0' + <normalized-attrs-json>`
  with the legacy collapse rule so unattributed imports keep their pre-attributes
  key byte-identical (§ Memo key extension).
- Arity-based backward-compatible `importHook` / `importNowHook` signatures:
  single-arg legacy hooks keep working for unattributed graphs and throw the
  exact specified TypeError rather than silently misinterpret non-empty
  attributes (§ importHook signature).
- `JsonModuleSource` as the v1 source type via source dispatch; CSS/Wasm remain
  sketched-only future variants (§ Source dispatch).
- Backward compatibility for serialized `@endo/compartment-mapper` bundles/archives:
  pre-attributes bundles load and key identically; attribute-aware bundles record
  attributes only on non-empty `with` clauses (§ Backward compatibility, § Compartment-mapper implications).
- Compartment construction priming of attribute-bearing modules and
  resolveHook handling per §§ Compartment construction / Resolution.

Land the § Test plan alongside the code. Prefer a stacked/phased PR series if the
diff is large (ses/module-source core first, then compartment-mapper). Follow the
normal builder → gauntlet chain; keep the change on `llm`.

Note: the design remains marked *Draft* in `designs/README.md`; flipping its
status is part of the build's doc bookkeeping once implementation lands.
