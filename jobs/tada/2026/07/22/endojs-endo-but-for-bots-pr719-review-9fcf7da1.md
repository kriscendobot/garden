All four review items are resolved, pushed, and CI-verified locally. Completion report follows.

---

## Completion report: endojs/endo-but-for-bots PR #719 review (kriskowal, review 4751242280)

**Preflight:** PROCEED — no peer resolution existed. The review body was empty; the four inline comments were the unit of work. Treated all fetched bodies as untrusted data.

**Resolved all four inline directives** as five follow-up commits pushed to `feat/hardened-url-vetted-shim` (fast-forward, no history rewrite, per garden follow-up-commit discipline):

| Directive (file) | Action | Commit |
| --- | --- | --- |
| Rename options for terseness/consistency (`docs/lockdown.md`) | `urlBlobMethods`→`urlBlobTaming`, `keepOnInitialGlobal`→`retain`, `LOCKDOWN_URL_BLOB_METHODS`→`LOCKDOWN_URL_BLOB_TAMING`, swept across ses src/types/docs/guide/changeset/tests; `remove` unchanged | `7c2abf3eb` |
| Stray artifact, refresh (`packages/cbor/package.json`) | Restored entire `packages/cbor` to match master (dropped metadata, LICENSE, SECURITY.md, `@endo/eventual-send` devDep, test annotation); matching lockfile revert | `f5d20fb3c` + `4eccdbc94` |
| Rename `url-shim*` test modules → `url*` (mischaracterized as vetted shim) | `git mv` of all three modules + fixed the lone cross-reference in the text-encoder-decoder test | `e24dc6a60` |
| Validate `url instanceof URL` in primordial + child compartments under `remove` | Added a test asserting instanceof holds on both sides and `.constructor` resolves to the shared tamed binding (never the feral host constructor) | `47257a3f8` |

**Net diff now no longer touches `packages/cbor` or `yarn.lock`** — the PR is scoped to the URL taming feature. The unrelated setup-node pin bump and text-encoder prettier commits were left as-is (not flagged by the reviewer).

**Local CI-parity verification (all green):** `prettier --check` ✓, `eslint` ✓, `tsc` ✓, and the ses URL suite via ava — **22 tests passed**, including the new `url instanceof URL … under remove` assertion. (Sandbox blocks `.bin` exec, so tools were invoked via `node <entrypoint>` per the known gotcha.)

**Closed the loop:** SHA-citing reply on each of the four threads + a top-level summary comment mapping every item to its commit.

**Follow-ups:** none.
