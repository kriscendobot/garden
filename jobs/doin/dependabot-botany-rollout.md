# Empower the botanist for autonomous dependabot disposition, then fan out per-PR jobs

The maintainer wants the garden to assess every open **dependabot** pull request
and, where it meets our criteria, **act on it autonomously** — conduct onto main,
close, or defer-and-reschedule — rather than parking a recommendation for a human.
This is a **gardener** job with two ordered phases. Do Phase 1 fully (commit and
**push to `origin/main2`**, then confirm it is on the remote) **before** Phase 2,
so the per-PR botany jobs you post are governed by the updated role.

## Background already established

- `roles/botanist/AGENT.md` already encodes the accept/embargo/reject **heuristic**
  well: read the lockfile transitive diff first, install with preinstall scripts
  disabled, read upstream source, check `npm audit`/GHSA/issue tracker, embargo
  non-CVE upgrades for 7 days from publish, REJECT on regression/malicious-signal/
  license-change/yank-republish. **Keep all of that.** It maps cleanly to the
  maintainer's accept (MERGE-NOW) / defer (EMBARGO) / reject (REJECT) vocabulary.
- What is **missing** and must be added is (a) **CI shepherding** inside the loop
  and (b) the **autonomous empowerment** to execute the verdict.

## Phase 1 — Update `roles/botanist/AGENT.md` (on `main2`, bot identity)

Add, without weakening the existing safety posture:

1. **Shepherd CI to green as part of the workflow.** Before a MERGE-NOW verdict,
   the botanist drives the PR's CI to green (re-run known operational flakes;
   reuse the shepherd discipline in `roles/shepherd/AGENT.md`). A PR whose CI is
   red for a real reason cannot be MERGE-NOW; classify the failure (flake vs.
   real) explicitly. Cross-check, do not trust, the existing CI rollup.

2. **Strengthen the transitive-dependency security investigation** (mostly
   present — make it explicit): enumerate *every* transitive version that moved in
   the lockfile, not just the headline; check each against GHSA / `npm audit` /
   the OSV feed for known advisories; flag any newly-introduced transitive package
   and any version published in the last 24h as higher-risk.

3. **Maturity / compromise assessment** (present — keep): embargo non-CVE upgrades
   until 7 days past upstream publish; treat a yanked-then-republished version, a
   maintainer-disowned release, or a fresh release with no corroborating downstream
   adoption as REJECT or EMBARGO, never MERGE-NOW.

4. **Autonomous disposition (the new authority).** On a `dependabot[bot]`-authored
   PR, once the verdict is rendered, the botanist **executes** it — it does not
   merely comment and wait:
   - **MERGE-NOW → conduct onto main.** Accept the PR and conduct it onto the
     repo's main branch, reusing the **conductor's standing merge discipline**
     (`roles/conductor/AGENT.md`) — do **not** name a merge method; let the
     conductor norm / repo default decide. **Scope the auto-merge to repos where
     the bot holds merge authority** (the bot's own forks, e.g.
     `endojs/endo-but-for-bots`). On an upstream the bot does not own, the botanist
     renders the verdict as a recommendation for the maintainer/boatman and does
     **not** merge.
   - **REJECT → close the PR** with the structured verdict comment explaining the
     reason precisely enough for a future maintainer to reopen if warranted.
   - **EMBARGO/DEFER → schedule the next job.** Record the maturity date and
     **schedule a re-evaluation botany job** for that date so the PR is guaranteed
     to be re-assessed — reuse an existing primitive (the [schedule](../../skills/schedule/SKILL.md)
     skill / `scripts/jobs/set-schedule.sh`, or the dependabotany-ledger +
     triager re-post the role already describes). Pick the one that best fits a
     one-time future dispatch, wire it, and **document the choice in the role** so
     it is unambiguous. A deferred PR must never rot.

5. **Gate the authority on the full criteria, not CI alone.** Preserve the
   anti-pattern: green CI alone is never sufficient for MERGE-NOW. Auto-conduct
   fires only when CI is green AND the maturity window is satisfied (or a real CVE
   is closed) AND the source read surfaced nothing AND the transitive set is
   benign. State this gate explicitly next to the new authority so it cannot be
   read as "merge anything green."

6. Update the frontmatter `updated:` date and add a one-line note that the role
   now carries autonomous accept/close/defer authority for dependabot PRs on
   bot-owned repos.

## Phase 2 — Fan out one botany job per open dependabot PR (after Phase 1 is pushed)

- Re-enumerate the open dependabot PRs **freshly** on `endojs/endo-but-for-bots`:
  `gh pr list --repo endojs/endo-but-for-bots --author app/dependabot --state open
  --json number,title`. (As of posting there were 10: #512, #275, #274, #273,
  #271, #270, #269, #268, #267, #197 — but trust your fresh enumeration, not this
  list.)
- For each PR #N, post a botany job with `scripts/jobs/post-job.sh`, deterministic
  basename **`botany-ebfb-pr<N>`** (idempotent — a re-run collides and is skipped).
  Each job body must: name `endojs/endo-but-for-bots` and PR #N; tell the claiming
  gardener to wear the **botanist** role per the updated `roles/botanist/AGENT.md`;
  **authorize** it to comment on, merge (conduct), close, and schedule-defer the
  PR (explicit per-action authorization per `roles/COMMON.md`); and instruct it to
  shepherd CI, do the transitive security read, render MERGE-NOW/EMBARGO/REJECT,
  and **execute** the disposition.
- **Scope:** fan out for `endojs/endo-but-for-bots` only. Do **not** fan out for
  `endojs/endo` (30 open) or `agoric/agoric-sdk` (30 open): the bot cannot
  autonomously merge into those upstreams, and widening botanist surveillance to
  them is gated by the standing monitoring-safety constraint in `CLAUDE.md`
  (requires explicit maintainer authorization in a journal `message`). Note this
  scoping in your completion report so the maintainer can widen deliberately.

## Definition of done

- `roles/botanist/AGENT.md` updated and pushed to `origin/main2` (report the SHA),
  carrying the CI-shepherd step, the strengthened transitive/maturity checks, and
  the gated autonomous accept→conduct / reject→close / defer→schedule authority.
- One `botany-ebfb-pr<N>` job on the board per open dependabot PR on
  endo-but-for-bots (report the count and the PR numbers).
- A completion report naming the role SHA, the jobs posted, and the deliberate
  exclusion of endojs/endo and agoric/agoric-sdk pending maintainer authorization.

If any write or push is blocked, report the diagnosis and the exact ready-to-apply
change rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 27
  claimed_at: 2026-06-24T10:26:52Z
