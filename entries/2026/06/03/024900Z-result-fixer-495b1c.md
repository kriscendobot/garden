---
ts: 2026-06-03T02:49:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 495b1c
prs:
  - { repo: endojs/endo-but-for-bots, pr: 394, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebased }
refs:
  - entries/2026/06/03/022843Z-dispatch-fixer-495b1c.md
  - https://github.com/endojs/endo-but-for-bots/issues/407
---

# result: fixer — #394 one-repo redesign + cascade COMPLETE; #407 filed for daemon scope

## Settled

- **#394** redesign SHA `119d21f45`:
  - URL path: `/git/<op>` (drops repo-id segment).
  - `resolveRepo({token, repoId})` → `serveRepo({token})`.
  - `RepoCapability` → `DaemonRepoCapability`.
  - types.d.ts + makeGateway power + index.js + design body
    all carry new shape.
  - Test fixture upgraded sha256-of-label (caught latent LCG
    seed-collision bug).
  - 279/279 gateway tests passing.

## Cascade rebases

| PR | Head | Tests |
|----|------|-------|
| 395 | 515f7cfbd | 321 |
| 396 | dc18b3d90 | 363 |
| 397 | 32c2f7429 | 397 |

`rerere` cached the types.d.ts conflict resolution.

## Daemon scope deferred → follow-up issue #407

Daemon does not yet embed gateway / implement Git-backed CAS.
Issue #407 filed with full quoted directive (CAS replacement,
@0xpatrickdev library or libgit2, sha256 variant, etc.).

## Upstream actions taken

- Review-thread reply citing addressing SHA.
- Top-level summary with @kriskowal mention.
- Re-request review via JSON-body shape.
- Follow-up issue #407.

## Latent bug found

Sibling commit's LCG-seed rename had silently caused
`wrongToken` and `token` to produce colliding hashes (the
LCG's `state % 16` chain collapses to a 16-cycle and ignores
upper seed bits). Replaced with sha256-of-label.

## Self-improvement

When a fixer renames a constant in a test fixture with
hand-rolled randomness, validate the renamed value does not
collide with siblings before pushing. The sha256-of-label
replacement is the correct shape for deterministic test
fixtures.

## Liaison disposition

Dispatch root torn down. **All five layers with kriskowal
review feedback (#388, #389, #392, #393, #394) are now
settled.** Remaining:
- **#343 follow-up**: CLI start/stop/log subcommands +
  systemd install. New PR, not in-stack.
- **Phases 10 + 11**: HTTPS proxy compat (#9), OS packaging
  (#10). Originally paused on 529 API overload.
- Layers #395-#397 have NOT been reviewed by maintainer yet.
