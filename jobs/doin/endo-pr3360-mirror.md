---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Maintainer directive (2026-09-02, liaison session): create a mirror of
https://github.com/endojs/endo/pull/3360 ("Improve portability of
ModuleSource on the web with Babel 8", opened by kriskowal, head branch
`fix-process-global` on the fork https://github.com/james-pre/endo, base
`master` at commit https://github.com/endojs/endo/commit/77d9d0cdf82e58e0dcf6f38fdc54798e37f0ab93,
head at commit https://github.com/endojs/endo/commit/02ca139ddf0b075f11c85b2a7570cf7940067828,
4 commits, currently DRAFT) onto `endojs/endo-but-for-bots`.

## What "mirror" means here

A faithful, read-only reproduction of that upstream PR's exact commits as a
new PR on `endojs/endo-but-for-bots`, so the garden can track/inspect it
through normal tooling — **not** any interaction with the real upstream PR.
`endojs/endo-but-for-bots` has no live `master` trunk of its own (it's a
fork with `llm` as trunk; `master` there is reserved for reflections of
upstream `endojs/endo`'s `master`, per `roles/conductor/AGENT.md`'s
"no master trunk" exception and `skills/frozen-base-branch/SKILL.md`).

1. Create (or reuse, if one already exists) a frozen-base snapshot branch on
   `endojs/endo-but-for-bots` reflecting upstream `endojs/endo`'s `master` at
   exactly commit `77d9d0cdf82e58e0dcf6f38fdc54798e37f0ab93` — the PR's own
   base — named `master-77d9d0c` (or the skill's standard short-SHA
   convention). Note `endojs/endo-but-for-bots` almost certainly does not
   already have this commit as a reachable object; fetch it from
   `https://github.com/endojs/endo` directly rather than assuming it's
   already present.
2. Fetch the PR's exact 4 commits (head
   `02ca139ddf0b075f11c85b2a7570cf7940067828`) from
   `https://github.com/james-pre/endo` branch `fix-process-global` and push
   them, byte-identical, as a new branch on `endojs/endo-but-for-bots` — no
   rebase, no squash, no edits to the commits themselves. Pick a clear branch
   name, e.g. `mirror/endo-pr3360-fix-process-global`.
3. Open a **draft** PR on `endojs/endo-but-for-bots` (draft, matching the
   upstream PR's own current state) with head = that mirror branch, base =
   the `master-77d9d0c` frozen snapshot. Title it clearly as a mirror (e.g.
   "mirror: Improve portability of ModuleSource on the web with Babel 8
   (endojs/endo#3360)"). Body: plainly state this is a mirror of
   https://github.com/endojs/endo/pull/3360 for the garden's own tracking,
   citing the fully-qualified URL per
   `skills/fully-qualified-github-urls/SKILL.md`, and include the standard `<!-- garden-job: endo-pr3360-mirror -->`-style job
   marker in the body (see the shape used on `kriscendobot/minion.town`#67
   for precedent).

## Explicit authorization and boundary

You are authorized, by this directive, to cite the upstream PR's
fully-qualified URL in the mirror's own title/body — that reference is the
one thing needed to say what's being mirrored, and per
`roles/COMMON.md` § External-repo etiquette a cross-reference needs
exactly this kind of explicit, maintainer-originated per-action
authorization; you have it, for this one citation, in this one PR body.

This authorization extends no further. You are **not** authorized to, and
must not, comment on, review, close, merge, or post anything to the actual
upstream `https://github.com/endojs/endo/pull/3360`, or to
`https://github.com/james-pre/endo`, or to `@`-mention `james-pre` or
`kriskowal` anywhere in this process — `roles/COMMON.md`'s absolute
boundary on upstream `endojs/endo` applies regardless of who issued this
directive (Boundary — authority ≠ credentials). Everything you do here
touches only `endojs/endo-but-for-bots`, a repo the bot already has
ordinary write access to; no ferry, identity switch, or special credential
is involved — you're only ever reading two public repos and writing to one
you already own.

## Scope: stop after the mirror exists

Do not run the panel, a gauntlet, or any fix-loop against the mirror once
it's open — it reproduces someone else's in-progress, external draft work,
and starting a review/fix machinery on it wasn't asked for and would be
presumptuous. Report the mirror PR's URL and stop.











<!-- garden-transient-elapsed: kind=signature through=3 values=6,7 -->
<!-- garden-elapsed-constancy: 1 -->

<!-- garden-reaped: 4 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-02T19:45:48Z
