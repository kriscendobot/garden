All 29 tests pass, including the two cases this job's regression-test requirement asks for. Nothing to change or commit — the work is already in place on `origin/main2`.

---

**Completion report**

This job was already fully resolved by commits already on `origin/main2`; my worktree (checked out off `origin/main2`) contains the finished state and needs no further changes.

**What the job asked for vs. current state:**

1. **The rev-parse hardening** — `scripts/jobs/triager.sh:59-61` already makes both `git rev-parse` calls strict with `--verify -q` and peels to `^{commit}`:
   ```sh
   new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
               || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
     || die "cannot resolve ref '$ref' in $slug"
   ```
   Landed in `469cab011` (`--verify -q`) and `80acdfce0` (`^{commit}` peel). This is exactly the block the job specified, so a failed primary lookup now yields empty stdout instead of echoing its argument — no two-line `new_sha` can reach `$GARDEN_TRIAGE_HANDLER`.

2. **Defense-in-depth tripwire** — `triager.sh:67-68` asserts `new_sha` is a single 40-hex SHA (`7cc020469`), failing loudly at the source rather than as an "ambiguous argument" fatal in the handler.

3. **Regression tests** — `scripts/jobs/test/triager-test.sh` already contains the requested case and more:
   - **Test E**: primary ref (`refs/remotes/origin/main`) absent, fallback resolves → asserts `new_sha` is a single clean SHA line (CALL_LOG single-line guard + exact SHA match).
   - **Test F**: a `git` shim reproduces the exact production two-line corruption → asserts the guard fires, handler never runs, cursor not advanced.

**Verification:** ran the full suite — **29 passed, 0 failed**.

**Changed:** nothing (no diff, no commit, no push) — the fix and its tests were already present and green.

**Follow-ups:** none.
