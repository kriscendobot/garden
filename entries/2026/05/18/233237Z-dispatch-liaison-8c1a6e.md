---
ts: 2026-05-18T23:32:37Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/045644Z-message-liaison-73cdf1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: source
  - repo: endojs/endo
    pr: 3084
    role: merge-base
---

First-time ferry: `endojs/endo-but-for-bots#280` ("chore(ci): drop Node.js 18 and 20 from the test matrix") opens as a **non-draft stacked PR on `endojs/endo`**, based on Turadg's `ta/node-matrix` branch (= PR `endojs/endo#3084`, the Node 18 drop).

User direction on this dispatch (via AskUserQuestion 2026-05-18T23:30Z):
- **Use #3084 as the merge base** rather than master.
- **Body references #3084 only as context** (not "supersedes"); leaves the disposition open.

This is a new ferry shape for the boatman role's accumulating procedural notes: a *stacked-on-open-upstream-PR* ferry. The skill brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md` did not anticipate this shape; the gardener should add it as a fourth procedure when landing `skills/pr-handoff/SKILL.md`. Concretely: the new upstream PR is opened with `--base ta/node-matrix` (Turadg's branch), carrying only the bot's two endolinbot commits on top. Turadg's original Node-18-drop commit stays on `ta/node-matrix` and is **not** cherry-picked into the new ferry branch; it's already on the base.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #280 (OPEN, non-draft, MERGEABLE, **CHANGES_REQUESTED** addressed).
- Branch: `chore/drop-node-20-ci`
- Head: `c040dc77e435e68ac4eea69e8511563f0b6a3d77`
- Base: `0ec70c6dd` on master (only 3 commits behind current upstream master `7a027995b`).
- CI: 20 SUCCESS / 0 FAILURE.

Three source commits:

1. `2ec645b4 chore(ci): drop Node.js 20 from the test matrix` — endolinbot, 2026-05-18T04:06Z. **Ferry.**
2. `d652c222 ci: remove unsupported Node (18) from matrix` — Turadg Aleahmad, 2026-02-12T19:38Z (cherry-picked from upstream `endojs/endo#3084`, commit `010cc15fe`). **DO NOT ferry** — it's already on the base branch `ta/node-matrix` upstream.
3. `c040dc77 ci: preserve Node 20 SES-viable patch history (per kriskowal review on #280)` — endolinbot, 2026-05-18T19:01Z. **Ferry.** Strip the `(per kriskowal review on #280)` bot-internal suffix from the subject during the attribution-rewrite amend (per the standing trailer/suffix-strip discipline; see `entries/2026/05/15/045644Z-message-liaison-73cdf1.md` § Subject and body editing).

CHANGES_REQUESTED on the source side is a bot-side review by kriskowal; commit 3 addresses the feedback. The upstream PR is fresh; kriskowal will review from a clean state.

## Upstream

