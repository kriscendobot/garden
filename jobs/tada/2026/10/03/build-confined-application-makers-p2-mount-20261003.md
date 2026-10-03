I added the daemon's canonical hook for mounts to the shared Phase-2 branch and pushed it. Head is `fda4429685ed1425b8d78309bb43c2e6ef402be1` on `kriscendobot/endo-but-for-bots` `llm-confined-application-makers-p2`, and the focused tests pass.

**Starting point:** the branch head was `68e9dac0b9`, the scan child's "feat(daemon): capture node_modules trees". I worked on top of it and fast-forwarded, so none of the earlier commits were changed or dropped.

**How the hook works:**
- **New function (`packages/daemon/src/mount.js`):** `makeMountCanonical(mount)` returns a `canonical(segments)` hook for a mount the daemon created. It returns `undefined` for anything else, such as a snapshot tree, which keeps the identity as the design says. To make the hook possible, each mount's private record now also holds the mount's `entry` function and a `realPath` wrapper. `getMountBacking` builds its own return object, so these never leave the daemon.
- **What the hook does:**
  - It creates a mount entry for the segments and reads its path with `getEntryPhysicalPath`.
  - It resolves that path with `realPath` and checks it against the resolved tree root (the mount's current directory).
  - It returns the result as segments relative to that root, so different `node_modules` paths to one package give the same location.
  - A path that doesn't exist keeps its own segments, which is what Node's `canonical` does.
  - A path that resolves outside the tree root is refused with an error ("Unsupported layout: … resolves outside the mount root"), not reported as a missing dependency. This includes a sub-mount's sibling that is still inside the parent mount.
  - Revocation and the denied-name list apply, because the hook goes through `entry()`.
- **Wiring (`packages/daemon/src/capture-node-modules.js`):** `captureNodeModules` now passes `makeMountCanonical(await tree)` into `makeTreeReadPowers`. Nothing in the public `EndoMount` interface changed.
- **Out of scope, as asked:** no `EndoHost.makeFromTree` layout/entry work and no PR.

**Tests (`packages/daemon/test/capture-node-modules.test.js`):** seven new tests, using a fixture where `node_modules/middle/node_modules/shared` is a link to the top-level `shared`. They cover:
- The hook returns the actual package directory for the link (`node_modules/shared`), not the path through `middle`. It does the same on the mount's read-only view and on a sub-mount, the root maps to `[]`, and a missing path is left as given.
- No hook is produced for a plain local tree or for an arbitrary object.
- A link out of the root, and a sub-mount's link to a sibling directory, are both refused.
- The hook is refused after the mount is revoked.
- `node-modules-scan` over the mount gives one `shared` compartment (3 in total). The same files read as a plain local tree give 4, which shows the hook is what removes the duplicate.
- `node-modules-scan` rejects a dependency that links outside the root as an unsupported layout.

**Verification:**
- `npx ava test/capture-node-modules.test.js`: 9 passed.
- `npx ava test/mount*.test.js test/shell.test.js`: 169 passed.
- `eslint` on the changed files shows no errors. The test file is clean. The `mount.js` warnings are all on lines I didn't touch.
- `prettier --check` is clean after formatting the test file.
- `yarn tsc` in `packages/daemon` exited 0.

**Follow-ups for later children:** `EndoHost.makeFromTree` still needs `layout`/`entry` and the call into `captureNodeModules`. Running the result on Node and XS workers, and the pnpm workspace-link cases from the design's test plan, are also still to do.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-mount-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1493905 cached reads)
- Output: 15625 tokens
- Cost: $1.2716889999999998
- Wall-clock: 214s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
