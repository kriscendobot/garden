All work is complete, verified, pushed, and the PR is updated. Here is my completion report.

---

## Completion report: fold-in of the `.js`-extension exports-map migration

**Decision on approach:** Extended PR **#581** in place (per the maintainer's "fold in" directive), since it was a draft still landing. Pushed one commit `d6ecd0cfb` to `feat/eslint-plugin-jsdoc-import-extensions` and updated the PR title/body + posted a summary comment (commenting is standing-authorized on `endojs/endo-but-for-bots`).

**1. Migrated three `exports` maps to `.js`-suffixed keys** (keys replaced, not dual-listed):
- `@endo/platform`: `./fs.js`, `./fs/lite.js`, `./fs/lite/types.js`, `./fs/node.js`, `./fs/extended.js`, `./proc.js`, `./exo-fs.js` (the `./fs/extended/*` wildcard left as-is — it already passes a `.js` suffix through).
- `@endo/agentry`: `./harness.js`, `./define-agent.js`, `./execute.js`, `./eval.js`.
- `@endo/preact-container`: `./renderer.js`, `./compartment.js`.

**2. Updated every in-repo consumer** — 83 files total: real imports, JSDoc `@import`, dynamic `import()`, bundler external lists, and README/design code examples, including the `@endo/platform/fs/lite/types` line from the #442 review. A quote-anchored rewrite kept nesting/prose safe.

**3. Extended the lint rule** (`@endo/jsdoc-import-extensions`) to also enforce `.js` on `@endo/*` subpaths in JSDoc `@import` — **resolution-aware**, reading each target package's exports map from disk and flagging only subpaths whose package offers just the `.js` key. This was necessary because the task's premise was incomplete: **many other `@endo/*` packages still use extensionless keys** (`@endo/cancel`, `@endo/ocapn`, `@endo/ocapn-noise`, `@endo/goblin-chat`, `@endo/agent-tools`), so a blanket `@endo/*` rule would have been wrong. Real imports are already covered by `import/no-unresolved` once the extensionless key is dropped. Added two changesets (a `minor` for the three packages, plus the updated eslint-plugin one).

**Non-obvious fix found during verification:** `platform`'s `declare module '@endo/platform/fs/extended'` ambient type stanza had to be re-keyed to `.js`, or `tsc` broke with `TS2306 "is not a module"` on `agent-tools`/`agentry`. Saved to memory.

**Verification:**
- eslint-plugin mocha suite green (rule test extended to 23 cases with hermetic migrated / not-yet-migrated / unresolvable `@endo/*` fixtures).
- `eslint .` clean across **all 16 touched packages** ⇒ `import/no-unresolved` green ⇒ every migrated subpath resolves.
- `tsc` clean on platform, agentry, agent-tools, daemon, cli.
- Node dynamic-`import()` resolves every migrated subpath.

**Honesty caveats:** `lal`'s `tsc` failures are pre-existing third-party missing-dependency noise (`undici-types`, `@modelcontextprotocol/sdk`), not from this change. Verification ran in a worktree where the native `better-sqlite3` build failed (known sandbox limitation), so the sqlite-backed `daemon` **ava** runtime suite was not executed here — static resolution (eslint + tsc + Node `import()`) covers the API-surface correctness, and I stated this plainly in the PR comment.

**Follow-ups:** the other extensionless-keyed `@endo/*` packages (cancel, ocapn, ocapn-noise, goblin-chat, agent-tools) could be migrated later; the new lint rule self-adjusts and will begin enforcing each as it converts.

Self-improvement: saved a `reference` memory on the two non-obvious `.js`-key migration hazards (declare-module re-keying; resolution-aware vs. blanket scope enforcement).
