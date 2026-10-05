`scripts/jobs/handlers/ci-pr-source-gh.sh` now keeps a locked, short-lived open-PR list per repository. When several consumers run close together, one of them asks GitHub for the list and the others reuse its result. The change is pushed to `main2` as 794aefd7bdb, and the new test passes 23/23.

**How it works:**
- **Lock:** each repository has its own lock (case-insensitive key). A consumer that arrives while another is fetching waits, then reuses that result instead of making its own paginated call.
- **Cache lifetime:** a cached list is reused for 60 seconds by default. `GARDEN_CI_PR_SOURCE_CACHE_SECS` sets this, capped at 600 seconds, and 0 turns caching off.
- **What gets cached:** only a successful, complete fetch is saved: `gh` returned 0, at least one page arrived, and every page was a JSON array. The saved file records its creation time, line count and sha256, and a reader re-checks all three. A mismatch, an expired entry or a timestamp in the future counts as a miss. Files are written to a temp name and renamed, so a reader never sees half a file.
- **Failures:** a failed, quota-refused, empty or malformed fetch exits nonzero and doesn't touch the cache. If a valid cached copy is still fresh, it stays in place and keeps being served.
- **Busy lock:** if the lock isn't free within `GARDEN_CI_PR_SOURCE_CACHE_LOCK_WAIT` (default 120 seconds), the consumer fetches the list itself and leaves the cache alone.
- **Location:** the cache sits in `$GARDEN_ROOT/.garden-state/ci-pr-source-cache`, the same place as the gh-api cooldown latch, so watchers that use separate `GARDEN_STATE` directories still share it.

**One behavior change:** before, a zero-byte or non-array response that `gh` reported as successful was passed on as "no open PRs". It now fails loudly instead.

The new test is `scripts/jobs/test/ci-pr-source-cache-test.sh`, and it uses a stub `gh` that counts calls. It covers:
- four simultaneous consumers producing exactly one API call
- reuse within the 60 seconds, the case-insensitive key, and separate caching per repository
- expired or tampered entries, and setting the lifetime to 0
- that failed, quota-refused, empty and non-array responses never write a cache entry
- that a valid cached copy survives a later failure

No existing test runs this handler directly; they all substitute their own PR-source stub. `shellcheck` reports only the same notes as other files in this directory.

**Follow-up:** the cache key is the repository name only, not the GitHub identity. That's fine while each host uses one bot identity. If one host ever ran these consumers under different `gh` identities that see different PR lists, the identity would need to be part of the key.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-pr-source-rest-cache.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (897670 cached reads)
- Output: 12688 tokens
- Cost: $0.9491419999999999
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
