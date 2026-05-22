---
ts: 2026-05-22T01:06:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 3033
    role: source
---

# Dispatch: builder mirrors endojs/endo#3033 (CBOR alternative encoding) onto endo-but-for-bots@llm

Dispatch root: `dispatches/builder--f30c2e/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/3033 based on the llm branch if that does not already exist."*

Pre-flight: no existing mirror found on endo-but-for-bots (searched `state:all 3033` and grep over branch names; no match).

## Upstream PR #3033

- Author: kriskowal
- Title: "feat(ocapn): CBOR alternative encoding"
- Source branch: `kriskowal-ocapn-cbor` (already fetched as `endo-upstream/kriskowal-ocapn-cbor`)
- Base on upstream: `master`. **Mirror base on the bot fork: `llm`** per the maintainer directive (overrides the standard "implementations branch off master" builder norm).
- State: OPEN, **DRAFT**
- 50 files, +5832 / -464
- Subsystem: OCapN; touches `pass-style`, `marshal`, `ocapn`, and friends. erights' senior-contributor weight applies per `journal/projects/endo/README.md` § Authority structure.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`. The maintainer's "based on llm" directive overrides the default "implementations on master" norm; base off llm.
2. Read `garden/skills/library-lookup/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/pr-formation/SKILL.md`.
3. Read `project/CLAUDE.md` and any `packages/ocapn/CLAUDE.md` if present.
4. Apply the upstream diff onto `llm`. The precedent shape is `mirror/3036-exo-stream` (PR #330) and `mirror/3032-cancel` (PR #345 just merged, head `78e29b25`): per-package re-formation commits + separate `chore: Update yarn.lock` lockfile commit. Cherry-pick (shape a) only if the conflict surface against llm is small; otherwise re-form (shape b). Read the existing mirror precedents' shapes before deciding.
5. Local validation per `project/CLAUDE.md` § Pre-PR checklist: `yarn install`, package tests for the touched packages (`pass-style`, `marshal`, `ocapn` at minimum), `yarn lint`, `yarn docs` / `yarn typecheck`, pre-push-gates. Note: upstream PR is DRAFT, so test failures upstream are expected; report which tests pass locally vs. fail.
6. Push to `endojs/endo-but-for-bots:mirror/3033-ocapn-cbor` (first push, non-force).
7. Open **DRAFT** PR on `endojs/endo-but-for-bots` against `llm`. Title: `feat(ocapn): CBOR alternative encoding (mirror of endojs/endo#3033)`. Body uses kriskowal's upstream PR body + leading paragraph naming the mirror relationship.
8. **Do NOT** cross-post on `endojs/endo#3033`. **Do NOT** un-draft (upstream is DRAFT; mirror stays DRAFT). The contractor's PR-creation-flow scan picks up the orphan DRAFT for the cleaner / judge chain per the 2026-05-21 norm.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:mirror/3033-ocapn-cbor`.
- Open draft PR on `endojs/endo-but-for-bots` against `llm`.
- READ-ONLY on `endojs/endo`. No comments outside the new PR's own body.

## Out of scope

- No cross-post on `endojs/endo#3033`.
- No un-draft.
- No upstream ferry.

## Report

≤ 400 words. Fork PR URL + head SHA. Commit shape chosen. Conflict resolutions on the `llm`-vs-`master` boundary. Local test status per command. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-f30c2e.md` (refs: this entry) and push journal (rebase if non-fast-forward).
