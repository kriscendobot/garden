---
ts: 2026-05-15T02:42:00Z
kind: dispatch
role: general-contractor
to: builder
project: endo-but-for-bots
worktree: dispatches/builder--03b9cc/project
refs:
  - entries/2026/05/15/020448Z-message-general-contractor-51eef2.md
---

# Dispatch builder: implement `hardened-text-codecs-shim` (slot 3)

Slot 3 picks up a fresh design from the roadmap branch: `designs/hardened-text-codecs-shim.md` (Status: Not Started). The design adds hardened `TextEncoder` / `TextDecoder` to SES `universalPropertyNames`.

Walk verdict (per `skills/design-dependency-walk/SKILL.md`): **start-here**. The design's two declared deps (`hardened-url-shim`, `base64-native-fallthrough`) are annotated "Independent" / "may land in either order" in the design body. No stack needed.

Dispatch root: `dispatches/builder--03b9cc` (project worktree at `endojs/endo-but-for-bots@master`, current head ~`c2fc02eb8`).

## Task

Read the design file from the roadmap branch:

```sh
gh api 'repos/endojs/endo-but-for-bots/contents/designs/hardened-text-codecs-shim.md?ref=llm' --jq '.content' | base64 -d > /tmp/design.md
```

Implement the design on `master`-base. Per the design's *Phases* section:

1. **Phase 1**: Add the permits and sampling. The design's *Permits table* names the exact prototype methods. Touch `packages/ses/src/permits.js` (add `TextEncoder` and `TextDecoder` to `universalPropertyNames`) and verify `packages/ses/src/intrinsics.js`'s `sampleGlobals` already tolerates the additions.
2. **Phase 2**: Tests and changeset. Add tests under `packages/ses/test/` covering the round-trip behavior, the `prototype.encoding` invariant, and (per the design) the XS-style "missing-on-host" graceful degradation.
3. **Phase 3**: Downstream audit (note in PR body or as follow-up; not blocking the initial PR).

This is a source-touching PR (not design-only). Open as `--draft` against `master`. The PR title and body follow `skills/pr-formation/SKILL.md`. Add a `changeset` per `skills/changeset-discipline/SKILL.md` because this adds to the SES exported intrinsic surface (consumer-observable).

Reference: the design references the parallel `hardened-url-shim` work. Both designs share the source issue (endojs/endo#2635) but split on implementation scope. This PR is scoped to text codecs only.

## Per-action authorization (forwarded by general-contractor)

- Commits and pushes to `feat/hardened-text-codecs-shim` (or your chosen branch name) are implicit.
- Opening the draft PR is implicit.
- No upstream interaction, no boatman ferrying.
- Reading the design from llm via the gh API (no checkout of llm needed).

## Definition of done

- Draft PR open against `master`, title and body follow pr-formation.
- Phase 1 + Phase 2 implementation in place.
- Tests prove the round-trip and the missing-on-host degradation per `skills/regression-evidence/SKILL.md`.
- Changeset added.
- Pre-PR checklist run (`yarn format`, `yarn lint`, `yarn build`, `yarn test` in the touched packages).
- Separate `chore: Update yarn.lock` commit if dependencies changed.
- Result entry naming the PR number, affected packages, any out-of-scope deferrals.

Self-improvement per `garden/skills/self-improvement/SKILL.md`.
