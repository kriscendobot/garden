The work is complete and verified. Here is my completion report.

---

## Completion report: `improve-journal-entry-help-and-flaglike-kind-guard`

**Root cause.** `journal-entry.sh` took `$1` verbatim as `<kind>` with no help handling and no flag-shape validation, so `journal-entry.sh --help` minted and pushed a real journal entry (`kind: --help`, empty body) onto the add-only journal/message bus. The sibling producers `post-job.sh`/`post-plan.sh` had no `-h`/`--help` convention either (confirmed: none in `common.sh`).

**Changes (committed `7899b55e7`, pushed to `origin/main2`):**

- **`scripts/jobs/journal-entry.sh`** — added a `usage()` block; intercept `-h`/`--help` *before* consuming the positional (exit 0); reject a `<kind>` that begins with `-` or contains anything outside `[a-z-]` (also rejects empty), so a flag typo or odd character can never become a committed entry. Hyphenated kinds like `follow-up` still pass.
- **`scripts/jobs/post-job.sh`** — added `usage()` + `-h`/`--help` interception (it already rejected a leading-`-` basename); removed the now-stale "there is no usage" note in the rejection message.
- **`scripts/jobs/post-plan.sh`** — added `usage()` + an `-h`/`--help` case in its option-parse loop (it already rejected leading-`-` basenames and unknown options); help works even mid-args (`--priority high -h`).
- **`scripts/jobs/test/producer-arg-guard-test.sh`** (new, 13 assertions, all green) — hermetic regression test against a throwaway journal: `-h`/`--help` on all three prints usage, exits 0, and leaves the journal head unmoved (no clone/commit); flag-shaped and out-of-charset positionals mint nothing; the happy path still posts a well-formed entry/job/plan.

**Verification.** `bash -n` clean on all four files; ran the new test (PASS=13 FAIL=0); end-to-end smoke confirmed `--help` no longer mints an entry while `journal-entry.sh progress` still posts `kind: progress` correctly. Built in an isolated worktree off `origin/main2` per the garden-infra norm (explicit pathspecs, rebase-then-push, worktree torn down; no leftover scratch). Inbox empty; no peer/maintainer messages arrived.

**Follow-ups.** The pre-existing malformed entry `entries/2026/06/27/104604Z---help-gardener-f5074e.md` is on the orphan `journal2` branch (not touched by this `main2` change) — it remains in history as a harmless add-only artifact; no cleanup was attempted since the journal is append-only and rewriting it is out of scope. None other.
