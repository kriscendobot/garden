Library index gap — library/keywords.md is missing 2 concept mappings.

Task: add keyword lines to library/keywords.md (journal2) for two concept
pages that EXIST under library/concepts/ but have NO entry in keywords.md, so a
library-lookup grep for their terms currently dead-ends. Authorized
library-content edit; land with
`scripts/jobs/land-journal-edit.sh library/keywords.md` — do NOT hand-git the
live journal/ worktree.

Missing concepts (verified absent from keywords.md 2026-07-18), with the
aliases to map (from each concept page's `aliases:` frontmatter):
- dual-package-hazard : dual package hazard, dual-package hazard, dual CommonJS/ES module, dual ESM/CJS, ESM CJS dual publishing, two module instances, singleton duplication
- package-type-field  : type field, "type": "module", type module, type commonjs, module system determination, nearest parent package.json, .mjs, .cjs, syntax detection

For each: add term->concept-id lines to keywords.md in the file's existing
one-entry-per-line format, one line per alias above plus the concept-id itself,
matching the surrounding entry style. Both concepts carry topics
[package-manifest, module-loader].

Acceptance: grep for dual-package-hazard and for package-type-field each hit
keywords.md; a library-lookup on e.g. '"type": "module"' resolves to
package-type-field.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-18T16:56:19Z
