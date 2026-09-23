Pushed to main2. Job complete.

## Completion report

**Job:** `improve-foreman-heredoc-backtick-exec` — fix the foreman idle-pump handler failing every tick.

**Root cause:** `scripts/jobs/handlers/foreman-claude.sh` builds the foreman prompt with an intentionally-unquoted heredoc (`prompt="$(cat <<EOF`), so bash performs interpolation/substitution on the body. The literal markdown backticks around `` `designer` `` / `` `builder` `` (old lines 73–74) were evaluated as command substitutions, so every foreman tick emitted `designer: command not found` and exited rc=1 — the foreman never posted a job.

**What I changed** (single file, `foreman-claude.sh`):
1. Escaped the two backtick pairs to `` \`designer\` `` / `` \`builder\` `` so they reach the prompt as literal backticks. Left the `EOF` delimiter unquoted, preserving the legitimate `$common_brief`/`$role_brief` and `$(cat "$digest")` interpolations.
2. Audited the rest of the heredoc body (lines 38–91): the only remaining substitution is the intentional `$(cat "$digest")`; no other stray backticks or `$(...)`. (Backticks on lines 3, 100, 103, 104 are in comments outside the heredoc.)
3. Added a regression-guarding comment above the heredoc opener documenting that the delimiter is *intentionally* unquoted, that any literal backtick/`$(...)` in the body must be escaped, and that quoting `EOF` would break the two legitimate interpolations.

**Verification:**
- `bash -n` parses clean.
- Reproduced the exact heredoc in isolation post-fix: backticks now render literally (`` `designer` ``/`` `builder` ``), both the brief-path and digest interpolations still expand, and no `command not found`.
- The two shellcheck warnings that remain (SC1091 source-follow, SC2034 `GARDEN_TAG`) are pre-existing and unrelated.

**Follow-ups:** none required. The comment serves as the requested style guard; a dedicated test wasn't added since no existing foreman-claude test harness stubs the real prompt build and the isolation test confirms correctness.

Committed as `b793cbb80` and pushed to `origin/main2`.
