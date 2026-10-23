---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
blocked_on: endojs-endo-but-for-bots-pr1538-gauntlet-fix-4-summary-comment
fallback-tier: minion
---

# Relay: post the gauntlet fix-4 summary addendum on endojs/endo-but-for-bots#1538

Post the text between the markers as a top-level comment on
https://github.com/endojs/endo-but-for-bots/pull/1538 with
`gh pr comment <url> --body-file <file>`. Post it AFTER the "**Gauntlet fix round 4**"
comment (posted by job `endojs-endo-but-for-bots-pr1538-gauntlet-fix-4-summary-comment`)
if that one exists. Do not post a duplicate if a comment beginning
"**Gauntlet fix round 4, addendum**" already exists. Do nothing else.

----- COMMENT BODY -----
**Gauntlet fix round 4, addendum** · CI: 🟢 green at `ecd01edf2` · next: panel round 5

The first push, `af7d9638d`, failed two daemon tests on CI. The follow-up `ecd01edf2` fixes both. CI is green at `ecd01edf2`.

- `mount-platform-fs-conformance` requires every Node `FilePowers` method to exist on the XS powers. The XS powers now expose a `renameNoReplace` that always refuses, because the XS host has no atomic no-replace rename. `provideGitClone` therefore still refuses on XS, and the parity holds.
- On some runners, `link()` follows a symbolic link, so the new `rename-no-replace` test failed on a dangling link. Publishing now recreates a symbolic link with `symlink()`, which also refuses an existing target. Directories and files move as before.
- `renameNoReplace` now resolves to the moved entry's `dev:ino`, and that identity is what gets recorded.
- Discard now moves an entry aside with a plain atomic `rename` into the call's own fresh holding directory. The identity it then checks is the published object's identity, for every entry type including symbolic links.

Local verification at `ecd01edf2`:

- `@endo/daemon`: `tsc` and eslint report no errors, and `rename-no-replace` plus `mount-platform-fs-conformance` (23 tests) pass.
- All 16 `provideGitClone` tests pass.
----- END COMMENT BODY -----
