The commit is on the remote PR branch and the working tree is clean (node_modules/.tmp gitignored). Job complete.

---

## Completion report

**Directive** (endojs/endo-but-for-bots#660, comment 4942288215 by @erights, treated as untrusted data): answers the PR author's three flagged uncertain-scope questions about further cross-package re-exports —
1. `@endo/init` → **separate PR**
2. `@endo/spaces-util` → **separate PR**
3. `@endo/pass-style` `Checker` type re-export → **do it in this PR**

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved this).

**Work done in PR #660** (item 3), applying the same recipe the PR's other slices used — commit `403b27892c`, pushed to `refactor/inter-package-reexports-marshal-captp-patterns`:
- `packages/pass-style/src/types.d.ts` — upgraded the pre-existing prose deprecation note on `export type { Checker } from '@endo/common/ident-checker.js'` to a proper `@deprecated` JSDoc tag matching the marshal/captp/patterns slices.
- `packages/pass-style/src/passStyle-helpers.js` and `src/types.test-d.ts` — repointed the two in-repo `Checker` importers off the local `./types.js` twin onto `@endo/common/ident-checker.js` directly.
- `.changeset/inter-package-pass-style-deprecate.md` — new `@endo/pass-style: patch` changeset.
- No new workspace dependency: `@endo/pass-style` already depends on `@endo/common`. No cross-package importers of `Checker` via `@endo/pass-style` exist elsewhere in the tree.

**Verification** (real install via corepack yarn 4.13.0, TMPDIR off noexec /tmp): ESLint **0 errors** (only pre-existing `any` warnings on untouched lines), Prettier **clean**, `tsc` (`lint:types`) **clean**.

**Routing of items 1 & 2** (separate PRs, as directed) — posted two builder jobs with distinct directive identities:
- `endojs-endo-but-for-bots-init-reexport-slice` (flags the side-effect-vs-plain-re-export nuance the PR author raised; instructs to confirm with @erights rather than mechanically deprecate).
- `endojs-endo-but-for-bots-spaces-util-reexport-slice` (flags the possible `spaces-util → daemon` layering-inversion concern).

**Communication:** posted a reply comment on PR #660 (comment 4942317181) citing @erights's directive, confirming item 3 landed and items 1–2 are queued as separate follow-ups.

**Follow-ups:** the two posted builder jobs will each open their own stage-1 non-breaking PR; both carry cautions to verify design intent before acting.
