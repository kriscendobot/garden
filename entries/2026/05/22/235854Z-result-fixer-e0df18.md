---
ts: 2026-05-22T23:58:54Z
kind: result
role: fixer
worktree: dispatches/fixer--116888/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/235300Z-dispatch-general-contractor-116888.md
  - entries/2026/05/22/235100Z-result-solicitor-07b99e.md
---

Round-1 fixer pass on PR #358 (`design(daemon): importLocation from EndoMount with npm-registry-proxy + Go-like MVS`). One commit pushed to `design/daemon-worker-import-from-mount`: `193846c93`. Net +275 / -44 against the design markdown only; no source/test touched.

**Must-fix (2 of 2 addressed)**:
1. `makeMountReadPowers` rewritten: the synthetic URL now carries `<name>@<version>` so the multi-major coexistence path the `RegistryResolution` type explicitly allows is unambiguous; `resolvePackageRef` is no longer an undefined helper (folded into a direct `Map.get(nameAtVersion)` with a named-error fallback that quotes the `resolutionHash`). A new paragraph names the descriptor walk's per-importer version table as the authoritative source of the `<name>@<version>` segment and gives the worked multi-major example (`pkg@^1` direct + transitive `pkg@^2`).
2. Phase 5 test catalog gained two entries: (a) multi-major coexistence end-to-end test against side-by-side fixture packages whose bytes differ per major; (b) snapshot-lifetime-release test that confirms `thisDiesIfThatDies` actually releases the CAS trees when the caplet ends. The two tests were colocated under Phase 5 rather than spread because they both exercise the lockfile / resolution path.

**Summary-fix bundle (22 of 22 addressed in this round, one design markdown commit)**:
- HostFormula `@registry` migration policy named (idempotent daemon-start upgrade pass; mirrors `daemon-make-archive.md` § Phase 6 `@node` precedent).
- Worker-side sharing shape named (single `selectRootShape` + `runImportLocation` core; `makeFromPackage` and `makeFromTree` as thin shape-pinning wrappers).
- MVS terminology restated to "minimum-of-the-mins-that-satisfy" with explicit Go-MVS / npm-resolver disambiguation; cites `endor-npm-registry-proxy.md` verbatim instead of paraphrasing.
- Snapshot lifetime test added under Phase 5 (the second of the must-fix-#2 pair, also drawn from summary-fix #4).
- Failure surface enumerated as four `@endo/errors`-tagged classes; mid-resolve restart / bus-disconnect path explicitly named; cross-cites `daemon-make-archive.md` § *Cancellation handling*.
- Resolver / store capability split tracked as Open Question 8 (combined cap ships first for symmetry with `@node`).
- `integrity` field rationale captured inline (cross-check against upstream attestations; `treeRef`'s content-address already proves bytes).
- Two-scheme split (`endo-mount:` vs `endo-tree:`) tracked as Open Question 9 with the "tree-shaped at read time" rationale for keeping one scheme first.
- `makeFromMount` host-method dispatcher added (`selectRootShape` once; CLI delegates rather than re-implementing detection).
- `EndoRegistry` rename tracked as Open Question 7 (revisit during `daemon-agent-tools` review).
- `options.entry` default inherits `compartment-mapper`'s `exports['.'].endo` → `import` → `default` → `main` → `index.js` chain rather than restating it.
- `endor-npm-registry-proxy.md` § *Algorithm* step 3 restated inline (mapper's per-importer descriptor walk).
- Summary opening glosses `importLocation`, `ReadPowers`, `daemon-worker`, and `CAS` parenthetically on first use.
- `thisDiesIfThatDies` glossed inline as "a lifetime-coupling primitive that releases the dependency when the dependent caplet ends" with a forward cite to `inventory-cancel-and-liveness.md` § *Lifetime coupling*.
- `EndoRegistry` interaction-model preamble added before the method list (worker calls `resolve` once, reads through CAS verbs, host owner calls diagnostics).
- Resolution-path § third bullet split into two sentences so the bullet form matches the other two.
- "Possibly, depending on timing." fragment rewritten to a single sentence; the code-block transition now reads cleanly.
- Phase 6 deferred-heading deviation explained in a one-line preamble.
- Italic-citation-on-section-name nit absorbed in the rewrite of the `makeMountReadPowers` § (the offending citation was removed when the algorithm step was restated inline).
- Single-quote-inside-sentence at Open Question 6 already used double quotes in the current file; the panel may have been reading an earlier draft. Verified.
- "A future refinement could add..." in the lockfile § already sits on its own paragraph in the current file (after the bullet list); verified.

**Follow-up (not touched per dispatch brief)**: the 5 follow-up items are parked on the ledger `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--358.md` per the solicitor's round-1 result.

**CI**: not applicable (design-only PR; the design CI matrix runs against the design files themselves).

**Re-dispatch**: solicitor for round 2 against the new HEAD `193846c93`.

Self-improvement: nothing this time. The summary-fix bundle was large (22 items) but every item was addressable in one revision; the design's existing structure absorbed the additions without re-organization. The one judgment call was whether to defer the resolver/store split and the scheme split to Open Questions vs. land them now; both are confinement / nature-of-data refinements that benefit from a first cut's usage data before committing, so I deferred and named the deferrals. The threshold per `skills/self-improvement/SKILL.md` is "load-bearing for the next reader"; this one was not.
