Inbox empty. Work complete.

## Completion report

**Job:** Fix the section-3 unguarded `gh`/pipefail gap in `scripts/jobs/handlers/comment-source-gh.sh` that produced empty self-heal blobs (signature: one `FATAL` line, no `  source:` lines, blob `d65a4f0a`).

**What I did**
- Built in an isolated worktree off `origin/main2` (shared `/home/kris` tree is concurrently mutated by other gardeners), committed explicit pathspecs, rebased onto latest `origin/main2`, pushed `HEAD:main2`, and tore the worktree down.

**What changed** (`scripts/jobs/handlers/comment-source-gh.sh`, +19/−4, commit `5937b36c9` now on `origin/main2`):
1. **Guarded the section-3 pipeline.** The `gh pr list … | while … done` open-PR walk now ends with `|| { cat "$prlist_err" >&2; true; }`, and the `rids="$(gh api … | jq | sort | tr …)"` command substitution now has `|| { rids=""; cat "$rids_err" >&2; }`. A transient `gh` fault (rate-limit/network/auth) now degrades gracefully (exit 0) like sections 1–2 instead of killing the whole source under `set -euo pipefail`.
2. **Un-blinded the diagnostic.** The two *structural* `gh` calls (`gh pr list` and the `rids=` review-id `gh api`) no longer suppress stderr with `2>/dev/null`. Their stderr is captured to per-call buffers (`prlist_err`, `rids_err`) that are echoed to fd 2 **only on failure**, so a genuine fault reaches the watcher's `ERRF` (no more empty self-heal blob) while a clean run stays quiet. The per-iteration reviews `gh api` (line ~102) was left as-is — it already carries `|| true` and was out of the stated scope.
3. Extended the handler's stderr-policy comment (lines ~53–66) to document the section-3 EXCEPTION and reference the empty-blob signature.

**Verification**
- `bash -n` clean; `shellcheck -S warning` introduced no new findings (the two SC2034 warnings on `GARDEN_TAG`/`bot` are pre-existing).
- Behavioral test: a failing `gh pr list` (real `gh` against a bogus repo) now yields **exit 0** with the GraphQL error text surfaced to stderr — exactly the non-empty diagnostic the watcher needs, where the old code would have died with an empty `ERRF`.

**Follow-ups:** none. The fix mirrors the intent already documented in the handler's stderr-policy comment and the `require_tools` loud-failure hardening, closing the section-3 gap.
