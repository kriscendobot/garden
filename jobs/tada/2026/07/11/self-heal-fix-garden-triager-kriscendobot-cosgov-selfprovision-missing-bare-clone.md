The job's requested change is already fully implemented and merged on `main2`; there is no remaining work.

## Completion report

**Finding: the fix already landed.** The job describes replacing a bare `die "no bare clone at $BARE …"` guard (reported at `triager.sh:32`) with a self-provision block. That work is already present at `HEAD`/`origin/main2` (54ed2c98f0) via commits:
- `2c76c8cd92 fix(triager): self-provision a missing bare clone instead of never triaging`
- `4c0e275b0b fix(triager): make self-provision opt-in (default skip), reconcile case I`
- `372e5e7584 fix(triager): guard self-provision on is_own_git_repo, surface a present-but-corrupt clone instead of dying`
- `83e0eb0f41 fix(jobs): share one bare_clone_dir resolver …`

**What the merged implementation does** (exactly matches — and refines — the job spec):
- The bare `die` is gone. `triager.sh:73` now guards on `! is_own_git_repo "$BARE"` (not `[ -d ]`), so a present-but-corrupt dir is surfaced as `STALE` + escalated and **never clobbered** (mirrors `clone-keeper.sh`'s `keep_clone`).
- A genuinely-missing clone self-provisions via the shared `derive_clone_url "$BARE"` → `bounded_clone "$src" "$BARE"`, then sets `git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` before falling through to the existing fetch, logging `provisioned missing bare clone <slug> … from <src>`.
- Failed re-clone / underivable slug skip cleanly (exit 0, retry next tick) and throttle-escalate to the maintainer inbox — no crash loop. The `die`/retry semantics on downstream fetch failure are preserved.
- One refinement beyond the literal ask: self-provision is **opt-in** (`GARDEN_TRIAGE_SELF_PROVISION=1`); the default clone-less path is a clean skip. Either way the reported `garden-triager@kriscendobot-cosgov` FATAL crash-loop is resolved (exit 0 instead of exit 1 every tick).

**Verification:** the deterministic offline test the job asks for exists (`scripts/jobs/test/triager-test.sh`, cases H1–H4 and J: missing-clone → `bounded_clone` against derived URL, present-but-non-repo refused/not clobbered, unreachable/underivable escalation). Ran the full suite: **68 passed, 0 failed.** Shared helpers (`is_own_git_repo` / `derive_clone_url` / `bounded_clone`) are factored into `common.sh` and used by both `triager.sh` and `clone-keeper.sh`.

**Changes made this run:** none — the worktree is clean (`git status` empty) and no bare `die "no bare clone…"` remains in `triager.sh`. Nothing to commit or push.

**Follow-ups:** none. This job was posted against a pre-fix snapshot; the intended change is already in production `main2`.
