---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh

Failure signature (garden-comment-watcher@kriscendobot-moddable, exit 1, every tick):

  WARN: gh api repos/kriscendobot/moddable/issues/comments?since=...&per_page=100
        failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
  FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
  FETCH INCOMPLETE for kriscendobot/moddable ... exiting nonzero
  FATAL: comment source failed for kriscendobot/moddable (rc=1)

Cause: kriscendobot/moddable is a FORK with has_issues=false (verified:
`gh api repos/kriscendobot/moddable --jq '{fork,has_issues}'` → fork=true,
has_issues=false). GitHub returns 404 for the repo-wide
/repos/<o>/<r>/issues/comments endpoint when Issues are disabled. The 404 is
definitive, so the surface-1 block at line ~158 sets fetch_failed on EVERY
tick; the REPO-GONE degrade at line ~322 does not fire because
`gh api repos/<repo>` answers 200 (the repo exists — only the SURFACE is
permanently absent). Control reaches line ~380 and exits 1 forever: a
permanent systemd restart loop of exactly the class the REPO-GONE guard was
written to prevent, one rung down. Forks have Issues off by default, so every
own-fork watch auto-armed by scripts/jobs/fork-watch-provisioner.sh hits this.

Fix (deterministic, no new agent discretion): add an ISSUES-DISABLED degrade
alongside repo_is_definitively_gone(), on the already-failed path only so a
healthy tick pays nothing.

1. When surface 1 fails with a definitive 404 (NOT a transient signature —
   reuse _gh_api_stderr_is_transient), probe `gh api repos/<repo> --jq
   .has_issues` once. If the repo answers AND has_issues is false, this is a
   structurally-absent surface, not a lost fetch: do NOT set fetch_failed for
   it. A 404 with has_issues=true must keep today's freeze-and-retry behavior
   (never guess a state).

2. Do not silently drop pr-comment coverage. With Issues disabled the
   per-PR endpoint still answers — verified on this repo:
   `repos/kriscendobot/moddable/issues/2/comments` → [] (200), and
   `repos/kriscendobot/moddable/pulls/comments` → [] (200). So in the
   issues-disabled mode, replace the repo-wide surface-1 fetch with a walk of
   the open-PR list the source ALREADY enumerates for section 3, calling
   `repos/<repo>/issues/<n>/comments?since=…&per_page=100` per open PR, and
   emit the same pr-comment rows (`since` filter, self-authored `$bot` drop,
   and the html_url `test("/pull/")` classification all unchanged). Guard each
   per-PR call with note_fetch_failure so a genuine blip mid-walk still freezes
   the cursor — the LOST-FETCH invariant must survive this change intact. The
   issue-comment surface is legitimately empty on such a repo (no issues can
   exist), which is a fact, not a gap.

3. Log the mode once per tick at the existing log() level, e.g.
   "ISSUES DISABLED on <repo> — repo-wide issues/comments is 404 by
   configuration; enumerating PR conversation comments per open PR instead".
   No alert_maintainer: unlike REPO-GONE this needs no human action and would
   fire on every auto-armed fork.

Regression tests in scripts/jobs/test/comment-watcher-test.sh, following the
existing gh-stub shape (see the SS1 block ~line 1392):
  - repo-wide /issues/comments stubbed 404 + repos/<repo> stubbed
    has_issues=false → source exits 0, and a PR conversation comment placed on
    an open PR via /issues/<n>/comments IS still emitted as surface pr-comment
    (proves coverage is preserved, not merely that the crash stopped).
  - same 404 but has_issues=true → unchanged: fetch_failed, exit 1, cursor
    frozen (proves the LOST-FETCH invariant is not weakened).
  - a transient 5xx on /issues/comments with has_issues=false → still the
    transient path, never the new degrade.
