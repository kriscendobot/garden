---
ts: 2026-05-18T19:02:00Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: target
refs:
  - entries/2026/05/18/185100Z-dispatch-steward-b326b0.md
  - https://github.com/endojs/endo-but-for-bots/pull/280#pullrequestreview-4312821322
  - https://github.com/endojs/endo-but-for-bots/pull/280#discussion_r3261240216
  - https://github.com/endojs/endo-but-for-bots/pull/280#discussion_r3261343700
  - https://github.com/endojs/endo-but-for-bots/pull/280#issuecomment-4480970322
---

# Result: fixer preserves Node-20 SES-viable patch history on PR #280

## What landed

Commit `c040dc77e` on `chore/drop-node-20-ci`. Single change: nine added comment lines above the surviving `'22'` entry in the `test-async-hooks` matrix (`.github/workflows/ci.yml`). No matrix values changed. YAML parse-clean.

## Recovered content

From the pre-drop file state (`2ec645b45^:.github/workflows/ci.yml`), the deleted commentary that sat above the (also-deleted) `'20'` matrix entry was:

```
# '20.6' not viable due to https://github.com/nodejs/node/issues/49497
# '20.3' to '20.6' not viable due to https://github.com/nodejs/node/pull/49211
# '20.7' first SES-viable version
# '20.9' first LTS of 20
```

This documented which Node-20 patch versions were viable for the SES promise-hook surface that the `test-async-hooks` matrix exists to exercise. The maintainer's instruction was "preserve the historical record on version compatibility."

## Placement

Restored as a unified historical block above the `'22'` matrix entry, integrating the existing Node-16 patch-version commentary (`'16.1'` / `'16.5'` / `'16.6'`) with the recovered Node-20 lines, framed as a record so future readers see the lineage rather than floating annotations. Added a header sentence (`Historical record of Node patch-version compatibility for the SES-viable promise-hook surface (entries removed as their Node major lines reached EOL or left CI)`) and a closing sentence identifying `'22'` as the post-promise-fast-path lane on a current LTS (wording lifted from `2ec645b45`'s commit body). Reordered the Node-20 lines into ascending-patch order so the trail reads `20.3-6 → 20.6 → 20.7 → 20.9` rather than the original `20.6 → 20.3-6 → 20.7 → 20.9` (a minor cleanup in service of "historical record" framing).

## Final head SHA

`c040dc77e435e68ac4eea69e8511563f0b6a3d77`

Pushed with `--force-with-lease` over `d652c2221`.

## Communications

- Inline reply on the maintainer's comment (id 3261240216) posted as id `3261343700`, citing the addressing SHA.
- Top-level summary on PR #280 posted as `issuecomment-4480970322`, citing both the SHA and the substantive content.

CI is pending on the new head; comment-only diff means the existing-green guarantee from `d652c2221` should extend. No review re-request issued; the dispatch did not authorize one and the change is minimal-surface.

Self-improvement: nothing this time.
