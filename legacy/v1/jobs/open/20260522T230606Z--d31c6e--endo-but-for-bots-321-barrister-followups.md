---
job: d31c6e
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T23:06:06Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 321
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
preconditions: []
refs: []
---

One summary-fix item from the barrister-f40efb panel on PR #321 (`ci(familiar): wire macOS arm64 + x64 matrix end-to-end`, G15 of #231).

## Item — Mixed `.sh` and `.mjs` invocation style in the `make` matrix job

`.github/workflows/familiar-release.yml:113-128` invokes the four matrix steps with mixed wrapper styles:

```yaml
- name: Download Node.js binary
  run: |
    cd packages/familiar
    ./scripts/download-node.sh v20.18.1 ${{ matrix.target-os }} ${{ matrix.target-arch }}

- name: Prepare package
  run: |
    cd packages/familiar
    ./scripts/prepare-package.sh ${{ matrix.target-os }} ${{ matrix.target-arch }}

- name: Package app
  run: |
    cd packages/familiar
    node scripts/package-app.mjs ${{ matrix.target-os }} ${{ matrix.target-arch }}

- name: Make distributables
  run: |
    cd packages/familiar
    node scripts/make-distributables.mjs ${{ matrix.target-os }} ${{ matrix.target-arch }}
```

The first two steps call `.sh` wrappers; the last two call `.mjs` directly. `packages/familiar/scripts/` already has parallel `.mjs` forms for both wrappers (`download-node.mjs`, `prepare-package.mjs`) that accept the same `[target-os] [target-arch]` argument convention. The mixed style is an integration nit (integrator's "merge-commit readability" lens).

## Recommended action

Pick **one** of:

1. **Normalize to `.mjs` invocation** (preferred per the integrator's read): change the first two steps to call `node scripts/download-node.mjs ${{ matrix.target-os }} ${{ matrix.target-arch }}` (passing the node version through a workflow env var or hard-coding the same `v20.18.1`) and `node scripts/prepare-package.mjs ${{ matrix.target-os }} ${{ matrix.target-arch }}`. Confirm cross-platform parity with the `.sh` forms before committing.

2. **Document the why-mixed** in the workflow comment block already in place near the `make` job (lines 61-71): one sentence noting that the `.sh` wrappers carry curl-and-tar logic the `.mjs` forms reimplement and the project deliberately keeps them as the canonical CI entry-points.

Option 1 is the lower-friction long-term answer; option 2 is acceptable as a placeholder.

## Disposition

`summary-fix`. One fixer dispatch addresses the consistency choice. No panel re-run. The un-draft on #321 is not gated on this item per `skills/panel-review/SKILL.md` § Dispositions.
