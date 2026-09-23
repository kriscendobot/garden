The work this job requests is already fully landed on `origin/main2`. No new changes were needed.

## Completion report

**Finding: the job was already resolved on `main2` by a series of commits that predate this claim.** I verified the source and tests rather than duplicating the fix.

**Source (`scripts/jobs/triager.sh:59-61`)** already uses the prescribed form:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
  || die "cannot resolve ref '$ref' in $slug"
```
- `--verify -q` on both primary and fallback → a missing remote-tracking ref prints nothing to stdout, so no two-line `new_sha` (commit `469cab011`; redundant `2>/dev/null` dropped in `4ceaff391`).
- `^{commit}` peel normalizes annotated tags (commit `80acdfce0`).
- A 40-hex tripwire guard (`triager.sh:67-68`) dies loudly on any future poisoning (commit `7cc020469`).
- Line 57's `symbolic-ref … || echo master` was audited and left as-is (correct — `symbolic-ref` doesn't echo its arg on failure).

**Tests (`scripts/jobs/test/triager-test.sh`)** cover exactly the requested bare-clone case:
- **Section E**: a plain `git clone --bare` fixture (has `refs/heads/<ref>`, no `refs/remotes/origin/<ref>`) exercises the fallback path and asserts the handler receives a single clean SHA, with a single non-empty CALL_LOG line proving no injected newline (commit `8c25e2597`).
- **Section F**: injects the exact production corruption via a `git` shim and asserts the 40-hex guard fires, dies non-zero, and never invokes the handler.

**Verification I ran:** the full suite — **29 passed, 0 failed**, including sections E and F. HEAD (`b793cbb80`) equals `origin/main2`; working tree clean.

**Changes made this run:** none — nothing to commit or push. **Follow-ups:** none.
