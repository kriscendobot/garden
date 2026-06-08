---
ts: 2026-06-08T02:40:25Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--ed1f4c`) for a **first-time ferry** (Shape 1) of bots#401 to a NEW endojs/endo PR: a shellcheck `yarn shellcheck` script + CI workflow + .sh cleanups.

Source: endojs/endo-but-for-bots#401, branch `chore/shellcheck-ci`, head `46ba16528`, base frozen `master-814dfa1` (much older than current master `4a04d078b`), DRAFT, 3 commits (all endolinbot):
- `07f436210` fix(scripts): shellcheck cleanups across tracked .sh files
- `8ae9cf33a` chore(shellcheck): add yarn shellcheck script and CI workflow
- `46ba16528` fix(scripts): pass shellcheck targets via git blob to avoid argv limit
10 files: .github/workflows/shellcheck.yml (new), root package.json (shellcheck script), scripts/shellcheck.sh (new), + shellcheck fixes to ~7 existing tracked .sh files. No active upstream shellcheck PR (only ancient closed #205); workflow/script not on master; first-time.

Boatman brief (Shape 1): detach at current endo master `4a04d078b`; cherry-pick the 3 commits in order. **Conflict caution:** the `fix(scripts): shellcheck cleanups` commit edits ~7 .sh files that exist on master but may have changed since the stale base `814dfa1fd`; expect possible conflicts. Resolve mechanically (re-apply the shellcheck fix to master's current version of the file, or re-derive by running `shellcheck -S warning` on the conflicting file); if a .sh file diverged so much the fix is ambiguous, STOP and message liaison. Squash `8ae9cf33a`+`46ba16528` (the script add + its argv-limit fix) into one `chore(shellcheck): add yarn shellcheck script and CI workflow` if clean (one-voice-upstream), keeping the .sh-cleanups commit separate; OR keep 3 if cleaner. author+committer `Kris Kowal <kriskowal@kriskowal.com>` on all; strip (#)/Co-Authored-By/Generated-with/Refs trailers; RUN `interpret-trailers --parse` EMPTY (the source may carry Claude trailers - watch for them); new branch `kriskowal-shellcheck-ci`; open the upstream PR **--draft** (source is draft) with pr-formation body (what the workflow/script do; the paths-filter skip-when-no-.sh behavior; no fork refs); create garden-side cross-link on bots#401 (--paginate search; none exists -> create). `identity_switch_authorized: true`.

Expected report: new upstream PR URL + number, branch + head, conflict-handling outcome per .sh file, squash decision, Kris Kowal + trailers-empty, mergeable, CI, cross-link id.
