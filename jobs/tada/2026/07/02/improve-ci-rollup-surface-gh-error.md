Pushed to main2. Job complete.

**What the job asked:** `ci-rollup-gh.sh` ran `gh pr view … 2>/dev/null` and reported only `exit 1` on failure — 354 opaque rc=1s during the 2026-07-02 window, with no way to tell a rate-limit from an expired token or a network blip. The file's own header calls out exactly this swallowed-stderr trap (the 2026-06-24 jq-outage lesson).

**What I changed** (`scripts/jobs/handlers/ci-rollup-gh.sh`, lines 40–50):
- Redirect gh's stderr to a `mktemp` tempfile (registered for cleanup via an `EXIT` trap) instead of `2>/dev/null`.
- On failure, collapse the captured stderr to a single tidy line (`tr` newlines→spaces, `sed` squeeze/trim) and fold it into the log: `gh pr view $repo#$pr failed: <gh stderr> — cannot read CI state (skip, never guess)`, with a `<no stderr>` fallback.
- The never-guess `exit 1` contract is untouched — only the *reason* is now visible, so a systemic outage is diagnosable.

**Verification:** `bash -n` clean; shellcheck reports only the two pre-existing warnings (SC1091 source-follow, SC2034 GARDEN_TAG). A functional run of the failure path against a live `gh` produced a meaningful diagnosable message (`… failed: GraphQL: API rate limit already exceeded for user ID … — cannot read CI state (skip, never guess)`) rather than a bare rc=1.

**Follow-ups:** none. The sibling `pr-mergeable-gh.sh` uses the same `2>/dev/null` shape and may warrant the same treatment, but it is out of scope for this job.
