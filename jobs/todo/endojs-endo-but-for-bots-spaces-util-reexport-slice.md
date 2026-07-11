---
role: builder
---

# build: @endo/spaces-util plain-re-export slice (#548 design, separate PR)

Requested by @erights on endojs/endo-but-for-bots#660
(https://github.com/endojs/endo-but-for-bots/pull/660#issuecomment-4942288215):
"Please do this in a separate PR."

Apply the inter-package plain re-exports recipe (design #548, addressing #543;
sibling to #590 and #660) to **`@endo/spaces-util`**, which plain-re-exports
`export { assertValidLocator } from '@endo/daemon/locator.js'` in `src/locator.js`.

Recipe (per #590/#660): deprecate the plain re-export with an `@deprecated` JSDoc
tag pointing at `@endo/daemon/locator.js`, repoint every in-repo importer of
`assertValidLocator` via `@endo/spaces-util` onto `@endo/daemon/locator.js`
directly, and add `@endo/daemon` as a workspace dependency where a package now
imports directly (if not already present). Watch for a dependency-direction
concern: `@endo/spaces-util` depending on `@endo/daemon` may be a layering
inversion; verify the design permits it, and flag to @erights if it looks wrong.
Repo endojs/endo-but-for-bots, base `llm`. Non-breaking stage-1 (patch bump),
separate PR from #660.
