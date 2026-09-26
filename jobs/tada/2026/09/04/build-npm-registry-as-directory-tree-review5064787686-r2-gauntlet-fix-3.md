Gauntlet FIX round 3 for endojs/endo-but-for-bots PR #1117 complete.

**What I did:** Applied the three aggregated must-fix items from the round-3 panel verdict, pushed them as one review-feedback follow-up commit (`f622f6731`) to the PR head `build/npm-registry-as-directory-tree`, and watched CI to terminal.

**Changes (`packages/exo-npm`):**
1. **`src/registry-tree.js` — has⇔lookup asymmetry.** `npmHub.has` ran *every* path segment through `scopedPackageSegments` (npm's `^[a-zA-Z0-9._-]+$` charset), while `lookup` normalizes only the leading segment. It now normalizes only `path[0]` exactly as `lookup` does, so a version or in-tree file whose name carries a space, `+`, or non-ASCII character is no longer reported absent by the no-throw predicate. Pinned by a new hardening regression test (`'has does not apply the npm name charset to version or in-tree file segments'`).
2. **`src/errors.js` — non-passable errors.** `RegistryNotFoundError`/`RegistryPathSyntaxError`/`RegistryOfflineError` installed own `errorName`/`registryErrorName` properties via `annotateRegistryFailure`, making every minted error non-passable (pass-style rejects any own property outside `{message,stack,cause,errors}` regardless of enumerability). Removed the helper; they now carry classification through `makeError(X\`…\`, RangeError|SyntaxError, { errorName })` — SES tags out-of-band via `tagError`, keeping the native class and message-prefix classification. Verified with a real SES round-trip (`passStyleOf` → `'error'`, `mustMatch(err, M.error())` passes) for all four factories. Rewrote the hardening test to exercise the real marshal boundary instead of a hand-built stand-in copy; updated two conformance assertions that checked the removed own property.
3. **`types.d.ts` + changeset — root-export drift.** Dropped the `comparePublishedVersions` declaration from the root-shadowing `.d.ts` (and the changeset claim); `index.js` never re-exported it, so the declaration made `import { comparePublishedVersions } from '@endo/exo-npm'` typecheck then fail at runtime. It remains reachable via the `./registry-tree.js` subpath.

**Verification:** `yarn test` (67 tests, was 66 — added regression), `yarn lint` (0 errors), `yarn lint:types`/tsc clean.

**CI:** all 27 checks SUCCESS on head `f622f6731` (GREEN, rc 0 equivalent).

**Notes:** Applied only the three aggregated must-fix items per stage discipline; per-seat should-fix/comment-only findings (prerelease range selection, `fallbackHash` reuse, unbounded caches, Endor bare-`Far` nodes, `globalThis.fetch` sniffing) were not touched. The stage was reaped several times mid-CI-watch; the fix commit and push survived each requeue, and CI reached green on resume.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 140 tokens (6642294 cached reads)
- Output: 39030 tokens
- Cost: $9.043766500000002
- Wall-clock: 1860s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
