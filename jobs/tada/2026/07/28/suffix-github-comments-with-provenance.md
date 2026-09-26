Pushed to `main2` (`e8bf3345fd`). The push output even shows the live `kriskowal→kriscendobot` redirect, confirming the URL-derivation approach is the right call.

---

## Completion report

**What I did.** Added a small-text provenance footer — `model · harness · deployed-garden-sha (hyperlinked)` — to every GitHub PR/issue comment the fleet posts, enforced at the single PATH chokepoint the maintainer flagged.

**Where I enforced it, and why.** The gh wrapper (`scripts/jobs/bin/gh`) — the front-of-PATH chokepoint every fleet `gh` call (including `claude -p` subagents' Bash calls and the direct-posting watcher scripts) passes through. A wrapper cannot forget the way a skill-told agent can, and it's idempotent by construction. New library `scripts/jobs/comment-provenance.sh` (sourced by the wrapper) renders the footer and rewrites the argv; the wrapper calls it just before its final `exec`, staying on the fast exec path for every non-comment call.

**Coverage.** `gh pr comment` / `gh issue comment` / `gh pr review` via `--body`, `--body-file`, and stdin (all normalized to a temp `--body-file`, so a source file is never mutated); inline review comments and threaded replies via `gh api` with `-f`/`--raw-field`/`-F`/`--field body=` and `--input <file>`/`--input -` JSON. The two direct-posting scripts (`comment-reply-gh.sh`, `issue-inbox-watcher.sh`) route through `gh_api_retry → gh api -f body=`, so they inherit the footer for free — verified their endpoints match.

**Facts resolved.** model from `GARDEN_JOB_MODEL` (now exported by the gardener/cleric/mystic handlers from the *resolved* model, not the role's nominal default); harness from `GARDEN_WORKER_KIND` (gardener→claude, cleric/hermit/fireworker→codex, mystic→kimi); garden sha from `.garden-state/deploy/deployed-sha` (the **deployed** sha, not tip), linked to a commit URL **derived from the git remote** so it survives the pending owner transfer.

**Constraints honored.** Bodies never corrupted (JSON stays valid — jq-edited; `--body-file` never touched on disk); idempotent (hidden `garden-provenance` marker + a loose shape-match catch a hand-written footer, no doubling); only comment-creating calls touched (reactji, labels, merges, reads, PR/issue *descriptions* all pass through untouched); commit messages never touched; **fail-open** everywhere — any unresolved fact degrades to the fields that did resolve, and a wholly-unresolvable footer means the comment posts *without* it rather than failing.

**Scope decision (as requested):** the footer **does** cover PR review **summary** bodies and **inline** review comments — they are comments and the same provenance question applies. It **excludes** PR/issue **descriptions** (`pr/issue create`, `pr edit --body`, `PATCH .../pulls/N`) — a description is not a comment, and those weren't in the directive's surface list.

**Tests / verification (ran locally).** New `scripts/jobs/test/comment-provenance-test.sh` — **28/28 pass** — covers every invocation form, JSON validity, no on-disk mutation, idempotency (marker + hand-written), passthrough of reactji/non-comment calls, and graceful degradation, plus two end-to-end runs through the real wrapper. Existing `gh-wrapper-fail-closed-test.sh` still **49/49**. `bash -n` clean across all `scripts/`+`skills/`; `shellcheck -S warning` clean on the wrapper, library, and test. Also confirmed end-to-end that `pr comment --body` and `api -f body=` emit the footer with a remote-derived URL.

**Follow-ups / notes.**
- Two `tests/checks/` suites (`maintainer_inbox_information_hiding`, `run_all`) fail, but **pre-existing** and unrelated — they flag files I never touched, and the failures persist with my COMMON.md edit stashed. (The upstream commit I rebased onto actually reworded the erights paragraph to drop a "maintainer inbox" reference, likely chipping at that gate.)
- A `git gc.log`/repack warning surfaced from the shared root repo during the rebase; the operations all completed, but the host's `.git` may warrant a maintenance pass.
- Provenance for the direct-posting watcher scripts will show only the garden-sha field unless those code paths run with `GARDEN_WORKER_KIND`/`GARDEN_JOB_MODEL` set (fail-open by design); wiring those exports into non-agent post paths is a possible refinement, not required by the directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/suffix-github-comments-with-provenance.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 114 tokens (6524484 cached reads)
- Output: 70956 tokens
- Cost: $6.584692000000002
- Wall-clock: 1030s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
