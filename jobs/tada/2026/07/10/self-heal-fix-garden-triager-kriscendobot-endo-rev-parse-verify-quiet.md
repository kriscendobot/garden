The job's requested work is already fully present in `origin/main2` — completed by a chain of prior commits. Nothing to change.

## Report

**Status: already done — no new commits needed.**

The fix this job describes is already landed on `origin/main2` and verified green. The relevant history:

- `469cab011` triager: use `rev-parse --verify -q` so a missing ref does not leak its name into `new_sha` — this is the exact fix in the job spec.
- `4ceaff391` triager: drop redundant `2>/dev/null` now that `rev-parse --verify -q` is silent on failure.
- `80acdfce0` triager: peel ref to `^{commit}` (added robustness beyond the spec — normalizes annotated tags).
- `7cc020469` triager: assert `new_sha` is a single 40-hex SHA (tripwire guard against future regression).
- `8c25e2597`, `049946f69` triager-test: cover the primary-ref-unresolvable / fallback-resolves path and cold-start with ref derived from HEAD.

**Current state of `scripts/jobs/triager.sh:59-61`** — exactly the shape the job prescribes, with the `2>/dev/null` dropped:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
  || die "cannot resolve ref '$ref' in $slug"
```

**Test coverage** requested by the job (bare clone with no `refs/remotes/origin/*`, asserting `new_sha` is a single 40-hex line) is present as three cases in `scripts/jobs/test/triager-test.sh`:
- **Test E** — primary ref unresolvable, fallback resolves; asserts single-line `CALL_LOG` and that the handler receives the clean resolved SHA (not `refs/remotes/origin/<ref>\n<sha>`).
- **Test F** — a deliberately poisoned multi-line `new_sha` trips the `^[0-9a-f]{40}$` guard, dies loudly, handler never invoked.
- **Test G** — cold-start with the ref derived from HEAD (no `GARDEN_WATCH_REF`).

Full suite run: **37 passed, 0 failed** (exit 0).

**Follow-ups:** none. The self-heal job was presumably posted before the fixing commits landed (or against a lagging deploy); the deployed root checkout should pick up these commits via the normal deliberate-deploy path if it hasn't already.
