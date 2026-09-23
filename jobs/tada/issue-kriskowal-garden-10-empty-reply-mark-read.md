All done. Worktree torn down, comment posted, push confirmed.

---

## Completion report

**Job:** `issue-kriskowal-garden-10-empty-reply-mark-read` — implement two missed kriskowal replies on kriskowal/garden #10 fixing the GitHub Pages bulletin's reply behavior.

**What I did**
- Built in an isolated worktree off `origin/main2` (not the deployed root checkout), committed with explicit pathspecs, pushed `HEAD:main2` via rebase-CAS (clean push, no contention).
- Drained inbox (empty) and re-read the live #10 thread before pushing — issue is OPEN, no stand-down, the two requests matched the work.

**What changed** (commit `b72555a1d`, two files):
- `docs/bulletin/app.js` — removed the `if (!body) … 'write a reply first'` validation gate in `submitReply`. An empty box is now allowed: empty = mark-as-read only (no reply file, no target resolution); non-empty = resolve target, post the reply, **and** mark-as-read. Status/commit messages branch on the empty case ("marking read…" / "marked read").
- `docs/bulletin/github.js` — `commitReply` now POSTs the reply blob and adds it to the tree **only when** a `replyPath`/`replyBody` is given; an empty ack builds a commit with just the `unread → read` move (add to `…/read/` with the original blob sha, delete from `…/unread/`).

**Verification**
- `node --check` on both files (parse clean).
- A node harness that loads the **actual** `github.js` with stubbed `fetch`/`window`/`localStorage`:
  - Empty ack → 2-entry tree (read add + unread delete), **zero** blob POSTs. PASS.
  - Non-empty reply → 3-entry tree (reply blob + read add + unread delete), 1 blob POST. PASS.
- Confirmed the string "write a reply first" no longer appears anywhere under `docs/bulletin/`.

**Communicated on the issue** (per comms directive, not the maintainer inbox): summary reply posted to https://github.com/kriskowal/garden/issues/10 with the commit SHA, both behaviors, and the verification results.

**Follow-ups**
- The separate watcher fix (so replies made while an issue is briefly closed aren't dropped — the root cause of these two replies being missed) is noted as already queued as its own job; I did not touch it here.
