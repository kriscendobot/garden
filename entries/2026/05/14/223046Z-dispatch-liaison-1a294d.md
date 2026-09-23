---
ts: 2026-05-14T22:30:46Z
kind: dispatch
role: liaison
project: endo
to: "*"
prs:
  - repo: endojs/endo
    pr: 3258
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
---

# Dispatch: boatman resets endojs/endo#3258 to current llm-head SECURITY.md state

Dispatch root: `dispatches/boatman--1a294d/`. Project worktree on `endojs/endo:chore/security-md-uniformity` (detached at `f4e6e8e6`, the current upstream tip).

Maintainer directive (2026-05-14): *"Please dispatch a fixer to reset the mirror for https://github.com/endojs/endo/pull/3258 to the actual branch and shepherd through CI. The rebase introduced a package that broke the new rule."*

The user said "fixer", but the operation is upstream-force-push (kriskowal identity); that's the boatman's canonical motion. Treating this as a boatman dispatch.

## Context

- bots-side source: `endojs/endo-but-for-bots#228` (merged 2026-05-14T00:45 onto llm) introduced `scripts/check-security-md.sh` and the uniform `SECURITY.md` files across every existing workspace package on llm.
- Boatman ferried that work to upstream as `endojs/endo#3258` on branch `chore/security-md-uniformity`.
- Since the ferry, additional bots-side work landed: `#245` (added missing `SECURITY.md` to `packages/harden-test/` and `packages/hex-test/` — two packages that were created on llm but missed the uniformity check at ferry time).
- The upstream PR #3258's `lint` job is now FAILING at `f4e6e8e6`. Most likely cause: when the upstream branch was rebased (or some new package was introduced during the ferry), the new package landed without `SECURITY.md`, and the uniformity check fires on the PR's own new check.
- The bots-side state is correct (post-#245). The upstream branch needs to be force-pushed to reflect the current llm-head's SECURITY.md story.

## Per-action authorization

**`identity_switch_authorized: true`** — the maintainer's directive explicitly asks for this re-ferry; the boatman force-pushes to `endojs/endo:chore/security-md-uniformity` under the `kriskowal` identity. The bot identity (`endolinbot` / `main.barn5084@fastmail.com` on this host) does NOT push upstream.

## Task

1. **Inspect the upstream's current state**. The dispatch worktree's HEAD is `f4e6e8e6`. Run `bash scripts/check-security-md.sh` (the upstream tree has this script). Note which package(s) are missing `SECURITY.md` per the check's output.

2. **Diff against bots-side llm**. The bots-side `llm` branch has the correct SECURITY.md story (post-#245). The boatman fetches `endojs/endo-but-for-bots:llm` and produces the diff between (a) upstream's `chore/security-md-uniformity` tip and (b) bots-side `llm` for the security-md-related paths. The boatman picks the cleanest approach:
   - **Option A**: cherry-pick #245's `SECURITY.md` additions onto the upstream branch on top of `f4e6e8e6` (small targeted fix).
   - **Option B**: re-ferry the linearized bots-side diff onto a fresh branch off `endojs/endo:master`, force-push to `chore/security-md-uniformity`. The re-ferry pattern (used today for #75, #109, #223, #226 re-ferries) replaces the upstream branch wholesale.
   
   Option A is the minimal-disruption path if only the SECURITY.md additions are missing; Option B is appropriate if the upstream branch has drifted substantively from bots-side.

3. **Re-author commits under `Kris Kowal <kris@cixar.com>`** (author + committer); verify zero bot trailers with `git interpret-trailers --parse`.

4. **Force-push** to `endojs/endo:chore/security-md-uniformity` using `--force-with-lease` (current upstream tip `f4e6e8e6` is the lease anchor). Verify lease.

5. **Watch CI**. `gh pr checks 3258 -R endojs/endo --watch` until `lint` reports SUCCESS (the previously failing check). Other checks should remain SUCCESS.

6. **Identity discipline**: any explanatory comment on `endojs/endo#3258` routes via `message`-to-`steward` (per the rule landed at `cac9cbb`). The bot identity is not authorized to comment upstream. No comment on the bots-side #228 (it's merged; the engagement is upstream-only).

## Out of scope

- No comment on upstream #3258 from this dispatch; route via steward.
- No edit to bots-side llm (the source state is correct; only the upstream needs resetting).
- No new upstream PR; the existing #3258 is the target.

## Report

≤ 300 words: which option taken (A or B), upstream head after force-push, conflicts encountered (one line each), CI status (lint SUCCESS), message-to-steward queued for any explanatory comment, one-line `Self-improvement: ...`.
