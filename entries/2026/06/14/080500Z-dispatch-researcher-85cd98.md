---
ts: 2026-06-14T08:05:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--85cd98
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4492612214
---

# dispatch: researcher — references for factoring daemon-cas out of daemon (#403 follow-on)

Maintainer directive on PR #403 (kriskowal at 2026-06-14T08:03Z,
review `4492612214`, body):

> Now, to validate the premise, please append work that
> factors daemon-cas out of daemon. This should be a
> temporary, intermediate step on the way to migrating
> the daemon to use git-cas.

Precedence dispatch ahead of the builder that does the
extraction.

## Scope of the research

Builder needs:
- The current CAS (Content-Addressable Storage) surface in
  `packages/daemon/`. Find all files/identifiers carrying
  "cas" or related (content addressing, hashing, storage by
  digest).
- The dependency boundary: what daemon code consumes the
  CAS API? What does the CAS code consume from daemon?
- The intended `@endo/daemon-cas` package shape (new
  workspace): package.json, exports, types.d.ts skeleton.
- The migration path to `git-cas` later (what shape does
  the eventual git-cas drop-in need?).
- Any prior design documents that frame the daemon-cas
  split or git-cas migration. Check `designs/` on both
  `master` and `llm` branches.
- The package-uniformity template `packages/skel/` for the
  new package's shape.

In your `project/` worktree at endo-but-for-bots
`feat/registry-capability` (the PR's head):

1. **Map the CAS surface in daemon**:
   - `git grep -lI -i 'cas\|content.address\|by.digest'
     packages/daemon/src/`
   - Identify the central CAS module(s) and their
     interfaces.
2. **Map daemon's consumers of CAS**:
   - Within `packages/daemon/`, which files import the CAS
     module(s)?
   - The boundary that becomes `@endo/daemon-cas`'s public
     API.
3. **Map external consumers** (if any): does anything
   outside `packages/daemon/` already import daemon's CAS
   API? Likely not (since it's currently internal).
4. **Locate design docs**:
   - `find designs -iname '*cas*'`
   - `find designs -iname '*git-cas*'`
   - `find designs -iname '*registry*'` (since the PR is
     about registry-capability and the maintainer ties CAS
     extraction to it).
5. **Sketch the new package**:
   - `packages/daemon-cas/package.json` shape (mirror skel).
   - `packages/daemon-cas/src/` module structure (the
     extracted modules + their internal interfaces).
   - `packages/daemon-cas/index.js` exports.
   - `packages/daemon-cas/types.d.ts` shape.
6. **Recommend an extraction commit ladder** for the
   builder (e.g., (1) create skeleton package, (2) move
   CAS modules with import paths, (3) update daemon
   consumers, (4) move tests).
7. **Identify any risks**: cyclic deps if extraction
   exposes hidden coupling; test surface that needs to
   move; etc.

## Output shape

Produce a `result` entry under
`journal/entries/2026/06/14/` with the standard
`## Library and project references` section.

## Out of scope

- Do NOT propose the git-cas drop-in design (that's the
  next-next step).
- Do NOT touch source.

## Authorizations

Read-only.

## Deliverable

A `result` entry ready for inlining into the builder brief.

End your turn with a concise summary back to the orchestrator.
