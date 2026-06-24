The commit is on `origin/main2`, the isolated worktree is torn down, and temp artifacts are cleaned. Job complete.

---

## Completion report: `self-heal-mentor-capture`

**What I did:** Converted the mentor self-healing service to the git-content-store capture pattern (per `designs/self-healing-audit.md` Part B #2), eliminating the single largest wholesale-inlined blob in the fleet. Built in an isolated worktree off `origin/main2`, validated against a throwaway journal, and pushed commit `03c76b8c` to `main2`.

**What changed (3 files):**
- `scripts/jobs/mentor.sh` — after building the combined digest (new journal entries + the `journalctl -p warning` tail), it now hashes it into the mentor's own journal clone via `capture_blob` (the helper that landed in `common.sh` from the sibling job) and hands the handler **only the SHA + clone dir**, then drops the temp file. Quiet-on-success and retry-on-handler-failure (markers held on a failed tick → next tick retries) are preserved.
- `scripts/jobs/handlers/mentor-claude.sh` — the `claude -p` prompt no longer inlines `$(cat "$digest")`. It names the SHA + an `inspect_note` brief and instructs the mentor to read only the slices it needs via `git cat-file -p <sha> | grep/sed`, documenting the blob's `===== entry … =====` / `===== journalctl … =====` section delimiters.
- `scripts/jobs/test/mentor-stub.sh` — adopts the new `<sha> <clone-dir>` interface, reading the captured blob with `cat-file`.

**Notable finding (worth flagging):** the naïve `git cat-file -p "$sha" | grep -qi 'error'` is **unreliable under `set -o pipefail`** — `grep -q` short-circuits on first match, SIGPIPEs the upstream `cat-file`, and the pipeline reports failure even though the pattern matched. The original stub was immune only because it grepped a file. I fixed the stub to read the blob into a variable first, then grep (`grep -qi … <<<"$blob"`), and documented why — a real scripted responder must inspect captures the same way. **Any future scripted consumer of these captures should use capture-then-grep, not `cat-file | grep -q`.**

**Validation:** end-to-end against an isolated throwaway journal — (1) an error entry → improvement job posted (capture→SHA→selective `cat-file` works), (2) re-run with no new entries → silent, no duplicate, (3) a failing handler → mentor exits non-zero with the latest entry not marked seen (retry preserved). `bash -n` + `shellcheck -x` clean (only pre-existing SC1091/SC2034/SC2129).

**Note on concurrency:** the full `run-test.sh` suite couldn't be run to completion here — it hardcodes the shared path `/home/kris/.garden-test` and `~100` gardeners on this host run it concurrently, so its CONCURRENCY subtest collides and `set -e` aborts before SUBTEST 11. I validated the mentor path in isolation instead. The rebase folded cleanly atop the sibling `self-heal-gardener` commit (Part B #1).

**Follow-ups:** none required for this job. The remaining Part B opportunities (#3 gardening-state-machine trace capture, #4 triager/watchman 400-line caps, #5 bulletin/proxy/foreman) are separate posted jobs.
