---
ts: 2026-05-15T01:35:11Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/005247Z-result-liaison-1a7ad4.md
  - entries/2026/05/14/035942Z-result-builder-bd72be.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#244` ("chore(eslint-plugin): require underscore-delimited groups in numeric literals") opens as a new **draft** PR on `endojs/endo`. User explicitly chose draft when offered (normal / draft).

The bot-side PR was built specifically "for future ferry" (the builder dispatch at `entries/2026/05/14/035047Z-dispatch-liaison-e417d9.md` and its result `entries/2026/05/14/035942Z-result-builder-bd72be.md` mirrored the same change from the bot's `llm` branch's PR #243 onto `master` for this purpose). CI is clean (27 SUCCESS / 0 FAILURE).

**Source**: `endojs/endo-but-for-bots#244`, branch `chore/eslint-numeric-separators-style-master`, head `9686ce25559d9054fee3691d4e8bc9a250fc076c`. State OPEN (DRAFT), MERGEABLE. Base on `master` at `c2fc02eb8`.

Four source commits:

1. `8be387e3` (kriscendobot): `chore(eslint-plugin): require underscore-delimited groups in numeric literals` — config + dep + changeset.
2. `fe2ec5c7` (kriscendobot): `chore: Update yarn.lock`.
3. `02ed8352` (kriscendobot): `chore: migrate numeric literals to underscore-delimited grouping` — 44 files autofixed.
4. `9686ce25` (`kriskowal <main.barn5084@fastmail.com>`): `chore: prettier --write on autofix-touched files (fix lint job on #244)` — *note the identity mismatch*: this commit's `Author: kriskowal` carries the user's name but the bot's email (`main.barn5084@fastmail.com`). The fixer dispatch that produced it inherited a `git config user.name` of `kriskowal` from the parent shell, per `entries/2026/05/14/091104Z-message-liaison-d70ff8.md`. The boatman rewrites all four commits to `Kris Kowal <kris@cixar.com>` regardless, so this surface mismatch washes out at the upstream boundary; the lesson lives in the identity-discipline gardener engagement that the message above flagged.

**Upstream**: new branch on `endojs/endo`. Boatman picks the name (sensible default: `kriskowal-eslint-numeric-separators-style`). Target base: `master`. Current `origin/master` is at `0ec70c6dd` (28 commits ahead of source's base, including the four ferries that have landed earlier today: #75, #109, #223, #226, #3262, #3258). Some of the 44 autofixed files on the bot side may have moved on upstream master in those 28 commits; the boatman should expect conflicts on individual literal-formatting touches and resolve in favor of the autofix semantics (every decimal of five-plus digits gets the `_` separator).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry; standing pattern).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-numeric-separators-244--20260515-013456--9224ee/`. Project worktree on `endojs/endo:master` (detached).

**Boatman direction**:

- This is a first-time ferry: open a new draft upstream PR.
- Recompute from upstream master. **Preserve the four commits as four**: config / yarn.lock / autofix / prettier-fix is a deliberate split (the bot mirror followed #243's same split). Do not squash.
- Apply via cherry-pick `8be387e3..9686ce25` onto `origin/master`. Use the cherry-pick-then-`commit --amend --reset-author --no-edit` pattern surfaced on the prior re-ferry of #253 (`entries/2026/05/15/005114Z-result-boatman-eaabd7.md`): `git cherry-pick` does not accept `--author`, and `GIT_AUTHOR_*` / `GIT_COMMITTER_*` env vars alone do not override the preserved original author. Amend after each cherry-pick to set author + committer to `Kris Kowal <kris@cixar.com>`.
- If a cherry-pick conflicts on a literal-formatting touch (a numeric literal that upstream changed independently), resolve by re-applying the underscore-separator semantics. The eslint-rule body is in commit 1; commit 3 is purely autofix; both are mechanical. If a conflict is *not* a mechanical literal-formatting touch, pause and `message`-to-liaison.
- Strip bot trailers. Verify with `git log origin/master..HEAD --pretty=fuller` and `git interpret-trailers --parse` — zero `Co-authored-by`, zero `Generated with Claude Code`, zero bot trailers.
- Push the new branch.
- Open the upstream PR **as DRAFT** via `gh pr create --draft -R endojs/endo --base master --head <new-branch>`. Compose title + body per `pr-formation`:
  - Title: a frame-for-upstream variant of the source title. The source's `chore(eslint-plugin): require underscore-delimited groups in numeric literals` reads as-is on the upstream audience; keep that shape.
  - Body: use the endo PR template's section headings (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior over diff. The source body's `This PR mirrors #243 onto master.` line is bot-internal and drops; describe the rule, the autofix, the changeset implications, and the two pre-existing ESLint warnings and seven Prettier line-length warnings that ride along (the source body already names them; keep that detail at the upstream level — it is useful reviewer context, not garden bookkeeping).
- Source-side cross-link comment on `endo-but-for-bots#244`: post under whichever identity is authenticated on this host (only `kriskowal` on `kmkmbp2021`; the standing authorization on `endo-but-for-bots` permits both). Name the upstream PR URL and head SHA.
- Identity discipline: no direct comments on the new upstream PR. Steward-routed comment only if you judge one is warranted; a clean first-time ferry rarely needs one.

**Expected report** (≤350 words): upstream PR number + URL + head SHA + four new commit SHAs in order, draft confirmed, attribution verified, source-side cross-link URL, new title + body-per-`pr-formation` confirmation, steward-message path if any, one-line `Self-improvement: ...`. If blocked (a conflict that isn't a mechanical literal-formatting touch, or any other surprise), `message`-to-liaison and stop without opening the upstream PR.
