In `scripts/jobs/handlers/mirror-pr-state-gh.sh`, replace the REST `gh api repos/$repo/pulls/$num` state read with a GraphQL query that fetches only `pullRequest(number:$num){ state merged }`. The REST pulls endpoint returns a **definitive** HTTP 422 ("too many files changed") for PRs with very large diffs (observed permanently on endojs/endo#3137), which makes `mirror-pr-state-gh.sh` die every tick and forces `mirror-closer.sh` to exit 1 (per its by-design per-mapping-failure→nonzero contract at mirror-closer.sh:160-163), triggering garden-mirror-closer self-heal on every run forever.

Fix details:
- Split `$repo` into owner/name and run the read through `gh_api_retry graphql -f query=...` (or a `gh api graphql`-based equivalent that still routes through the bounded transient-retry + loud-failure discipline). GraphQL does not compute the diff/file list, so it does not hit the 422.
- Preserve the handler's exact output contract: print one TSV line `<state>\t<merged>` where `state ∈ open|closed` and `merged ∈ true|false`. Map GraphQL `state`: `OPEN → open,false`; `CLOSED → closed,false`; `MERGED → closed,true`. Keep the "never guess a state — die loud on empty/failed, only a clean success prints" invariant unchanged, including the empty-output guard and the `die` on failure.
- If GraphQL is undesirable, the fallback that also avoids the 422 is the issues endpoint `repos/$repo/issues/$num` for open/closed plus a separate `merged` check — but GraphQL is the single-call, cleaner option.
- Verify against endojs/endo#3137 that the handler now returns a usable state instead of the 422, and confirm the closer completes a tick with exit 0 when that mapping resolves.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 14
  claimed_at: 2026-07-07T10:59:34Z
