Work complete. Here is my report.

---

## Completion report: `improve-scripted-journal2-content-edit-landing`

**What I did.** Moved journal2 *content-file* edit landing off agent judgment into a script, eliminating the manual-rebase-of-the-live-worktree hazard that bit the scholar on 2026-06-27. Landed on `origin/main2` as commit `89e5db9fb` (built in an isolated worktree off `origin/main2` per garden-infra discipline, since the shared `/home/kris` tree is concurrently mutated by other gardeners).

**What changed.**

- **New `scripts/jobs/land-journal-edit.sh`** — generalizes `journal-entry.sh`'s producer-clone discipline for whole-file content edits. Takes a journal2-relative path under an allowlisted tree (`library/`, `projects/`, overridable via `GARDEN_EDITABLE_TREES`) plus a body (body-file or stdin); inside the isolated `${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}` clone it runs `sync_clone` (fetch + hard-reset to `origin/journal2` tip), writes the file, `git add`s it, and `commit_and_push`es with the existing CAS retry/backoff loop and `_verify_pushed` silent-loss guard. Refuses absolute paths, `..` traversal, out-of-allowlist top-level dirs (exit 2), and refuses to operate on the live `$GARDEN_ROOT/journal` worktree even if `GARDEN_PRODUCER_CLONE` is pointed at it — mirroring the read-side guarantee documented in `library-link-check.sh`. Documents whole-file-replace semantics and the read-tip-then-append pattern for shared indexes like `keywords.md`.
- **New `scripts/jobs/test/land-journal-edit-test.sh`** (sibling to `library-link-check-test.sh`) — hermetic throwaway bare journal2; **18 assertions, all passing**. Covers: a new file and a modify both reaching `journal2`, a `projects/` edit, idempotent no-op re-land, and rejection (exit 2, nothing landed, live tree left clean) of out-of-allowlist / `..`-traversal / absolute / live-worktree-clone paths.
- **Pointed the docs at the lander as the only sanctioned landing path**, replacing manual `git`/`rebase` instructions that let an agent pick the live worktree: `skills/library-lookup/SKILL.md` (step 5 rewritten), `roles/scholar/AGENT.md` (step 9 + a new operating norm), `roles/librarian/AGENT.md` (a content-edit norm), and `skills/journalism/SKILL.md` (curated-trees landing guidance). Each cites the 2026-06-27 incident as the why.

**Follow-ups / notes.**
- The lander does a **whole-file replace**, not a patch. For wholesale edits (a concept page, a new section, added frontmatter) this is exactly right; for appends to a shared index, the docs instruct passing tip-content-plus-your-line as the body. A rare concurrent append the CAS loop can't see is caught by the scholar's next index-integrity pass — documented, not silently lossy.
- I did **not** rewire scholar per-job-procedure **step 1** ("Fetch and rebase `journal/`"), which is a *read*-side sync in the dispatch worktree, not the landing hazard; left as-is to stay in scope.
- The change is on `origin/main2`; the live `/home/kris` tree is clean and will fast-forward via the watchman.
