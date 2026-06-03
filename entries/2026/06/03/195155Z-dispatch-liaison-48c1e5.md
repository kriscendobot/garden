---
ts: 2026-06-03T19:51:55Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--48c1e5
prs: []
refs:
  - https://github.com/endojs/endo/pull/3164
---

# dispatch: fixer — mirror endo#3164 onto endo-but-for-bots

User explicit ask:

> Please mirror https://github.com/endojs/endo/pull/3164 and
> run the gamut.

This dispatch covers ONLY the mirror creation. The gamut
(assayer → cleaner → judge → fixer-loop → un-draft) is a
sequential chain the liaison runs AFTER this dispatch returns
with the new bot PR number.

## Upstream PR

- Repo: endojs/endo
- Number: #3164
- Title: `feat(immutable-arraybuffer): freezable virtual typedarrays`
- Author: erights
- Branch: `markm-shim-freezable-typedarrays`
- Head SHA: `59dfbc6d628c24946a0031b49ced1c8e803a2c05`
- Base: `master`

## Mirror procedure

1. **Fetch upstream content**. From the project worktree (or a
   bare clone), fetch `endojs/endo:markm-shim-freezable-typedarrays`
   into the bot fork's remote namespace.
   ```
   git -C project remote add upstream git@github.com:endojs/endo.git
                                                 # if not present
   git -C project fetch upstream markm-shim-freezable-typedarrays
   ```

2. **Push to bot fork** as a new branch. Suggested name:
   `mirror/3164-freezable-typedarrays` (follow the existing
   convention seen on #379 = `mirror/2422-host-module-exits`,
   #387 = `fix-benchmark-wget-engines-master`, etc.).
   ```
   git -C project push origin upstream/markm-shim-freezable-typedarrays:mirror/3164-freezable-typedarrays
   ```

3. **Open DRAFT PR on endo-but-for-bots** with:
   - Title: same as upstream (`feat(immutable-arraybuffer):
     freezable virtual typedarrays` — or with a `(mirror of
     endo#3164)` suffix per the bot's convention; check the
     #379 / #351 / #387 titles to pick the right shape).
   - Base: `master` (bot-master, currently `ba26f4cdb`, mirrors
     actual/master after recent sync).
   - Body: a one-paragraph summary referencing the upstream PR
     URL and noting this is a mirror for the gamut.
   - DRAFT mode: `gh pr create --draft`.

4. **Post a bot-side cross-link comment** on the new mirror PR:
   ```
   Mirror of https://github.com/endojs/endo/pull/3164 (head 59dfbc6d6).
   ```
   This matches the convention used by the boatman on #387 etc.

5. **Do NOT post anything on upstream endo#3164**. Per the
   2026-05-29 maintainer directive (memory rule), the garden no
   longer posts mirror cross-link comments on upstream PRs.

## Per-action authorizations

- Fetch upstream content. Authorized.
- Push to `endojs/endo-but-for-bots:mirror/3164-freezable-typedarrays`
  (or chosen name). Authorized.
- Open DRAFT PR on endo-but-for-bots. Authorized.
- Post bot-side cross-link comment. Authorized.

## Not authorized

- Modifying upstream endojs/endo (no kriskowal credentials on
  this host).
- Force-pushing anything other than the new mirror branch
  itself (which is a brand-new branch; no lease needed).
- Un-drafting the PR (the gamut un-drafts after CI green).
- Merging.
- Editing the mirrored content (this is a pure mirror; no
  bot-side edits in this dispatch).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--48c1e5/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--48c1e5/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `master` (head `ba26f4cdb`).

## Report

A `result` journal entry. Include:

- New mirror branch name + head SHA (should equal
  `59dfbc6d6...`).
- New PR number + URL on endo-but-for-bots.
- Bot-side cross-link comment ID.
- Any judgment calls (e.g., title shape).
