The Bun runner now has subprocess tests for every zero-match case, and all 15 checks on endojs/endo-but-for-bots PR #1519 pass on the new head `911916382`.

Most of the runtime fix was already on the branch: commit `ab14532ae` ("test: fail Bun runs that select nothing", made shortly before I claimed this job) already rejected option-shaped and missing `--package`/`--file` values and failed when a requested package scheduled no AVA run. I pushed one commit on top of it, `911916382` ("test: cover Bun runner selections that match nothing"), to branch `bun-ses-permits`:

- **`scripts/test-bun.mjs`:** closed the one gap left. `--file pkg:--match=x` passed `--match=x` to AVA as a flag, so AVA would run the package's whole suite instead of the named file. The runner now rejects a test file that starts with `-`.
- **`scripts/test-bun.test.mjs` (new):** 14 AVA tests. Each copies the runner into a temporary repo with stub packages and a stub AVA that records each call, then runs it with `bun`. They check that these fail without AVA ever being called:
  - a missing package, by `--package` or by `--file`;
  - a package with no AVA suite (a non-AVA `test` script, or no scripts at all);
  - a repo where no package has an AVA suite;
  - selector values that look like options (`--package --fail-fast`, `--file --package`, `--file pkg:--match=…`), a missing value, a `--file` without a package or a test file, a package selected both whole and by `--file`, and an unknown argument.

  Two control tests check that a valid selection runs every requested package and passes the chosen test files through to AVA.
- **`.github/workflows/ci.yml`:** in the `test (Bun)` job, the single `! yarn test:bun --package @endo/does-not-exist` step is replaced by `yarn exec ava scripts/test-bun.test.mjs`, which covers that case and the rest.

**Checks:** with Bun 1.4.3 installed locally, all 14 tests pass. Against the runner as it was before `ab14532ae`, 12 of the 14 fail, so they catch the regression. Prettier and eslint are clean.

**Follow-ups:**
- The CI step that ran the real runner against the real repo is gone; the new tests use stubs. The real runner still runs in the three other Bun steps.
- No changeset was added, since `scripts/` is not a published package.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-test-bun-zero-match.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1218015 cached reads)
- Output: 11231 tokens
- Cost: $0.9182629999999999
- Wall-clock: 1002s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
