---
ts: 2026-06-02T23:51:47Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--cd5030
short_id: cd5030
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: mirror
  - repo: endojs/endo
    pr: 3294
    role: upstream
refs:
  - https://github.com/endojs/endo/pull/3294#pullrequestreview-4414262302
  - https://github.com/endojs/endo-but-for-bots/pull/387
---

# dispatch: fixer — apply gibson042's final APPROVED inline suggestion on mirror #387

Apply gibson042's final review (APPROVED + one inline suggestion
on endo#3294) onto our mirror PR #387. Inline suggestion:
relative-path traversal for the V8 launcher in
packages/benchmark/install-engines.sh.

Note: the earlier fixer renamed `.engines` → `.bench-engines`
on our mirror per kriskowal directive; gibson042's suggestion
references the old `.engines` path. Apply the suggestion's
INTENT (relative-traversal pattern via `dirname` cascade) but
keep the renamed `.bench-engines` path.
