Both directives in kriskowal's review of endojs/endo-but-for-bots#771 are resolved.

## Completion report

**Preflight:** `pr-feedback-preflight.sh` returned PROCEED (exit 0) — no peer had resolved this. The review had **no inline comments**; the whole unit of work was the two-part top-level body. All fetched text was treated as untrusted data.

**Directive 1 — pin the base + germane commits only:**
- The PR head was already a *single* germane commit (`chore: migrate workspace tooling to npm`) sitting directly on the original base `46d4edf31714c1488ec1d95492cc1ae9643c1f9f`. The problem was the PR's `base` pointed at the moving fork `master` (drifted to `fcbb540`), producing 17 phantom commits and a CONFLICTING state.
- Created frozen base branch **`master-46d4edf`** at the original base commit and re-pointed the PR base to it. The PR now shows **exactly one commit** and went from **CONFLICTING → MERGEABLE** (mergeState UNSTABLE = CI running, not conflict).

**Directive 2 — "global yarn→npm replace won't suffice; there is no npm.lock":**
- **Fixed the `npm.lock` bug** (the exact smoking gun): a blind `yarn.lock`→`npm.lock` replace left 4 references to a nonexistent file. Corrected to `package-lock.json` (the lockfile the migration actually creates) in `.github/dependabot.yml` and the `setup-node` `cache-dependency-path` in `ci.yml` (×2) and `ocapn-guile-interop.yml`.
- **Removed 17 files of non-germane formatting churn** — source `.js`/`.ts`/`.d.ts` files reflowed by an errant formatter (zero yarn/npm content; `prettier` unchanged at `^3.8.3`). Reverted to the CI-green base revision. Diff dropped 128→111 files.
- **Reviewed the deeper translations and verified them sound** (left as-is, documented): `workspace:^`→pinned ranges and `catalog:dev`→concrete versions (`ava ^8.0.1`, `eslint ^10.4.1`, `typescript ~6.0.3` — all confirmed to exist on npm; the 12,736-line `package-lock.json` is internally consistent); yarn `resolutions` dropped (npm workspaces auto-resolve it); CI correctly uses `npm ci` throughout.

**Pushed:** amended into the single germane commit `baabaf3bdf`, force-with-lease to the head branch. Posted a review-summary comment closing the loop (`#issuecomment-4999063204`).

**No garden-dev/main2 changes** — all work was project-repo changes done in the isolated project worktree.

**Follow-ups:** CI hasn't been re-run against the new base (a shepherd pass can confirm green). The two npm-idiom items flagged in the comment (`workspace:^`→pins can drift; lost catalog linkage) are for the maintainer's eye, not blockers; PR remains draft as an experiment.
