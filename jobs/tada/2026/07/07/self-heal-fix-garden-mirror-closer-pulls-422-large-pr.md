Pushed to `main2` on the first attempt.

## Completion report

**What the job asked:** Stop `mirror-pr-state-gh.sh` from dying every tick on the definitive HTTP 422 the REST `repos/<repo>/pulls/<num>` endpoint returns for very-large-diff PRs (permanently observed on endojs/endo#3137), which forced `mirror-closer.sh` to exit 1 forever and re-triggered `garden-mirror-closer` self-heal on every run.

**What I changed** (`scripts/jobs/handlers/mirror-pr-state-gh.sh`, +29/−5):
- Replaced the REST `gh_api_retry "repos/$repo/pulls/$num"` state read with `gh_api_retry graphql -f query='… repository(owner,name){ pullRequest(number){ state merged } } …' -F owner -F name -F number`. It splits `$repo` into owner/name and still routes through the bounded transient-retry + loud-failure discipline. GraphQL never computes the diff/file list, so it cannot hit the 422.
- Mapped the GraphQL `state` enum to the unchanged TSV contract in jq: `OPEN → open\tfalse`, `CLOSED → closed\tfalse`, `MERGED → closed\ttrue`; any unrecognized/null state falls through to `empty`.
- Preserved every invariant: the empty-output guard, the `die` on failed call, and "never guess a state — only a clean success prints." `gh api graphql` returns nonzero when the response carries a top-level `errors` array, so a missing repo/PR still dies loud.

**Verification:**
- Handler against endojs/endo#3137 now returns `open\tfalse`, exit 0 (no 422) — a usable state.
- Mapping confirmed on real PRs: MERGED #7 → `closed⇥true`; CLOSED-unmerged #11 → `closed⇥false`; OPEN #3137 → `open⇥false`.
- Loud-failure invariant confirmed: nonexistent PR #999999 WARNs "definitive, rc=1" then FATAL-dies with exit 1 (no guessed state).
- Full E2E closer suite `scripts/jobs/test/mirror-closer-test.sh`: **29 passed, 0 failed** — it drives real upstream/mirror PRs through the default handler and completes a closer tick that resolves the mapping and exits 0.
- `shellcheck -x` clean of new issues (only pre-existing SC1091/SC2034 and the intentional SC2016 — GraphQL variables `$owner/$name/$number` must reach `gh` literally via single quotes).

**Follow-ups:** None. Note the REST endpoint happened to be responsive for #3137 at test time (its diff may have shrunk since the original observation), but the GraphQL path avoids the 422 by construction regardless.
