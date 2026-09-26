Inbox is empty. The work is complete, verified, committed, and pushed.

## Completion report

**Job:** Make the foreman post a maintainer-inbox milestone/bottleneck notice once per distinct state, not every tick.

**What changed** (`scripts/jobs/foreman.sh`, pushed to `main2` at `9f050d95cb`):

The `MAINTAINER` branch used to dedup on `note_once "block:$(cksum of body)"` — a hash of the notice **prose**. Since the `claude -p` handler rewords the prose every tick while the board stays stalled, the cksum changed each time and the near-identical notice re-posted, flooding the maintainer inbox. Fixed at the source, mirroring `identity-drift-guard.sh`:

- **`notice_signature()`** — computes a stable signature of the notice's *substance*: the milestone ids (`M2`, `M3`, …) and PR/issue numbers (`#719`, `#263`, …) it references, normalized (uppercased), de-duplicated, and sorted. Token order and phrasing don't affect it. A token-less notice falls back to a prose cksum so identical prose still dedups. Example signature: `#263,#719,M2,M3`.
- **`note_milestone_once()`** — posts only when the signature differs from the last recorded one; an unchanged state posts **nothing**. On a real change it posts once and records the new signature.
- **Marker `notice-sig` under `$GARDEN_STATE/foreman/`** — per-host, outside any reset-prone worktree, exactly like the drift guard's marker.
- **Forward progress clears the marker** (`rm -f "$NOTICE_SIG"` at both pump-success paths: deferred-plan promotion and a posted milestone step), so a bottleneck that recurs *after* real progress surfaces once more rather than being permanently swallowed.

**Signature definition:** `grep -oE '\b[Mm][0-9]+\b|#[0-9]+'` over the notice body → uppercase → `sort -u` → comma-joined; empty ⇒ `prose:<cksum>`.

**Verification:**
- `bash -n` clean; `shellcheck -S warning` clean on all touched scripts (the lone `foreman.sh` SC2034 on `GARDEN_TAG` is pre-existing on `origin/main2`).
- New end-to-end test `scripts/jobs/test/foreman-maintainer-notice-dedup-test.sh` (+ stub) drives real foreman ticks against a throwaway journal remote and counts what lands in `inbox/maintainer/unread/`. **6/6 pass:** two consecutive same-substance ticks (prose reworded) post **once, not twice**; a substance-changing tick (a new PR `#800`) posts again **exactly once** and then dedups on repeat; the marker lives under `$GARDEN_STATE` and its signature keys on substance tokens (`#263,#719,#800,M2,M3`).
- Confirmed a genuinely new decision is not swallowed: adding a PR to the decision changes the token set → new signature → fires once.

**Note:** I initially edited via absolute paths that pointed at the deployed garden root; I copied the changes into this job's worktree and restored the deployed root to pristine before committing. All committed work is in the worktree only.

**Follow-ups:** none. Takes effect at the next deploy.
