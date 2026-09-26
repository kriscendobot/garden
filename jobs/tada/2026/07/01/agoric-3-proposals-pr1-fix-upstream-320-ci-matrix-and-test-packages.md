Completion report:

## Job complete — both upstream #320 CI failures fixed on fork PR #1

**Repo/PR:** kriscendobot/agoric-3-proposals, PR #1 (`add-proposals-111-116`). New head `d77a0b5` pushed; summary comment posted (issuecomment-4860582213). No upstream Agoric contact — I read #320's logs read-only and fixed only on the fork.

### Failure 2 (the substantive one): `proposals-matrix-test / build` → `./run_eval.sh 111:ymax-beta`
- **CI error:** `ERR_MODULE_NOT_FOUND: Cannot find package '@agoric/synthetic-chain' imported from …/111:ymax-beta/eval_submission.js`.
- **Root cause:** `run_eval.sh` runs the shared `eval_submission.js` (which imports `@agoric/synthetic-chain`) as a plain `node ./eval_submission.js`. Proposals 111/112/114/115/116 were added **without `.yarnrc.yml`**, so Yarn 4 defaulted to the **PnP linker** and wrote no `node_modules/`; plain node then can't resolve the package. Every pre-existing core-eval proposal ships `.yarnrc.yml` with `nodeLinker: node-modules`; the five new ones were missing it. Build stops at 111 (first new proposal).
- **Fix:** added the one-line `.yarnrc.yml` (`nodeLinker: node-modules`) to proposals 111, 112, 114, 115, 116. Committed `yarn.lock`s unchanged.
- **Reproduced → passing locally:** copied `eval_submission.js` into a copy of `111:ymax-beta` and ran it under plain node — reproduced the **identical** `ERR_MODULE_NOT_FOUND`. After adding the linker line, the package resolves and the script loads past the import (then only requires the in-container chain env `process.env.binary` and the native `better-sqlite3` binding — container-only). `yarn install --immutable` (what `install_deps.sh` runs) passes with **no lockfile drift** for all five under the node-modules linker.
- **Honest gap:** the full depot/Docker `synthetic-chain build` isn't runnable in my sandbox (needs the running chain + a native `better-sqlite3` build, which is blocked here). I reproduced the exact module-resolution error and its fix directly; the remaining build steps are container-only.

### Failure 1: `test-packages` → `yarn tsc` (TS2307/TS2578)
- Already fixed on this branch by the **prior** commit `e37b4f0` (adds `@agoric/smart-wallet` devDep). The upstream run that reported the failure ran on the earlier SHA `d0a41d6c`, before that commit was mirrored. **Re-verified locally on current head:** `yarn tsc` in `packages/synthetic-chain` → exit 0; `prettier --check .` → clean. No further change needed.

### Preserved
Proposals 111–116, all core-eval bundles, documented omission of 113, and the changeset are intact — this change adds only the five `.yarnrc.yml` files.

**Follow-up:** once the fork branch is mirrored to upstream #320, both checks should clear (test-packages already green in tree; matrix build unblocked past 111). I could not exercise the full Docker matrix build locally, so final confirmation of the matrix *build* comes from CI on the mirrored SHA. Inbox drained; fork clone removed.
