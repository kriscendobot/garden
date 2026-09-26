Done. Completion report follows.

---

## Completion report: attention directive on endojs/endo-but-for-bots PR #96

**Directive** (kriskowal review comment r3476499038, file-level on `packages/compartment-mapper/src/package-descriptor-cache.js`): *"Please consolidate type definitions into the .d.ts types tree."*

**Routing/assessment.** Re-fetched the comment (treated as untrusted data). It was one of three comments in the same `CHANGES_REQUESTED` review (2026-06-25T17:55Z); the other two — moving the design doc under `packages/compartment-mapper/designs/`, and adding `ts`/`mts`/`cts` parity in `language-for-extension-by-prefix.js` — are separate concerns tracked under their own jobs. This job was scoped strictly to the type-definition consolidation. The PR has been implemented in place (not design-only), so this was a direct code change rather than a re-dispatch.

**What I did.** Discovered that three of the four inline `@typedef`s in `package-descriptor-cache.js` (`PackageDescriptorCache`, `CompartmentRootDescriptor`, `AuxiliaryDescriptor`) were already declared as exported interfaces in `src/types/external.ts` — the inline copies were redundant duplicates. So:
- Removed all four inline `@typedef` blocks from `package-descriptor-cache.js`; the three external ones are now `@import`ed from `./types.js`.
- Moved the internal-only `ClassifiedDescriptor` (never referenced outside the module) into `src/types/internal.ts`, which flows into `types.d.ts` via the internal re-export.

Net: `+17 / −58` across two files; a type-only relocation with no runtime change.

**Verification** (installed deps in an isolated detached worktree off the PR head):
- `tsc` (lint:types): clean
- `eslint` on both changed files: clean
- `ava` auxiliary suite (`package-descriptor-cache`, `auxiliary-language`, `auxiliary-transitive-language`, `auxiliary-package-json-parsers`): 16/16 pass

**Pushed & communicated.** Commit `63266ca` pushed to `design/compartment-mapper-auxiliary-package-json` (`16ce3b08d..63266ca56`, fast-forward, branch confirmed unmoved before push). Posted an inline thread reply on the comment (#discussion_r3476565302) and a top-level summary comment (#issuecomment-4802701045) with SHA, what changed, and verification. Worktree torn down; inbox empty.

**Follow-ups.** None for this directive. The two sibling review comments remain open for their own jobs. The PR's review state is still `CHANGES_REQUESTED` overall and won't clear until those are addressed too.
