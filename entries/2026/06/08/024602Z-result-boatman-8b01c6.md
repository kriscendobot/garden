---
ts: 2026-06-08T02:46:02Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/08/024025Z-dispatch-liaison-ed1f4c.md
---

First-time ferry (Shape 1) of endojs/endo-but-for-bots#401 (`chore/shellcheck-ci`, head 46ba16528, DRAFT) to a new upstream PR.

**Upstream PR:** https://github.com/endojs/endo/pull/3300 (#3300), DRAFT. Branch `kriskowal-shellcheck-ci`, head a26f74725. Base `master` at 4a04d078b (verified live via `git ls-remote`; the bot-side frozen base `master-814dfa1` was much older but did not propagate upstream).

**Conflict handling per .sh file:** all 7 tracked-script cleanups (compartment-mapper/test/neutralize.sh, nat/scripts/npm-audit-fix.sh, check-packages.sh, maintenance/check-unused-deps.sh, npm-audit-fix.sh, posttypedoc.sh, set-versions.sh) cherry-picked CLEAN onto current master, no conflicts, no re-derivation needed. master's versions matched the stale-base context. shellcheck was not installed locally; not needed since no conflict arose. Sanity-checked the diffs: mechanical SC fixes (shebangs, `|| exit`, `read -r`, `find -print0 | xargs -0`, `CDPATH=''`, dropped unused `DIR`, process-substitution under the correct bash shebang). package.json script-add auto-merged clean; new files (`scripts/shellcheck.sh`, `.github/workflows/shellcheck.yml`) applied additively.

**Squash decision:** squashed source commits 8ae9cf33a (script+workflow add) + 46ba16528 (git-blob argv-limit fix) into ONE `chore(shellcheck): add yarn shellcheck script and CI workflow`, keeping the cleanups as a separate `fix(scripts): shellcheck cleanups across tracked .sh files`. Final: 2 commits. The squashed body absorbed the argv-limit rationale and dropped the fork-side `endojs/endo-but-for-bots#401` reference the source's argv commit carried.

**Attribution + trailers:** both commits Kris Kowal <kriskowal@kriskowal.com> author AND committer (verified `--pretty=fuller`). `interpret-trailers --parse` EMPTY for both. The source endolinbot commits carried NO Co-Authored-By / Claude / Generated-with trailers, so none to strip; the gate confirmed clean rather than relying on the pre-inspection.

**Net diff:** exactly the 10 expected files (workflow + package.json + shellcheck.sh + 7 .sh cleanups), 95 insertions / 15 deletions, no stray files from conflict resolution.

**Mergeable:** MERGEABLE. **CI:** all checks pending at report time, including the new `shellcheck` check firing (confirms the workflow's `paths: **/*.sh` filter triggers, since the PR touches .sh files). Did not wait.

**Cross-link:** searched source #401 comments with `--paginate`, none existed; created `Mirror of https://github.com/endojs/endo/pull/3300 (head a26f747).` (comment id 4645026707) under kriskowal on the garden fork. No upstream-side comment (per 2026-05-29 directive). No `message: boatman → steward`.

Host preconditions passed: `gh auth status` kriskowal active; `gh api repos/endojs/endo --jq .permissions` push:true, admin:true.

Self-improvement: nothing this time. The ferry exercised Shape 1 cleanly; the squash-with-soft-reset-then-rebuild sequence (cherry-pick all, soft-reset to squash, then rebuild both commits on master with `--reset-author` to normalize endolinbot author->Kris Kowal) is already captured in pr-handoff § Attribution discipline. One minor reaffirmation worth noting in-band: cherry-picking a commit that was itself created by an earlier `git commit` in the same session (the squashed one) inherits the session's committer, so a final `-c user.name=... commit --amend --no-edit` is still needed to normalize the committer; the existing skill's per-commit verify-then-amend loop already catches this.
