No reply pending. This is a legitimate terminal state for a duplicate build per the builder norm. Let me write the completion report.

The job is genuinely complete: I built and fully verified the implementation, then discovered it duplicates an already-green PR, and surfaced that to the maintainer rather than opening a competing PR.

---

## Completion report — build-hardened-url-vetted-shim

**Outcome: DUPLICATE. No competing PR opened (builder no-duplicate norm).**

### What I found
The M2 `hardened-url-shim` design is **already implemented** by open PR **endojs/endo-but-for-bots#719** ("feat(ses): permit URL and URLSearchParams as a vetted shim (%URL%/%SharedURL% split)", head `feat/hardened-url-vetted-shim`, base `master`). It is **un-drafted** (passed the gauntlet) with **all CI green** (lint, cover, test-xs, test262, hermes, 22.x/24.x × ubuntu+macos).

Its ses implementation matches the design exactly — the Date-style `%URL%`/`%SharedURL%` split, `URLSearchParams` on `universalPropertyNames`, the hidden `%URLSearchParamsIteratorPrototype%` sampled in `get-anonymous-intrinsics.js` and hardened, and the `lockdown({ urlBlobMethods: 'remove' })` opt-in.

### What I did
- Studied the design and the SES internals (Date-style split mechanics, intrinsics collector, whitelist traversal, global-object install, anonymous-intrinsic sampling).
- **Built a complete, clean implementation independently** in an isolated project worktree (off `master` @ `536f82d`): `tame-url-constructor.js`, permits (`%URL%`/`%SharedURL%`/`%URLPrototype%`/`URLSearchParams`/`%URLSearchParamsPrototype%`/`%URLSearchParamsIteratorPrototype%` + the three bucket entries), the iterator-prototype sampler, the `urlBlobMethods` lockdown option + type, a changeset, and 3 test files (20 tests).
- **Verified end-to-end**: all 20 tests pass; regression evidence confirmed (disabling the sampler fails 3 iterator tests); eslint / tsc (TS 6.0.3) / prettier / spell-out-identifiers / typist-friendly / typedefs-belong-in-dts gates all clean; the only repo-wide test/tsc failures are pre-existing `text-encoder-decoder` breakages present on clean `master`.
- My implementation **converged nearly line-for-line with #719's `tame-url-constructor.js`**, confirming #719 is correct and canonical.

### Why no PR
Per the builder role's explicit norm ("verify no open PR already implements the issue … skip and surface the existing PR number if a duplicate would result"), I did not open a competing PR. Opening one would pollute the board and the fork with a redundant outward-facing PR.

### Surfaced to maintainer (via liaison)
Messaged the maintainer flagging #719 as the canonical implementation and noting one **diff-hygiene blemish**: #719's branch carries **3 unrelated commits** — `fix(cbor): …` (adds a whole `packages/cbor/` package) and `fix(ci): correct setup-node pin annotations` (8 `.github/workflows/*.yml`). The URL shim itself is only the 3 ses commits. Recommended either (a) retcon/rebase #719 to ses-only then merge, or (b) let me push a clean ses-only rebuild (ready in-worktree). Awaiting their choice.

### Follow-ups
- **Maintainer decision needed**: clean #719 in place, or promote a clean rebuild. If (b), repost/promote this base and I'll push the ready implementation.
- Pre-existing, unrelated: `packages/ses/test/text-encoder-decoder.test.js` fails at runtime and tsc on clean `master` (3 assertions + 1 TS2345) — not touched by this work, worth a separate fix job.
