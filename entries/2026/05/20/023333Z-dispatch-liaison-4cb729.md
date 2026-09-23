---
ts: 2026-05-20T02:33:33Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
refs:
  - entries/2026/05/14/180704Z-result-liaison-3114c6.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: source
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: target
---

**First-ever ferry on the agoric-sdk project**, and a re-ferry on the upstream side: `kriscendobot/agoric-sdk#1` ("chore(eslint-config): alias eslint-plugin-import to import-x@4 (mirror of Agoric/agoric-sdk#12659 + turadg feedback)") reshapes upstream `Agoric/agoric-sdk#12659` from a "migrate to" approach to an "alias not migrate" approach per turadg's CHANGES_REQUESTED feedback. **Direct analog of the endo `#226 → #3255` ferry** I did 2026-05-14T18:00Z (`entries/2026/05/14/180704Z-result-liaison-3114c6.md`) — same reshape rationale (turadg's `endojs/endo#3255 r3229246963`), same multi-package pattern (the agoric-sdk equivalent of the endo eslint-plugin-import-x migration).

User direction (via AskUserQuestion 2026-05-20T02:32Z):
- Clone `Agoric/agoric-sdk` locally on `kmkmbp2021` (done; 203 MB bare clone at `worktrees/Agoric-agoric-sdk.git/`). First-ever agoric-sdk bare clone on this host.
- Rewrite upstream PR title and body to reflect the alias shape. Same as the #226 / #3255 ferry.

## Source

