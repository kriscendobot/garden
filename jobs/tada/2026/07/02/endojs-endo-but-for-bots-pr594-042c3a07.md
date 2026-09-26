Work complete. Summary:

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #594 — kriskowal asked to verify a suspected performance regression from linting one process per package, and to "group the lint jobs into reasonably sized buckets."

**Preflight:** ran `pr-feedback-preflight.sh` → exit 0 (no peer resolution), proceeded.

**Verification (the directive's "please verify"):** confirmed with real CI wall-clock on the `lint` job:
- base `master`, single `eslint .`: **4m33s**
- PR #594, 57 processes (one per package): **6m32s** — a **~44% / +2min regression**, exactly the duplicative-tsc-startup cost kriskowal predicted.

**Fix implemented:** rewrote `scripts/eslint-repo.sh` to lint packages in **bounded buckets** — `ESLINT_BUCKET_SIZE` packages per process (default 10) — plus one batch for the top-level non-package dirs. The 53 packages now lint in **7 processes (6 buckets + 1)** instead of 57. Bounding by package *count* preserves the PR's "no service ever spans the whole repo" guarantee; `ESLINT_BUCKET_SIZE` is tunable for future headroom.

**Verified behavior (dry-run with an eslint stub):**
- default → 7 batches (10/10/10/10/10/3 packages + 1 non-package batch)
- directory-argument union is **identical** to the paths `eslint .` walks (coverage preserved by construction)
- `--fix` forwarded to every batch; `ESLINT_BUCKET_SIZE=1` reproduces old per-package behavior; large size collapses to 2 batches
- `shellcheck` clean

**Changed files (pushed to PR head `chore/lint-eslint-per-package-batches` as 3473f5df2):**
- `scripts/eslint-repo.sh` — bucketed
- `.changeset/lint-eslint-per-package-batches.md` — updated to describe bucketing

**Comms:** posted a top-level reply comment on the PR ([#issuecomment-4862118044](https://github.com/endojs/endo-but-for-bots/pull/594#issuecomment-4862118044)) with the verification data, the fix, and the SHA, carrying the `garden-reply:4862087129` marker.

**Follow-ups:** the actual speedup lands as the `lint` job on this PR's next CI run (expected back near the ~4m30s baseline, well below 6m32s); worth a glance when it runs, but no action owed. No garden (main2) changes were needed — this was project-repo-only work.
