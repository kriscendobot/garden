All landed. Job complete.

## Completion report — `garden-auto-shepherd-on-red-ci`

**What I built.** A new deterministic CI-status producer that closes the loop the maintainer named on endojs/endo-but-for-bots #58: a red CI on an open bot-authored PR now autonomously yields exactly one `shepherd` job — no maintainer comment required. Landed on `main2` (commit `1a9448720`).

**New files**
- `scripts/jobs/ci-watcher.sh` — per-repo producer (`garden-ci-watcher@<slug>`), sibling to the commit triager and comment watcher. Enumerates the repo's own open PRs, keeps only bot-authored PRs whose head branch is bot-pushable, reads each PR's rollup, and on a completed-red posts `<slug>-pr<N>-shepherd`.
- `scripts/jobs/handlers/ci-pr-source-gh.sh` — authoritative paginated open-PR enumeration (never a default `gh pr list` page cap — the #284 lesson).
- `scripts/jobs/handlers/ci-rollup-gh.sh` — deterministic check-suite rollup read; exit code is the verdict (0 RED / 10 green / 11 no-checks / 12 pending). Same `statusCheckRollup` coalescing shape as `pr-mergeable-gh.sh`.
- `scripts/systemd/garden-ci-watcher@.{service,timer}` — leader-only singleton (`is-main-host.sh` `ExecCondition`), `KillMode=mixed` + short `TimeoutStopSec` mirroring the comment watcher.
- `scripts/jobs/test/ci-watcher-test.sh` — 14 hermetic assertions, all passing.

**Modified**
- `scripts/jobs/repo-watcher.sh` — arms `garden-ci-watcher@` off the same cleared `comment-repos/` set (verified it arms both watchers for both cleared repos).
- `scripts/jobs/install-units.sh`, `roles/triager/AGENT.md`, `CLAUDE.md` — template-exclusion comment, role note, and leader-only singleton list.

**Design decisions (per spec)**
- **Idempotency/no-thrash:** basename matches the manual-shepherd naming exactly (`<slug>-pr<N>-shepherd`) so the two producers can't double-post; watcher pre-checks the board and post-job's CAS/basename idempotency dedup across ticks and hosts.
- **Flake window:** any pending check → back off (rc 12); only completed-red (failing present, none pending) triggers.
- **Monitoring safety:** gated to the already-cleared `comment-repos/` set; injection-safe by construction (reads only CI status, feeds no external text to an LLM).
- **Bot-repo gate:** denylist-by-default — never autonomously shepherds `agoric/agoric-sdk` or `endojs/endo` upstream; a non-bot cleared repo (kriskowal/garden) exits before any gh call.

**Verification**
- `ci-watcher-test.sh`: 14/14 pass (red→one post, idempotent re-poll, non-bot-author skip, green/pending skip, un-pushable-head skip, non-bot-repo gate, mixed set).
- Rollup handler unit-tested with a gh stub across 6 JSON shapes (RED / green / fail+in-progress / no-checks / merged / StatusContext ERROR) — all correct.
- repo-watcher mock confirms both watcher templates arm per cleared repo.

**Follow-ups (noted, not blocking)**
- Because the basename is fixed per PR (matching the manual path), a shepherd sitting in `tada` blocks a fresh shepherd if the *same* PR goes red again in a later episode. This is identical to the existing manual-shepherd behavior; if re-shepherd-after-completion is wanted, it's a separate improvement to *both* paths (e.g. incorporating the head SHA into the basename).
- Arming for real on `endojs-endo-but-for-bots` happens automatically on the next `garden-repo-watcher` tick once this deploys (it reconciles from `comment-repos/`, where the repo is already listed).
