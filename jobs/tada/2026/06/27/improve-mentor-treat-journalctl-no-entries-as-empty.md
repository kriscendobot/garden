Done. Pushed to `main2` as `00693cdbd`.

## Completion report

**Job:** `improve-mentor-treat-journalctl-no-entries-as-empty`

**What I did:** In `scripts/jobs/mentor.sh`, immediately after the `jlog="$(timeout 30 journalctl … || true)"` line (step 2), added a whitespace-tolerant normalization that maps journalctl's empty-result sentinel to the empty string:

```sh
[ "$(printf '%s' "$jlog" | tr -d '[:space:]')" = "--Noentries--" ] && jlog=""
```

Stripping all whitespace before comparing catches both the bare `-- No entries --` and any leading/trailing-newline variant. I added a multi-line comment explaining the sentinel-vs-empty distinction and why the step-3 `[ -z "$jlog" ]` guard depends on this normalization, so a future edit won't reintroduce the bug.

**Why it matters:** Previously, on a tick with no new journal entries but a reachable-and-clean journalctl, `jlog` held `"-- No entries --"` (non-empty), so the step-3 `if [ "${#new[@]}" -eq 0 ] && [ -z "$jlog" ]; then exit 0; fi` silence guard never fired. The mentor would build a content-less digest and invoke the `GARDEN_MENTOR_HANDLER` (`claude -p`) against pure noise — wasted tokens and a spurious agent wake on a service meant to stay silent until an error.

**Verification:** `bash -n` passes. Behavioral spot-check confirmed the bare sentinel, the newline-wrapped variant, and a real warning line all normalize correctly (sentinels → empty, real content preserved).

**Process:** Built on an isolated worktree off `origin/main2` (re-applied the patch on the clean base, anchor verified present) to avoid the concurrently-mutated shared `/home/kris` tree, then pushed `HEAD:main2`. Commit `00693cdbd`.

**Follow-ups:** None.
