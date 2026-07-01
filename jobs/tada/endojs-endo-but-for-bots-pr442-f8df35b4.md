The builder job was posted and has already been claimed by a peer gardener (it's in `jobs/doin/`). Routing complete.

---

## Completion report

**Job:** `endojs-endo-but-for-bots-pr442-f8df35b4` — attention directive on endojs/endo-but-for-bots PR #442.

**Directive (re-fetched, treated as data):** kriskowal review comment `r3502513778` on `packages/daemon-cas/src/content-store.js` line 6 — *"Lack of .js extension is not expected. Post a job for a builder to ensure this is enforced by lint."*

**What I found (grounding for the builder):**
- The flagged specifier is a **JSDoc `@import`** — `/** @import { ContentStore } from '@endo/platform/fs/lite/types' */` — extensionless, while the adjacent line 7 (`'../types.js'`) carries `.js`.
- The repo's `import/extensions` rule is already active for these packages (chain: package `eslintConfig` → `plugin:@endo/internal` → `strict` → `imports`, set to `['error','always',{ignorePackages:true}]`), but `eslint-plugin-import` only inspects real `import`/`export`/`require` statements — **it never reads JSDoc `@import` tags**, so this class of omission slips through. This is the gap the builder must close (not a config toggle on the existing rule).

**What I did:**
1. Wrote a self-contained builder job body grounding the builder in the config chain, the exact reason the omission escapes lint, candidate mechanisms (`eslint-plugin-jsdoc` rule vs. a small custom `@endo/eslint-plugin` rule + test), PR shape (dedicated PR against `llm`, discharges the #442 directive), and red-then-green verification.
2. Posted it to the board as **`builder-ebfb-enforce-js-extension-jsdoc-import-lint`** (push to `origin/journal2` confirmed). It has already been **claimed by a peer gardener** (now in `jobs/doin/`).
3. Replied on the PR #442 review thread (`r3502531512`, as kriscendobot) closing the loop: explained the JSDoc-`@import` gap and named the tracking job.

**Changes to main2:** none — this was a routing/attention job; its product is the posted board job plus the PR reply, not a garden-source commit.

**Follow-ups:** None required from me. The builder job carries the full task, including fixing the #442 line-6 occurrence and a repo-wide sweep. If the builder decides the daemon-cas one-liner is best fixed inside #442 rather than the tooling PR, that decision is noted in the job body and will surface back on #442.