- Repo: `kriscendobot/agoric-sdk` (the bot's personal fork; first agoric-sdk fork the garden engages with).
- PR: #1, OPEN, DRAFT, MERGEABLE, CI 69 SUCCESS / 11 SKIPPED / 0 FAILURE.
- Branch: `feat/migrate-eslint-plugin-import-x`
- Head: `bb407ca1d17ce08aa9014f970dee1eeac4a61c25`
- Base: master (whatever the bot's fork's master is at; the boatman computes the diff against current upstream master).

Four commits, all authored by `endolinbot <main.barn5084@fastmail.com>`:
1. `0ab4e7bb chore(eslint-config): alias eslint-plugin-import to import-x@4` — the aliasing approach (root package.json yarn alias).
2. `ede0da6d chore(lint): clean import-x@4 lint findings` — five new findings from the stricter `unrs-resolver`, addressed with per-line `eslint-disable-next-line` comments.
3. `638a578f chore: Update yarn.lock` — lockfile.
4. `bb407ca1 chore(multichain-testing): align eslint-plugin-import peer-dep range with root` — peer-dep range widening for the multichain-testing workspace.

## Upstream

- Repo: `Agoric/agoric-sdk`. Branch: `feat/migrate-eslint-plugin-import-x`. Current head: `c2200be70d61cdfa4fef7116b90bad862a3f49dd`.
- State: OPEN (non-draft), CHANGES_REQUESTED by turadg at 2026-05-14T21:05:20Z (12 minutes before the bot started preparing the reshape on its fork). `mergeable: UNKNOWN`.
- Current title: `chore(eslint-config): migrate to eslint-plugin-import-x` (the old "migrate to" framing — needs rewrite per user direction).
- Two commits on the current upstream tip, both `Kris Kowal <kris@agoric.com>`:
  - `33e17625 chore(eslint-config): migrate to eslint-plugin-import-x`
  - `c2200be7 chore: Update yarn.lock`

## Human

`Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry).

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-eslint-import-x-agoric-1--20260520-023333--4cb729/`. Project worktree on `Agoric/agoric-sdk:feat/migrate-eslint-plugin-import-x` (detached at `c2200be7`).

## Boatman direction

This is a **recompute-from-master** re-ferry (per the boatman wisdom branch). The upstream branch's current shape (two commits, "migrate to") will be replaced with the source's reshape (four commits, "alias not migrate") via force-push.

- Detach at upstream master (= `fb5cf8676` on the bare clone; fetch fresh to confirm).
- Cherry-pick the four source commits (`0ab4e7bb..bb407ca1`) onto current upstream master. Preserve as four commits (the lockfile / multichain-testing split is deliberate).
- Use the `cherry-pick + git commit --amend --reset-author --no-edit` pattern with local `user.name='Kris Kowal'` / `user.email='kris@cixar.com'` set first.
- **Subject suffix check**: scan each source commit's subject for fork-only suffixes like `(per kriskowal review)`, `(mirror of …)`, `(#1)`, etc. Strip during the amend. (Preliminary inspection shows subjects look clean, but apply the standing check.)
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit, **always** — the #73 ferry's surprise `Co-Authored-By: Claude` trailer below a body's first paragraph is the cautionary tale. Run regardless of preliminary inspection.
- **Force-push** to `Agoric/agoric-sdk:feat/migrate-eslint-plugin-import-x` with `--force-with-lease=feat/migrate-eslint-plugin-import-x:c2200be70d61cdfa4fef7116b90bad862a3f49dd` (the lease against current upstream tip).
- **Update upstream PR title and body** (user-authorized). Use `gh pr edit 12659 -R Agoric/agoric-sdk --title <new> --body <new>`:
  - **Title**: a frame-for-upstream variant of the new shape. `chore(eslint-config): alias eslint-plugin-import to import-x@4` is the natural shape; the `(mirror of Agoric/agoric-sdk#12659 + turadg feedback)` parenthetical from the source title is bot-internal and drops.
  - **Body**: compose per `pr-formation`. The agoric-sdk PR template (read `.github/PULL_REQUEST_TEMPLATE.md` in the project worktree) may differ from endo's — apply whatever section headings the template uses. Behavior over diff. **Drop fork-only references**: the source body mentions `endojs/endo-but-for-bots#226` (the parallel endo ferry) and `endojs/endo#3255` — translate `#3255` to `endojs/endo#3255` (already an upstream cross-reference; keep) and drop `endo-but-for-bots#226` (bot-side). The body's reference to `Agoric/agoric-sdk#12659` is self-referential — drop. The turadg-feedback rationale, the aliasing approach explanation, the resolver fallback discussion, the peer-dep range widening, the lint findings, and the "no `import/*` → `import-x/*` rename" framing are all substantive and stay.

- **Source-side cross-link comment** on `kriscendobot/agoric-sdk#1`: post under whichever identity is authenticated on this host (kriskowal on `kmkmbp2021`). Name the upstream PR URL and new head SHA. **Note**: this is on the bot's personal fork, not on the garden's own repo. Per `roles/COMMON.md` the standing-authorization rules I have only mention `endojs/endo-but-for-bots`; the bot's personal fork is in a separate authority sphere. **Verify with the agoric-sdk project README before posting**: the README at `journal/projects/agoric-sdk/README.md` § "Routine work, when it begins, happens on a `kriscendobot` fork" suggests the bot's fork is the bot's space and the comment is acceptable, but route through `message`-to-`steward` (let the steward post under kriscendobot) if there's any doubt about cross-link authorization.

- **Identity discipline on upstream Agoric/agoric-sdk**: **NO direct comments**. Any explanatory comment for the upstream PR routes via `message`-to-`steward` (the steward, running under kriscendobot, posts on its next cycle). The standing rule "no comments on primary repos under kriskowal" applies to `Agoric/agoric-sdk` per the same logic as `endojs/endo` (kriskowal is the maintainer-equivalent contributor there).

- **CONTRIBUTING.md** check: read `CONTRIBUTING.md` in the project worktree to confirm conventional-commits prefix, DCO sign-off, changeset requirements, etc. Apply whatever the project requires. The agoric-sdk has historically required changesets for user-facing changes; the eslint-config change may need a changeset (the source PR's commit 1 may already include one).

## Out of scope

- No changes to source-side PR #1.
- No direct comments on `Agoric/agoric-sdk#12659`.
- The upstream branch's draft state is currently non-draft and stays non-draft (user did not ask for a draft toggle).

## Expected report

≤350 words:
- Upstream PR head SHA after force-push, four new commit SHAs in order, attribution verified.
- Source-side cross-link URL (and identity used, with note on whether you routed through steward).
- New upstream title, body-per-`pr-formation` confirmation, CONTRIBUTING.md compliance noted.
- turadg-approval state after the push (CHANGES_REQUESTED is on the prior commit; force-push behavior depends on protection rules — verify and report).
- Steward-message path if drafted.
- One-line `Self-improvement: ...` — this is the first agoric-sdk ferry, so any project-specific observations (PR template differences, CONTRIBUTING.md particulars, changeset conventions) are valuable additions for the eventual `skills/pr-handoff/SKILL.md`.

If blocked (cherry-pick conflict, missing CONTRIBUTING.md guidance, agoric-sdk-specific shape question), `message`-to-liaison and stop.
