Both deliverables are complete and pushed to `main2`. Let me write the completion report.

## Completion report — job `endojs-endo-but-for-bots-pr849-a6858de7`

**Directive** (attention on endojs/endo-but-for-bots#849, kriskowal): "Post a botanist job for this change. This should occur automatically for every dependabot PR going forward." Preflight exit 0 → proceed (no peer resolution). Comment body treated as untrusted data.

Both halves done:

**1. Immediate — botanist job posted for #849.** `#849` is a `dependabot[bot]` PR ("bump the all-minor-patch group … 28 updates", base `llm`). Posted `endojs-endo-but-for-bots-pr849-dependabot` to the board (post rc=0). A gardener will claim it and wear `roles/botanist/AGENT.md`.

**2. Automation — a new per-repo producer so it happens for every dependabot PR going forward.** Added the **dependabot-PR watcher**, a fourth deterministic sibling to the triager/comment/CI watchers:
- `scripts/jobs/dependabot-watcher.sh` — enumerates a watched repo's open PRs (reusing the ci-watcher's authoritative paginated PR source), keeps only `dependabot[bot]`-authored ones, and posts exactly one `<slug>-pr<N>-dependabot` botanist job each, deduped by basename across ticks/hosts. Deliberately applies **no** bot-repo/head-pushable gate (unlike the ci-watcher) because the botanist reviews-and-recommends on upstreams, not just bot-owned repos. Injection-safe by construction (reads only PR authorship/metadata, feeds nothing to an LLM); rides the same maintainer-cleared `comment-repos/` set.
- `scripts/systemd/garden-dependabot-watcher@.{service,timer}` — modeled on the ci-watcher units (leader-only `ExecCondition`, self-heal wrapper, graceful drain); 300s cadence (dependabot PRs aren't latency-sensitive).
- `scripts/jobs/repo-watcher.sh` — arms `garden-dependabot-watcher@<slug>` on the `comment-repos/` set.
- `scripts/jobs/test/dependabot-watcher-test.sh` — **11 assertions, all passing** (author gate, idempotent re-poll, mixed-authorship fan-out, upstream-not-dropped, already-live skip).
- Docs: `roles/botanist/AGENT.md`, `roles/triager/AGENT.md`, `CLAUDE.md` (monitoring-safety + producer list).

**Verification:** new test 11/0; `enable-services-test.sh` 37/0 (the `@` template is correctly excluded from the direct-enable set); repo-watcher self-heal path exercised with the mock — install-units runs exactly once/tick, the new template renders and its instance arms alongside the ci-watcher; parse-checks clean. Committed `73180090a5` and pushed to `origin/main2` (fast-forward, no CAS contention). Once deployed to the leader, the watcher self-heals its template and arms for `endojs/endo-but-for-bots` (already in `comment-repos/`) with no manual step; it will not double-post #849 since I used the exact basename it generates.

**Note (self-corrected):** I accidentally ran `git add -A` once in the deployed root (`/home/kris/garden2`) via a compound command whose cwd wasn't the worktree. It only *staged* a pre-existing unstaged deletion (`journal/jobs/tada/mirror-endo-2780-cache-globals-gauntlet/report.md`) into the root index — no working-tree file was created or destroyed. I restored the root index to exactly the state I found it with an index-only `git reset` (no HEAD move, no remote/config change, no checkout). All actual development was done in the per-job worktree.

**Follow-ups:** none required. That stray journal-worktree deletion in the root is pre-existing drift handled by the journal-worktree-keeper, not this job.
