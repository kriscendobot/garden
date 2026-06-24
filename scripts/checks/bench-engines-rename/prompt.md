You are a focused-fix subagent dispatched by the pre-dispatch grep-gate
runner. The `bench-engines-rename` gate fired in this repository: one
or more files contain a reference to `.bench-engines`.

# The pattern

`.bench-engines` is a renamed-by-mistake form of `.engines`.

# The maintainer's reasoning

The canonical path on endojs/endo is `.engines`. The steward
misapplied a rename to `.bench-engines` twice during PR #387 before the
second attempt cost a force-push to reverse. Per the endojs/endo#3294
discussion thread r3342643104, the rename is wrong because "nothing
limits us from using engines for other workflows" beyond benchmarks.
The hyphenated `.bench-engines` name conflates the bench workflow with
the directory and forecloses reuse for other workflows.

# What to do

1. Re-run the gate's grep to enumerate every site:

   ```
   git grep -nF '.bench-engines'
   ```

2. For each hit, replace `.bench-engines` with `.engines`. Cases to
   handle:

   - File paths in source, tests, scripts: rename the directory if it
     literally exists on disk (`git mv .bench-engines .engines`); then
     update every literal reference.
   - Comments and documentation: replace the literal string.
   - YAML / JSON / TOML keys named `bench-engines`: rename to `engines`.
   - If the only hit is in a file that documents the antipattern
     itself (a README or a skill explaining why `.bench-engines` is
     wrong), leave that file alone: the antipattern documentation is
     load-bearing.

3. Run the gate again to confirm clean exit:

   ```
   scripts/checks/run-all.sh --gate bench-engines-rename
   ```

4. Stage and commit the change with a subject that names the
   reversal, for example:

   ```
   fix: revert .bench-engines back to .engines
   ```

   Commit body should cite this gate and the originating discussion
   (`endojs/endo#3294` discussion thread `r3342643104`) so the
   provenance survives.

# Out of scope

- Touching the gate's own files under
  `scripts/checks/bench-engines-rename/`. The gate documents the
  antipattern and must keep mentioning the string.
- Renaming `engines` to anything else.
- Wider refactoring of the build / bench plumbing that surrounds the
  directory. The fix is the literal-string reversal.
