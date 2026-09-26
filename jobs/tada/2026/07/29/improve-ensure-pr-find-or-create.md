Work is committed and pushed. Report:

**Delivered `scripts/jobs/gardening/ensure-pr.sh`** — PR find-or-create as plain code, with the job↔PR pairing as its owned invariant.

- **Discovery, two independent ways:** the head branch (`gh pr list --head`) and a `<!-- garden-job: <base> -->` marker it embeds in every body it writes. The head match is filtered to bot-authored PRs — `--head` matches the ref *name* across every fork, so a stranger's identically-named branch would otherwise be adopted and pushed to; such a match is logged, never silently dropped.
- **Three outcomes:** exactly one → print the number, create nothing, exit 0; none → create (marker embedded, draft by default) and print; more than one → print them all, exit 3, create nothing. A query that fails or returns *at* the page limit is inconclusive → exit 4, nothing created. Failing closed costs a retry; failing open costs the duplicate.
- **Create is one attempt, never retried** (a retry over a lost response is how a duplicate is born); on failure it re-discovers and adopts. A post-create re-check catches a peer that created inside the window.
- **Journal record:** stamps `pr_number:`/`pr_repo:`/`pr_url:`/`pr_head:` onto `work/<base>` under the push CAS, so a later call in the same claim resolves with no GitHub query. Journal work is advisory — both helpers run in subshells so `sync_clone`'s offline `exit` can't kill a job whose PR already exists.

**Library wiring** (agent supplies title/body, script owns identity): `roles/builder/AGENT.md` (new PR-opening norm + skills-list note), `skills/pr-formation` (new § *The division of labor*, and the marker named as the single sanctioned exception to *No methodology leak* — an HTML comment carrying no role or procedure), `skills/pr-creation-flow` (new § *One job, one PR*, flow diagram, draft-discipline and pitfalls), plus the two sites that showed a literal `gh pr create`: `skills/frozen-base-branch` step 6 and `skills/gap-revealing-build` § 5.

**Verification (all run, output observed):**
- `scripts/jobs/test/ensure-pr-test.sh` — 30 checks pass on throwaway fixtures (a JSON PR database behind a fake `gh`, a throwaway bare journal). Covers the #865/#871 shape directly: a second incarnation on a *different* head branch adopts the existing PR via the marker.
- Regression evidence: removing the marker arm of the discovery union fails exactly 5 checks (`opened a duplicate on the new head — the #865/#871 defect`, PR count 2, and the ambiguity cases). Restored, re-ran green.
- `scripts/checks/run-all.sh --dry-run --base origin/main2` — all 5 gates clean; `bash -n` clean; shellcheck clean apart from the fleet-wide `GARDEN_TAG` SC2034.
- **Not verified:** no live GitHub call was made. `gh pr create` was exercised only against the stub.

Pushed as `9520a5cb47` to `origin/main2`.

**Follow-ups:**
1. The `work/<base>` fast-path record does **not** survive a reaper requeue (the reaper `git rm`s it), so across incarnations the durable converger is the marker query, not the record. Carrying a `pr_number` into the requeued job body — mirroring `<!-- garden-reaped: N -->` — would close that, at the cost of touching the reaper; I left it out deliberately as beyond this job's scope.
2. No script *calls* `ensure-pr.sh` yet — the builder invokes it per the role brief. `garden-pr.sh` currently has no PR-open stage; when one is added it should route here.
3. Three PR-open sites still show a bare `gh pr create` and were outside the named scope: `skills/pr-handoff` and `roles/boatman` (the ferry's upstream PR, which runs under the kriskowal identity — it would need `--no-draft` and an identity override), and `skills/stacked-pr-build` / `skills/pre-pr-checklist`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ensure-pr-find-or-create.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (10178855 cached reads)
- Output: 60695 tokens
- Cost: $8.4834825
- Wall-clock: 853s

<!-- garden-usage-end -->
