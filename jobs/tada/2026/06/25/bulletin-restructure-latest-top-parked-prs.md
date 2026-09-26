All done. Service is active and healthy, inbox empty, worktree and scratch cleaned up.

## Completion report

**Job:** Restructure the garden bulletin — lead with "Latest" (+PR links), drop "Recent progress", add a parked-for-maintainer-feedback PR queue. **Done, deployed, verified live.**

### What changed (3 commits on `main2`, final HEAD `153c3026`)
- **`7c819dde`** — core restructure of `scripts/jobs/bulletin.sh`:
  - Removed the `## Recent progress` section from `compute_dashboard`.
  - Moved `## Latest` to the **top** (right after the `_As of` freshness line, before the deterministic sections). It's now injected as the lead; `dashboard_part`/`latest_part` were rewritten to split on the Latest section *wherever it sits* so the cost gate is unchanged.
  - New deterministic `## Parked for maintainer feedback` section, rendered `- [repo#N](url) — title (waiting <age>)`, sourced from `gh` (built-in `--jq`, `command -v gh` guard), **throttled** via a host-local cache+stamp in `GARDEN_STATE`, graceful degradation to last cache / `(unavailable)`.
  - Idempotency preserved: `stable()` now also strips the volatile `(waiting <age>)` suffix so a ticking age never churns a commit, while a PR entering/leaving the queue *does* register as news.
  - Journalist handler (`bulletin-claude.sh`): instructed to hyperlink every PR it names.
  - Tests: `run-test.sh` SUBTEST 10 extended + new `bulletin-parked-stub.sh` (asserts Latest leads, parked PRs render as links with age, Recent-progress gone, gh query fetched **once across all ticks**).
- **`16496f49`** — scoped the query by owner (`GARDEN_BULLETIN_PARKED_OWNERS`, default `endojs kriskowal`). The first cut queried all of GitHub and flooded the section with ~50 stale `Agoric/agoric-sdk` dependabot review-requests (off-limits, useless as a human board).
- **`153c3026`** — handler guard: forbid the journalist from leaking visible self-corrections / meta-commentary into `## Latest` (the live output had emitted "Wait — I linked the wrong URL, let me correct that").

### Parked-PR query + throttle
```
gh search prs --review-requested kriskowal --state open --draft=false \
   --owner endojs --owner kriskowal --limit 100 \
   --json number,repository,title,url,updatedAt \
   --jq '.[] | [.repository.nameWithOwner,(.number|tostring),.url,.updatedAt,.title] | @tsv'
```
**Throttle interval:** `GARDEN_BULLETIN_PARKED_TTL=300` (5 min); failures are throttled too (the stamp is written whether or not the query won).

### Redeploy & verification (live on `origin/journal2`)
Fast-forwarded the shared `/home/kris` tree (clean except other agents' untracked scratch dirs), restarted `garden-bulletin.service` (`--user`, non-blocking), and cleared the stale parked cache so the scoped query ran immediately. Live posted bulletin confirmed:
- Section order: **Latest (11) → Parked (19) → Messages (54) → Board (58) → Watch (75) → Hosts (78)**.
- Parked: **33 endojs/kriskowal PRs, 0 agoric**, each a hyperlink with a waiting age.
- `Recent progress`: gone. Latest body leads and hyperlinks PRs (e.g. `[endo-but-for-bots#513](…)`).

Sample parked row: `- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub … (waiting 3h)`

### Notes / follow-ups
- **Test harness caveat:** the full `run-test.sh` aborts at SUBTEST 1 (CONCURRENCY — gardeners claim 0 jobs) in this shared environment, a pre-existing git/flock issue unrelated to this change, and `set -e` stops it before SUBTEST 10. I verified SUBTEST-10 behavior directly via end-to-end two-tick loop runs and function-isolation tests (idempotency round-trip, age-masking, news-detection, throttle count = 1, empty-queue + degradation paths) — all pass. `shellcheck`/`bash -n` clean (only pre-existing SC1091/SC2034/SC2016 warnings remain).
- The owner scope is configurable; if the watched set widens, set `GARDEN_BULLETIN_PARKED_OWNERS`.
