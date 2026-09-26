Follow-up job posted. The work is complete. Final report:

---

## Completion report: garden-harden-producer-body-read-hang

**What I found on `origin/main2` tip (local HEAD was behind):**
- `journal-entry.sh` was **already fully fixed** by a peer — it carries the `-h/--help` guard, the dash-led/charset kind guard, *and* the body-source guard. Its regression test `journal-entry-argv-test.sh` is committed and green (19/19).
- `post-plan.sh` and `post-job.sh` had the `--help`/flag-shape guards but **still carried the unguarded `read_body()`** — the exact inline-body-string → `cat`-on-stdin hang the job describes.

**What I changed** (built in an isolated worktree off `origin/main2`, explicit pathspecs, pushed `HEAD:main2` as commit `310dfcece`):
- `scripts/jobs/post-plan.sh` — added the body-source guard (option 1, the `land-journal-edit.sh`/`journal-entry.sh` discipline): a non-empty body arg that is not a readable file is a hard `die`, never a silent stdin read. Fires before any clone/lock.
- `scripts/jobs/post-job.sh` — same guard. The job named only post-plan.sh + journal-entry.sh, but post-job.sh shares the identical hang class against the same shared producer lock, so per the "proactively fix the garden" directive I hardened it too.
- `scripts/jobs/test/producer-body-hang-test.sh` (new, hermetic, throwaway journal) — for all three producers asserts an inline non-file body arg with stdin from `/dev/null` exits **promptly** (wrapped in `timeout`, so a real hang trips exit 124 → FAIL), exits **non-zero** (the refusal), names the body-source error, and **mints nothing** (journal head unmoved); plus `journal-entry.sh --help` exits 0 posting nothing. **14/14 pass.**

**Verification:** new test 14/14; `journal-entry-argv-test.sh` still 19/19. No regression to existing producers.

**Follow-up I posted** (`garden-fix-producer-arg-guard-uppercase-kind`): while running the sibling tests I found `producer-arg-guard-test.sh` has **2 pre-existing failures on a clean `origin/main2`** (confirmed identical with/without my edits) — it expects `journal-entry.sh Progress` (uppercase kind) to be rejected, but the actual kind guard admits uppercase letters. That's an independent test/code divergence requiring a behavior decision (tighten the guard to lowercase-led, the likely-correct fix, vs. loosen the test); I left it to the follow-up rather than bundle an unrelated behavior change into this commit. Body posted by **file**, per this job's own lesson.
