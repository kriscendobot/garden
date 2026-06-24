---
ts: 2026-06-02T06:00:06Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/055400Z-dispatch-liaison-03f716.md
---

Boatman re-ferry of endojs/endo-but-for-bots#387 -> endojs/endo#3294 complete; yarn.lock CONFLICTING cleared (dispatch `03f716`).

**#3294** now MERGEABLE. New head `d6dc7596481ab3a482c9d6d0d02a9094c8badf75`, force-push `e0d7a8622...d6dc75964` to `kriskowal-3289-wget-engines`, reviewDecision REVIEW_REQUIRED, title unchanged. Recomputed on current master `3c5753b67`.

**0xPatrick credit re-applied** (the bot-side #387 rebase had dropped it to endolinbot): substantive commit `4afa6af31` author `0xPatrick <patrick@0xpatrick.dev>`, committer Kris Kowal. yarn.lock commit `d6dc75964` fully Kris Kowal. Trailers empty.

**Lockfile regenerated** rather than cherry-picked: `corepack yarn install --mode=update-lockfile` (yarn 4.13.0) with esvu removed; esvu transitive closure dropped (14 ins / 450 del). This is the generated-lockfile resolution; the old-base `c786ba635` was not carried. CI freshly triggered, pending.

Cross-link comment 4599031642 edited in place to `...head d6dc759`. Upstream-side handed to steward. Boatman entries: result `0bdd3b`, message `63de25`.

**Three items surfaced for follow-up (maintainer awareness):**
1. **Garden infra bug:** the `worktrees/endojs-endo.git` bare clone has an empty `remote.origin.fetch` refspec, so `git fetch origin` only moves FETCH_HEAD, leaving `origin/master` stale (it sat at the original-clone `c49fb048b` across all four ferries). The boatman worked around it with an explicit `refs/heads/master:refs/remotes/origin/master` refspec. Worth fixing the bare clone's config (`git -C worktrees/endojs-endo.git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'`) so future dispatches see live master.
2. **pr-handoff self-improvement** (boatman -> liaison): Shape 2 step 1 should verify `rev-parse origin/master` against `ls-remote` and force the refspec when they disagree. Candidate gardener edit to `skills/pr-handoff/SKILL.md`.
3. **Bot-side attribution regression:** #387's gamut/retcon force-push re-attributed 0xPatrick's substantive commit to endolinbot. The upstream credit is now correct, but the bot-side source still mis-attributes him; a fixer/retcon pass on #387 (or a pipeline fix) may be warranted to keep the bot-side mirror honest.
