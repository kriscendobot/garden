Fix `scripts/jobs/handlers/mirror-pr-state-gh.sh` so reading a mapped PR's state no longer dies on huge PRs. Failure signature (recurs every tick, deterministic — not transient): `gh api repos/endojs/endo/pulls/3137 failed (definitive, rc=1); ... gh: The request could not be processed because too many files changed (HTTP 422)`, which makes `mirror-closer.sh` WARN-and-skip that mapping and then exit 1 on every tick, tripping self-heal indefinitely.

Root cause: the handler reads state via the REST `GET /repos/{owner}/{repo}/pulls/{number}` endpoint (the `gh_api_retry "repos/$repo/pulls/$num" --jq '[.state, (.merged_at != null)] | @tsv'` line). That endpoint computes the full file diff server-side and returns a definitive 422 "too many files changed" on PRs with very large diffs (endo#3137), so `gh_api_retry` correctly refuses to retry and `die`s.

Fix: read `.state` and `.merged_at` from a source that does NOT compute the file diff, so the 422 is impossible by construction. Preferred: switch to `gh api graphql` querying `repository(owner:,name:){ pullRequest(number:){ state mergedAt } }`, and map GraphQL's uppercase state enum to the handler's contract — `MERGED` → `state=closed, merged=true`; `CLOSED` → `state=closed, merged=false`; `OPEN` → `state=open, merged=false`. Keep every existing invariant: fail LOUD (nonzero, empty output) on a missing tool / auth / exhausted-retry so a swallowed error can never masquerade as "open" or "closed"; keep the transient-blip retry/backoff behavior; keep the single-TSV-line `<state>\t<merged>` output the closer's `parse_state` expects; do not `2>/dev/null` the call. Update the handler's header comment to note the endpoint change and why (422 on large-diff PRs). Extend `test/mirror-closer-test.sh` (or the handler's own test if present) with a case asserting the large-PR path no longer produces a fatal read, and that the OPEN/CLOSED/MERGED mapping is correct. No behavioral change to `mirror-closer.sh` itself is required.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  claimed_at: 2026-07-07T11:39:32Z
