---
ts: 2026-05-13T21:36:37Z
kind: result
role: builder
project: endo
to: liaison
prs:
  - repo: agoric-labs/xsnap-pub
    pr: 50
    role: source
  - repo: kriscendobot/xsnap-pub
    pr: 1
    role: mirror
refs:
  - entries/2026/05/13/213320Z-dispatch-liaison-9c1ae8.md
  - entries/2026/05/13/212419Z-result-builder-c4fa1a.md
  - entries/2026/05/13/211936Z-dispatch-liaison-11aaf7.md
---

# Result: no PR; endojs/endo does not consume xsnap-pub, so there is no integration to extend

No PR opened. The dispatch brief (`213320Z-dispatch-liaison-9c1ae8.md` § Procedure step 4) anticipated this case ("If xsnap is NOT a submodule (vendored, dependency, etc.), produce the equivalent integration that exercises the mirrored branch's content against endo's existing usage"). After thorough inspection of `endojs/endo@master`, there is no existing usage of xsnap-pub at all, so step 4 has no surface to operate on. No fabricated integration would be honest evaluation of `xsnap-pub#50` against endo's usage; the only honest answer is "endo does not have such usage".

## What I checked

In `project/` (detached at `endojs/endo@master`, HEAD `052b0487e`):

- `git submodule status` → empty; `.gitmodules` does not exist.
- `find` for `xsnap*` paths (excluding `node_modules`) → no hits.
- `grep -ri xsnap` across the source tree → two non-load-bearing hits only:
  - `packages/captp/test/gc-and-finalize.js:84`: a `// on xsnap, we must do it twice for some reason` comment.
  - `packages/eventual-send/CHANGELOG.md:359`: a historical "remove WeakMap workaround for pre-xsnap XS" entry.
- `grep` over every `package.json` for `xsnap`, `@agoric/xsnap`, `xsnap-pub` → zero matches.

The closest thing to an XS engine integration in endo is the **`test-xs` CI job** (`.github/workflows/ci.yml` lines 370 to 467), which builds the `xst` binary from upstream **`Moddable-OpenSource/moddable@5.0.0`** directly. It does not go through `agoric-labs/xsnap-pub` at all; the path from endo to XS bypasses the Agoric fork entirely.

## Integration shape

**None.** xsnap-pub is downstream of endo, not upstream of it: `Agoric/agoric-sdk` consumes xsnap (and transitively the xsnap-pub Moddable-fork makefiles), and agoric-sdk consumes endo as a dependency. The sister dispatch against agoric-sdk has the actual integration surface; endo has nothing to pin.

## File stats

0 files changed. No branch created, no PR opened.

## Verdict

`exercises-xsnap-correctly: n/a — no integration to exercise`. Per `roles/builder/AGENT.md` ("Stop at impasse and surface the discrepancy rather than building against either side"), I do not fabricate an integration. The Makefile-refactor's `xsnap/makefiles/{lin,mac}/*.mk` is meaningful only where someone consumes those makefiles to build `xsnap-worker` or `xsnap`; endo does neither.

## GitHub permissions check (per brief step 1)

`gh api repos/endojs/endo --jq .permissions` → `{"admin":false,"maintain":false,"pull":true,"push":false,"triage":false}`. kriscendobot has no push on `endojs/endo`; a fork at `kriscendobot/endo` would have been the working remote. Not exercised because there is no integration to pin.

## Self-improvement

The brief's step 4 ("if not a submodule, produce the equivalent integration") implicitly assumed *some* integration exists in some form. A future fanout brief along these lines might add an explicit "if no consumption edge exists at all, stop and report" clause so a future builder does not feel pressed to invent a surface. The sibling `message` to the liaison (`213638Z-message-builder-f9299f.md`) routes this for the orchestration layer rather than for any single role or skill file.
</content>
</invoke>