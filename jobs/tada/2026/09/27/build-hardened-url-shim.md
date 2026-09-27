## Completion report: `build-hardened-url-shim`

I built M2's hardened URL shim in endojs/endo-but-for-bots and opened it as a draft PR, **[endojs/endo-but-for-bots#1356](https://github.com/endojs/endo-but-for-bots/pull/1356)**. It stays draft, per the manual-gauntlet rule. The branch `build/hardened-url-shim` is one commit, `feat(ses): tame and permit URL and URLSearchParams`, based on the frozen `master-6ee3fda` (current `master` tip, the same base the sibling #1349 uses).

### What changed (all inside `packages/ses`, plus docs)
- **`URLSearchParams`** is now available in every compartment, one shared constructor. The prototype of its iterators could only be reached through an instance, so SES missed it. It is now sampled as `%URLSearchParamsIteratorPrototype%` in `get-anonymous-intrinsics.js`, which gets it permitted and frozen. That closes the design's first hazard: one compartment changing how another iterates.
- **`URL`** follows the same split SES uses for `Date`, in a new `src/tame-url-constructor.js`:
  - The start compartment's `URL` keeps `createObjectURL` and `revokeObjectURL`.
  - Every compartment created after lockdown gets a `URL` without them.
  - Both share one `URL.prototype`, so `instanceof URL` holds across compartments in both directions.
  - `parse` and `canParse` are kept on both.
- **New lockdown option `urlBlobMethods`** (`'keepOnInitialGlobal'` by default, or `'remove'`; environment variable `LOCKDOWN_URL_BLOB_METHODS`). With `'remove'`, no compartment has the blob methods and all share one `URL`. It is documented in `docs/lockdown.md` and typed in `types.d.ts`.
- **Hosts without `URL`** (XS) contribute nothing, and lockdown behaves as before.
- **Tests:** three new test files cover design test-plan items 1–8, and a new block in `test/_xs.js` covers item 9 (XS). A changeset `.changeset/hardened-url-shim.md` is included.
- **Downstream audit (Phase 3):** nothing outside SES calls `createObjectURL` or `revokeObjectURL`.

### Where I departed from the design (all explained in the PR body)
- **Name:** the start-compartment intrinsic is `%InitialURL%`, not the design's `%URL%`, to match `%InitialDate%` and the other start-compartment entries.
- **Blob methods are wrapped:** Node.js defines them as plain functions that each carry a mutable `prototype` object, which made SES print a warning on every lockdown. The start compartment gets small forwarding methods instead.
- **Node's `inspect.custom` method is kept:** without it, lockdown warns on Node.js and `console.log(url)` output gets worse.
- **Open questions:** for both of the design's open questions I took its recommendation (the iterator-prototype name, and one shared prototype). The maintainer can overrule either in review.

### Verification
- `packages/ses`: `yarn test` passes 547 tests (the 2 "known failures" are existing expected-failure tests, not mine), `yarn lint` is clean, and `yarn test:xs` passes including the new URL block.
- Repo-root `tsc -p tsconfig.json`: clean.
- Garden pre-push gates: all 8 pass. The abbreviation probe flagged `args`; I renamed it to `rest`.
- `local-verify.sh`: the whole-monorepo lint step ran out of memory, so lint only ran for `packages/ses`. The test step passed everywhere except 69 daemon integration tests, which fail with `listen EINVAL` because the worktree path makes the socket path too long (a known local limit). I tried shorter socket paths, but the sandbox refused them with `EACCES`, so the daemon integration tests never ran against this change. CI will be their first run.

### Follow-ups
- On `master`, lockdown on Node.js already warns about removing `inspect.custom` and `@@toStringTag` from the `TextEncoder`/`TextDecoder` prototypes. That gap comes from the text-codecs work (#1349's territory), not this PR, and can be fixed the same way I handled `URL`.
- #1356 and #1349 both add a block to the end of `test/_xs.js`. If both land, the second may need a small rebase.
- I couldn't drain my inbox at the end because the journal clone timed out (offline); nothing had arrived before that.
- Next steps are the maintainer's: **run the gauntlet #1356**, and settle the two open questions if they prefer something other than the design's recommendations.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-hardened-url-shim.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 106 tokens (6277244 cached reads)
- Output: 34025 tokens
- Cost: $3.0929168
- Wall-clock: 831s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
