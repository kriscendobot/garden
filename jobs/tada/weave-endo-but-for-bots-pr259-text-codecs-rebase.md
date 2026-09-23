The weave is complete. All CI checks are freshly triggered and pending (two already green: dependabot, zizmor); none failed. My inbox is empty. This job mutated only the project repo, so there is nothing to commit to the garden's `main2`.

## Completion report

**Job:** weave (rebase) `endojs/endo-but-for-bots#259` ("feat(ses): permit TextEncoder and TextDecoder as universal intrinsics") onto current `master`.

**What I did:**
- The local bare clone was shallow with a graft that hid the true merge-base, so I `git fetch --deepen=200`'d `master` and the head branch to expose the real base (`c2fc02eb8b`, HEAD~3). Post-deepen: PR 3 ahead, `master` 251 ahead.
- Rebased the 3 PR commits onto `origin/master`. One conflict, in `packages/ses/src/permits.js`: `master` (#580, Temporal permits) and the PR (WHATWG TextEncoder/TextDecoder permits) both inserted a new permit block at the same location (after `Proxy`, before Appendix B), and the shared trailing `'@@toStringTag'`/`}` lines straddled the seam.
- Resolved by **keeping both** additions: closed `%SharedTemporal%` with its own `'@@toStringTag': 'string'` tail (verified against `origin/master`'s exact form), then appended the full TextEncoder/`%TextEncoderPrototype%`/TextDecoder/`%TextDecoderPrototype%` block. No `--ours`/`--theirs`. The other two commits (test coverage; the Chromium `cauterizeProperty` arguments/caller fix) applied cleanly.

**Verification:**
- Net diff vs `master` is byte-for-byte the same shape as the original PR: 5 files, 358 insertions, 1 deletion (permits.js still exactly +41).
- `node --check` on permits.js: OK. No conflict markers remain.
- `ses` tests: `text-codecs.test.js` + `text-codecs-missing.test.js` → 18/18 pass; `lockdown-*.test.js` → 3/3 pass.
- ESLint on all four changed files → exit 0, clean.

**Result:**
- Force-with-lease pushed `b2a3657fca → 7de74b4cdc` to `feat/hardened-text-codecs-shim`.
- PR base is `master` directly (not a frozen base), so no base-field update was needed.
- PR went `CONFLICTING`/`DIRTY` → **`MERGEABLE`** (`UNSTABLE` = CI in flight, no failures; browser-tests pending — that's where the Chromium fix commit matters, and it rebased unchanged).

**Follow-ups:** None required from the weave. CI is running fresh; if any check goes red a shepherd job can pick it up, but the affected `ses` package is locally green. I did not post a PR comment — the job carried no commenting authorization (weaver external-repo etiquette).
