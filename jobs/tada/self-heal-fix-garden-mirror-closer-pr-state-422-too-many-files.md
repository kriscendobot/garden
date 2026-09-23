Inbox empty. Work complete.

## Completion report

**Job:** Fix `mirror-pr-state-gh.sh` so reading a mapped PR's state no longer dies on huge PRs (the recurring endo#3137 HTTP 422 that made `mirror-closer.sh` WARN-skip and exit 1 every tick, tripping self-heal indefinitely).

**Key finding:** The handler *fix itself was already landed* — HEAD's prior commit `ca55d80a8` had already switched the read from the REST `repos/{repo}/pulls/{num}` endpoint (which computes the full server-side diff and 422s on large PRs) to diff-free `gh api graphql`, mapping `OPEN/CLOSED/MERGED` to the TSV contract, with the loud-die and empty-output invariants preserved and the header comment updated. What was **missing** was the test: `mirror-closer-test.sh` only ever drove a `STATESTUB`, so the handler that carried the bug was never exercised — a regression back to the REST endpoint would have passed green.

**What I changed:**
- `scripts/jobs/test/mirror-closer-test.sh` — added **section J**, which runs the *real* `handlers/mirror-pr-state-gh.sh` against a fake fleet `gh` injected via `GARDEN_GH`. The stub serves `gh api graphql` from fixture state (applying the caller's `--jq` with real jq) but **422s on any REST `pulls` call** with the exact endo#3137 wording. Assertions: OPEN→`open,false` / CLOSED→`closed,false` / MERGED→`closed,true`; every read goes through GraphQL and never a `pulls` endpoint; the large-PR (OPEN) shape yields a clean read rather than a fatal 422; and an unrecognized state → loud die (nonzero, empty), never a guessed state.
- `scripts/jobs/common.sh` — gave `gh_api_retry` the same `"${GARDEN_GH:-gh}"` test seam that `gh_pr_view_retry`/`ci-wait-merge.sh` already use, so the stub can be injected deterministically (PATH injection is unreliable behind the fleet's pinned-gh-wrapper + bash command-hash). **Production-invariant:** unset `GARDEN_GH` → bare `gh`, no behavioral change.

**Verification:** `bash scripts/jobs/test/mirror-closer-test.sh --no-e2e` → **29 passed, 0 failed** (all existing PART 1 cases plus the 6 new section-J assertions). `bash -n` clean on all three files; shellcheck flags only pre-existing lines. Committed with explicit pathspecs and pushed to `main2` (`a46ed7d9e`, first-attempt CAS win).

**Follow-ups:** None required. PART 2 (synthetic real-repo E2E) was skipped here via `--no-e2e` since it creates live throwaway PRs and needs an authenticated bot `gh`; it is unaffected by these changes and runs on the fleet's usual E2E path. Note: `mirror-closer.sh` itself needed no change.