- Repo: `endojs/endo`. **Target base: `ta/node-matrix`** (= `endojs/endo#3084`'s head `010cc15fe6c8602a512aebf005b40958d9914e45`).
- New head branch: boatman picks (sensible defaults: `kriskowal-drop-node-20` or `kriskowal-drop-node-18-20`).

`ta/node-matrix` is OPEN, CONFLICTING with current master `7a027995b`. The conflict is between #3084 and master and is **not in scope for this ferry** — Turadg or kriskowal will rebase #3084 when ready. The stacked PR's mergeability against `ta/node-matrix` is what matters here.

## Humans

- Commit 1 → rewrite to `Kris Kowal <kris@cixar.com>` (bot-authored, standard rewrite).
- Commit 3 → rewrite to `Kris Kowal <kris@cixar.com>` (bot-authored, standard rewrite).

(Commit 2 is **not ferried**; Turadg's attribution stays on `ta/node-matrix` upstream where it originated.)

**identity_switch_authorized: true** for pushing under kriskowal credentials.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-drop-node-20-280--20260518-233223--8c1a6e/`. Project worktree on `endojs/endo:ta/node-matrix` (detached at `010cc15fe`).

## Boatman direction

- Detach at `origin/ta/node-matrix` (= `010cc15fe`), **not `origin/master`**.
- Cherry-pick commits 1 (`2ec645b4`) and 3 (`c040dc77`) — only the two endolinbot commits. Do **NOT** cherry-pick commit 2 (Turadg's Node 18 drop).
- Use the `cherry-pick + git commit --amend --reset-author --no-edit` pattern with local `user.name='Kris Kowal'` / `user.email='kris@cixar.com'` set first.
- For commit 3, rewrite the subject to strip the `(per kriskowal review on #280)` suffix. New subject: `ci: preserve Node 20 SES-viable patch history`. Body untouched.
- Verify per the standing discipline:
  - `git log origin/ta/node-matrix..HEAD --pretty=fuller` — both commits show author + committer `Kris Kowal <kris@cixar.com>`.
  - `git interpret-trailers --parse` per commit — zero `Co-authored-by`, zero `Generated with Claude Code`, zero bot trailers. **Run this on every commit regardless of preliminary inspection** — the #73 ferry's surprise Claude Co-Authored-By trailer below a body's first paragraph is the cautionary tale (see `entries/2026/05/15/034953Z-result-liaison-73cdf1.md`).
- Push the new branch to upstream via `git push origin HEAD:<new-branch>`. Verify `gh auth status` shows kriskowal active.
- **Open the upstream PR as non-draft, with `--base ta/node-matrix`** via `gh pr create -R endojs/endo --base ta/node-matrix --head <new-branch> --title <new> --body <new>`.

Title: source title `chore(ci): drop Node.js 18 and 20 from the test matrix` is misleading for the stacked PR (which only drops Node 20; #3084 is the Node 18 drop). Rewrite to a stacked-PR-appropriate title like `chore(ci): drop Node.js 20 from the test matrix (on top of #3084)` or simply `chore(ci): drop Node.js 20 from the test matrix`. The boatman picks per `pr-formation`.

Body: compose per `pr-formation` with the endo PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Specific to this ferry:

- **Reference `#3084` only as context**, per user direction. Phrasing like "This PR is stacked on `endojs/endo#3084` (Node 18 drop); together they drop both Node 18 and Node 20 from the CI matrices." No "supersedes #3084" claim; leave the disposition open.
- **Drop fork-only references**: the source body's `endojs/endo-but-for-bots#260` (the flake-on-Node-20 bug filed bot-side) translates to a behavior note like "the Node-20 `test-xs (macos-15)` lane was filed as flaky" without the bot-side issue number.
- Body content about the Node 20 details (test-async-hooks matrix string-form versions, test-xs lane, test-ocapn-python pin, ocapn-guile-interop pin) is substantive and stays.
- The `engines.node` out-of-scope note in the source body is useful reviewer context and stays.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#280`: post under kriskowal (only authenticated on this host). Name the upstream PR URL, head SHA, the stacked-on-#3084 framing, and that Turadg's commit was not re-applied (it's already on the base).
- **Identity discipline**: no direct comments on the new upstream PR. If you judge an explanatory comment is useful (e.g., "stacked on #3084 by intent; merge after #3084"), route via `message`-to-`steward`.

## Out of scope

- Resolving the `ta/node-matrix` ↔ master conflict on #3084. That's Turadg's or kriskowal's to address; a separate weaver dispatch could rebase #3084 if needed.
- Closing or commenting on the source-side PR #280 beyond the cross-link.
- Touching `engines.node` declarations (source's out-of-scope section).

## Expected report

≤350 words:
- Upstream PR number, URL, head SHA, **base confirmed as `ta/node-matrix`**, non-draft state.
- Two new commit SHAs in order, attribution verified (both `Kris Kowal <kris@cixar.com>`).
- Source-side cross-link URL.
- Title chosen + body-per-`pr-formation` confirmation (with #3084 referenced as context, fork-only refs translated).
- Steward-message path if drafted.
- One-line `Self-improvement: ...` — given this is a new procedure shape (stacked-on-open-upstream-PR), the boatman is encouraged to surface it as a structural lesson for the gardener brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md`.

If blocked (cherry-pick conflict against `ta/node-matrix`, `ta/node-matrix` no longer extant on upstream, etc.), `message`-to-liaison and stop.
