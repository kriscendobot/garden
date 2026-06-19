---
source_kind: changeset
source_repo: endojs/endo
source_path: .changeset/daemon-ts6-type-precision.md
source_line_range: 1-11
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 395 designs-lane ingest. 11-line .changeset entry
  for @endo/daemon TypeScript 6 conformance improvements.
  Forty-third AUTHORED conformant single-body section doc
  in post-refactor era. Eighty-fifth consecutive non-garden
  source after the pivot (310-395). §eighty-five-cycles-
  with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  three-typescript-precision-improvements-in-one-changeset
  — the changeset bundles THREE distinct TypeScript
  precision issues in one patch bump. (1) Two `Context`
  parameters tightened from raw `string` to branded
  `FormulaIdentifier`. (2) `RemoteControl`/`RemoteControlState`
  methods take `ERef<EndoGateway>` instead of `Promise<
  EndoGateway>`. (3) `EndoInspector` generic parameter
  renamed from `Record` (shadows built-in) to `RecordT`,
  with method-syntax to maintain assignability under
  strictFunctionTypes. §the-named-bundled-typescript-
  precision-improvements as tier-3 meta-pattern.

  §The-named-string-tightened-to-branded-FormulaIdentifier
  — line 7: "tightened from `string` to `FormulaIdentifier`
  (a branded string type)." Cycle 387 AGENTS.md named the
  branded-types-from-validators discipline; cycle 394 pet-
  name.js was the canonical application; cycle 395 shows
  the discipline applied to ANOTHER named type
  (FormulaIdentifier) in another package. §the-named-
  branded-types-discipline-recurs-across-types as tier-3
  meta-pattern; the branded-types discipline is not
  package-local — it composes across packages.

  §The-named-ERef-vs-Promise-distinction — line 8: the
  changes prefer `ERef<EndoGateway>` over `Promise<
  EndoGateway>` in type signatures. ERef from @endo/
  eventual-send is the typed remote reference (cycle 367
  exo, cycle 321 eventual-send); using ERef instead of
  Promise signals to TypeScript consumers that the value
  can be a remote reference, not just an in-process
  Promise. §the-named-ERef-as-remote-promise-type as
  tier-3 meta-pattern; the type expresses the eventual-
  send semantics.

  §The-named-rename-Record-to-RecordT-to-avoid-shadowing
  — line 9: "EndoInspector generic type parameter renamed
  from `Record` to `RecordT` to avoid shadowing the built-
  in `Record` utility type." TypeScript pitfall: generic
  parameters named Record shadow the built-in Record
  utility type, making code that references built-in
  Record inside the generic scope ambiguous. §the-named-
  generic-parameter-name-clashes-with-builtin-utility-
  type as tier-3 meta-pattern.

  §The-named-method-syntax-for-strictFunctionTypes-
  assignability — line 9: "`lookup` and `list` now use
  method syntax so that `EndoInspector<'some literal'>`
  remains assignable to `EndoInspector<string>` under
  `strictFunctionTypes`." TypeScript's `strictFunctionTypes`
  flag distinguishes between method syntax (`foo(x): T`)
  and arrow property syntax (`foo: (x) => T`) — method
  syntax has bivariant parameter checking; arrow syntax
  has contravariant. The bivariance is required here for
  the assignability the design wants. §the-named-method-
  syntax-bivariance-for-assignability as tier-3 meta-
  pattern.

  §The-named-typescript-6-as-conformance-target — line 5:
  "TypeScript 6 conformance: public types in `types.d.ts`
  are now more precise." TypeScript 6 introduces stricter
  type-checking; the changeset names this as the goal.
  §the-named-version-bump-of-toolchain-as-conformance-
  target as tier-3 meta-pattern.

  §The-named-consumer-update-acknowledgment — line 11:
  "TypeScript consumers implementing or calling these
  interfaces may need to update their types accordingly."
  The changeset explicitly tells downstream consumers
  about the impact. §the-named-downstream-impact-named-in-
  changeset as tier-3 meta-pattern; sibling shape to
  cycle 380's @endo/base64 changeset which named the
  TypeError-under-SES impact.

  §The-named-patch-bump-for-type-only-change — line 2:
  `'@endo/daemon': patch`. The changeset is a patch bump
  even though it makes downstream consumers update their
  types. Patch semver semantics: no runtime behavior
  change. Type precision improvements are non-breaking at
  runtime but breaking at type-check. §the-named-patch-
  bump-for-type-only-discipline as tier-3 meta-pattern;
  the semver semantics are about RUNTIME compatibility,
  with type-level changes treated as patch even when they
  require consumer-type updates.

  §The-named-strictFunctionTypes-as-flag-mentioned-in-
  changeset — the changeset names a specific TypeScript
  flag (`strictFunctionTypes`) and explains the
  consequence. The changeset's audience is TypeScript-
  savvy. §the-named-changeset-assumes-typescript-expertise
  as tier-3 meta-pattern.

  §The-named-eleven-line-changeset-three-issues — the
  entire changeset fits three precision improvements +
  motivation + consumer note in 11 lines (after the YAML
  frontmatter). Sibling shape to cycle 380's 13-line
  base64-harden changeset; both compact + structurally
  rich.

  Closes seven citation arcs: cycle 394 (1, adjacent
  forward; pet-name.js was canonical branded-types-from-
  validators application; cycle 395 shows the discipline
  applied to FormulaIdentifier in another package) +
  cycle 387 (3, AGENTS.md branded-types discipline +
  ERef-vs-Promise type-precision tightening) + cycle 367
  (13, exo ERef from eventual-send) + cycle 321 (13,
  eventual-send ERef type) + cycle 380 (3, changeset
  shape: bundled-with-consumer-impact-acknowledgment) +
  cycle 326 (69, pure-naming-as-discipline; the rename
  Record → RecordT IS pure naming applied to disambiguate)
  + cycle 322 (69). Pushes citation-arc-closures-in-pivot
  to FOUR-HUNDRED-FORTY-FOUR (437 + 7 net new).
---

11-line .changeset entry for @endo/daemon TypeScript 6 conformance improvements. §the-named-three-typescript-precision-improvements-in-one-changeset (single most structurally interesting move; three distinct TS precision issues bundled in one patch bump); §the-named-bundled-typescript-precision-improvements. §the-named-string-tightened-to-branded-FormulaIdentifier (cycle 387 AGENTS.md branded-types discipline applied to FormulaIdentifier); §the-named-branded-types-discipline-recurs-across-types (discipline composes across packages). §the-named-ERef-vs-Promise-distinction (ERef from eventual-send is typed remote reference); §the-named-ERef-as-remote-promise-type. §the-named-rename-Record-to-RecordT-to-avoid-shadowing (TS pitfall: generic parameter shadows built-in utility); §the-named-generic-parameter-name-clashes-with-builtin-utility-type. §the-named-method-syntax-for-strictFunctionTypes-assignability (bivariance vs contravariance under strictFunctionTypes); §the-named-method-syntax-bivariance-for-assignability. §the-named-typescript-6-as-conformance-target; §the-named-version-bump-of-toolchain-as-conformance-target. §the-named-consumer-update-acknowledgment; §the-named-downstream-impact-named-in-changeset (sibling to cycle 380). §the-named-patch-bump-for-type-only-change; §the-named-patch-bump-for-type-only-discipline (semver about runtime compatibility; type-level changes are patch even when consumer types must update). §the-named-strictFunctionTypes-as-flag-mentioned-in-changeset; §the-named-changeset-assumes-typescript-expertise. §the-named-eleven-line-changeset-three-issues (sibling to cycle 380). Seven citation arcs closed.
