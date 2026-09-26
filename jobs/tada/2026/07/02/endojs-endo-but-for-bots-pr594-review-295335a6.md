All work is complete and verified. Writing the completion report.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #594 (kriskowal, CHANGES_REQUESTED): *"Please use JavaScript for the driver script. Use zx if that helps keep it concise, or drive eslint by API if that is more concise."*

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved it. Review enumeration confirmed the review has **no inline comments**; the top-level body was the sole ask.

**What I did:**
- Reimplemented `scripts/eslint-repo.sh` as **`scripts/eslint-repo.mjs`** (`#!/usr/bin/env node`, `node:child_process`/`node:fs`), matching the repo's existing `.mjs` script convention (pack-all.mjs, compare-pack.mjs, etc.). Set the exec bit; `git rm`'d the `.sh`.
- Pointed `package.json` `lint:eslint` at the `.mjs`; updated the changeset's script reference.
- **Deliberately did NOT drive ESLint via its in-process Node API** (one of the maintainer's suggested options): the whole point of this PR is one bucket's worth of TypeScript programs *per process*, and typescript-eslint's program cache is module-global — a single-process API run would re-accumulate the whole-repo program set and re-cross the exact ceiling being fixed. Each bucket is therefore still a fresh `eslint` child process. Documented this reasoning in the commit and the PR reply so the choice isn't mistaken for an oversight.
- Resolved ESLint's CLI via `require.resolve('eslint/package.json')` so the driver doesn't depend on `eslint` being on PATH.
- Updated the PR body (removed the now-dead `scripts/eslint-repo.sh` / `shellcheck` references; corrected the bucket description).
- Posted a review reply on the PR documenting the resolution (comment #4866973037).

**Verification (real execution):**
- Batching parity via a stubbed eslint: 53 packages → 6 buckets (where/zip isolated in the tail bucket) + 1 top-level batch; dot-dirs (`.github`, `.changeset`, …) correctly excluded to match the shell `*/` glob; `--fix` forwarded to every batch; `ESLINT_BUCKET_SIZE` honored.
- **Full `yarn lint:eslint` over the whole repo ran green: exit 0, 0 errors, 5 warnings** (the pre-existing `daemon`/`compartment-mapper` warnings) — exact same result the shell driver produced.
- `prettier --check scripts/eslint-repo.mjs` clean; the `scripts/` lint batch linted the new `.mjs` itself with 0 errors.
- `yarn lint:sh` exit 0 (removed `.sh` cleanly drops from the shellcheck set); no lingering references to `eslint-repo.sh` anywhere.

**Changed & pushed:** commit `323535ab9` on `chore/lint-eslint-per-package-batches` (pushed `3473f5df2..323535ab9`, CAS on first attempt). Files: `scripts/eslint-repo.mjs` (added), `scripts/eslint-repo.sh` (deleted), `package.json`, `.changeset/lint-eslint-per-package-batches.md`.

**Follow-ups:** none required. The PR's own `lint` CI job is the authoritative gate for the CI-specific tail-drop (unreproducible on dev hosts by design, as the PR notes); the driver invokes the same `eslint` binary with identical arguments, so behavior is unchanged.
