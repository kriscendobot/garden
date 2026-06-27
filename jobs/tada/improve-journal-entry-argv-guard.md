Job complete. Completion report:

---

**Job: improve-journal-entry-argv-guard — done**

**What I did**

Hardened `scripts/jobs/journal-entry.sh` against malformed first-argument (`kind`) values and inline-body misuse, the same unguarded-argv class as the inline-body stdin hang (`garden-harden-producer-body-read-hang`):

1. **`-h`/`--help`** — now recognized as a query: prints the existing comment-block usage header (via the same `awk` idiom `land-journal-edit.sh` uses) and exits 0 **without** writing or pushing. This closes the exact hole that produced the stray `entries/2026/06/27/115515Z---help-gardener-a67841.md`.
2. **Malformed kind** — rejected with a fast `die` *before* the clone/push loop. A real kind must be a letter-led token of `[A-Za-z0-9_-]` (covers every kind in use: progress, claim, result, message, dispatch, error, tick, worktree, …). Dash-led (`--foo`), digit-led (`1bad`), and illegal-char (`res ult`) kinds all fail non-zero. I deliberately did **not** hard-restrict to a fixed kind set — the journal history shows ~30 distinct kinds in active use, so a closed allowlist would have broken real callers.
3. **Body-source guard** — a non-empty `$2` that is not a readable file (an inline body string passed where a body-*file* path is expected) now fails fast instead of silently falling through to `cat` on stdin, which blocks forever on non-tty stdin.

**Test** — added hermetic `scripts/jobs/test/journal-entry-argv-test.sh` (throwaway bare journal2 origin, fleet-env scrubbed, mirrors `land-journal-edit-test.sh`): 19 checks, all green. Asserts `--help`/`-h` exit 0 with the origin head unchanged (no entry landed), malformed kinds and inline-body `$2` exit non-zero with nothing landed, and that valid kinds still post real entries (both stdin-body and body-file paths).

**What changed** — `scripts/jobs/journal-entry.sh` (guards) and new `scripts/jobs/test/journal-entry-argv-test.sh`. Built in an isolated worktree off `origin/main2` (per the garden-infra norm, since the shared `/home/kris` tree is concurrently mutated), committed with explicit pathspecs, pushed to **main2** as `1665456ea`; worktree torn down.

**Verification** — `bash -n` clean; manual `--help`/`--foo`/`'res ult'`/inline-body smoke tests behave as specified; full test suite passes in both the shared tree and the isolated worktree. Audited all real callers (`gardener.sh`, etc.) — every one invokes `journal-entry.sh <kind>` with the body piped on stdin and no second positional arg, so the new body guard breaks nothing.

**Follow-ups** — The journal is append-only, so the already-written `kind: --help` entry stays in history; the fix prevents recurrence rather than removing the artifact. Inbox was empty throughout.
