Empty inbox. Job complete.

---

## Completion report

**Outcome: already-fixed upstream — no change pushed (would have regressed).**

The job asked me to add transient-`gh` tolerance to section 3 (the open-PR review-body loop) of `scripts/jobs/handlers/comment-source-gh.sh`, which under `set -euo pipefail` could exit silently on a momentary `gh` blip — surfacing as `comment-watcher.sh:444` "comment source failed" with an *empty* captured stderr.

What I found:
- The job was generated against the **stale local `/home/kris` (main2) checkout**. I first implemented the requested `2>/dev/null || true` fix locally (capture PR list before iterating via `prs="$(... || true)"` + `done <<< "$prs"`; add `|| true` to the `rids=` substitution); it passed all 77 tests and added no new shellcheck findings.
- But when I rebased onto `origin/main2` to commit, I discovered commit **`5937b36c9`** ("comment-source: guard section-3 structural gh calls so a transient blip degrades, not kills") is already **HEAD of `origin/main2`** and fixes this exact bug — and **more robustly** than the job specifies. Instead of `2>/dev/null`, it captures the `gh pr list` and `rids=` stderr to buffers (`prlist_err`/`rids_err`) and echoes them to fd 2 **only on failure**, then degrades with `|| true` / `|| rids=""`. A genuine `gh` fault therefore still reaches the watcher's `ERRF` (no longer empty), while a transient blip degrades to empty output — the loud-or-degrade behavior the job wanted, without the job's tradeoff of discarding stderr entirely.

Why I did **not** push my version: pushing `2>/dev/null` would have *reverted* the superior landed fix and reintroduced the very empty-captured-stderr symptom the job complains about (the landed commit's own EXCEPTION comment cites "blob d65a4f0a" — the empty self-heal blob with one FATAL line and no `source:` context — as the symptom it fixes).

Verification of the landed fix:
- `scripts/jobs/test/comment-watcher-test.sh` → **77 passed, 0 failed** (incl. sections H, Q, Z covering the degrade/loud paths).
- `shellcheck` → only pre-existing `SC1091`/`SC2034` (source path, unused `GARDEN_TAG`/`bot`); no new findings.

Side effects: synced my local `/home/kris` copy of the handler to the pristine `origin/main2` version (it was stale); removed the temp worktree. No commit, no push.

**Follow-up:** none on the code. The local `/home/kris` working tree was behind `origin/main2` — worth a periodic refresh of the shared tree so future self-heal jobs aren't minted against stale handler state. Inbox drained empty.
