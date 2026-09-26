The job's requested fix is already present and correct on `main2`; no code change was needed.

## Completion report

**What I found:** The fix this job asks for was already landed on `main2` before I claimed the job. `scripts/jobs/triager.sh` lines 59–61 already resolve `new_sha` with `git rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" || git rev-parse --verify -q "$ref^{commit}"`, keeping the final `|| die "cannot resolve ref …"` guard. This was delivered by commit `469cab011` ("use rev-parse --verify -q so a missing ref does not leak its name into new_sha") plus three follow-ups already merged:
- `4ceaff391` — dropped the now-redundant `2>/dev/null`
- `7cc020469` — added a `^[0-9a-f]{40}$` tripwire assert on `new_sha`
- `80acdfce0` — added the `^{commit}` peel for annotated tags

**Verification (as the job requested):** I built a bare clone whose refs live under `refs/heads/` (no `refs/remotes/origin/master`, the `kriscendobot-endo` shape) and ran both the fixed and old resolution:
- Fixed: `new_sha = d4056ffa…` — a single clean 40-hex SHA, matching HEAD; triage would proceed normally.
- Old bare `rev-parse`: `new_sha = $'refs/remotes/origin/master\nd4056ffa…'` — reproduces the exact two-line poison that caused the `fatal: ambiguous argument` in the triage failure.

**What changed:** Nothing — no commit/push was necessary. Worktree HEAD equals `origin/main2` (`b793cbb80`), working tree clean, and the fix commit is an ancestor of HEAD.

**Follow-ups:** None. This job was a duplicate of already-completed self-healing work; it can be recorded as done.
