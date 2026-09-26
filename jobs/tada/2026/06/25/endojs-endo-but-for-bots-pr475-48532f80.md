Done. Completion report:

---

**Job:** attention directive on endojs/endo-but-for-bots PR #475 (review comment by kriskowal: *"This 'interlude' is and must be the same for both node and XS. Please factor it out."*)

**What the directive meant:** The pass-style-bytes parity interlude — the six `@endo/pass-style` bytes imports (`frozenBytes`, `thawnBytes`, `concatBytes`, `encodeUtf8`, `decodeUtf8`, `strictDecodeUtf8`) plus their `globalThis` assignments — was duplicated verbatim in `packages/test262-runner/src/node-prelude.js` and `src/xs-prelude.js`. The two preludes differ only in their host-specific SES lockdown (node runs `lockdown-shim` + `compartment-shim`; XS runs `lockdown-shim` only), but the interlude must stay identical.

**What I did (pushed `fe0c785b5` to `feat/narrow-bytearray-to-uint8`):**
- Added `src/expose-pass-style-bytes-globals.js` holding the shared interlude (imports + `globalThis` assignments + the no-op-reinstall comment).
- Rewrote `node-prelude.js` and `xs-prelude.js` to drop their inline copies and `import './expose-pass-style-bytes-globals.js';` after their own lockdown. The interlude now has a single definition site and cannot drift between hosts.
- Module-evaluation order is preserved (SES lockdown still fully evaluates before the pass-style modules capture `TextEncoder`/`TextDecoder`), and `makeBundle` statically inlines the import, so the gitignored generated `prelude/{node,xs}.js` bundles come out unchanged.

**Communication:** Posted an inline reply on the review thread (`#discussion_r3477708316`) and a top-level summary comment (`#issuecomment-4804199091`) naming the head SHA, the change, and verification status, per the standing summary-comment norm (commenting is covered by the repo's standing authorization).

**Verification:** Mechanical extraction of byte-identical lines, so behavior is preserved by construction. A full monorepo `yarn install` + test262 (XS needs the `xst` binary) was disproportionate and the deps are not installed in the worktree, so I am relying on this draft PR's CI (lint / `yarn build` / test262) to confirm.

**Follow-ups:** None blocking. The PR remains DRAFT; CI on `fe0c785b5` will validate the bundle/lint/test262 run. Worktree torn down; inbox empty.

**Self-improvement:** nothing this time.
