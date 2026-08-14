---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix: clear the `lint` red on endojs/endo-but-for-bots#980 so its gauntlet can resume

PR: https://github.com/endojs/endo-but-for-bots/pull/980
Branch: `feat/ocapn-adopt-ascii`  (draft, base `llm-a54c3ad`)

The gauntlet `ebfb-ascii-adopt-ocapn-sites-gauntlet` HALTED because its
`fix-3` stage completed with `orchestration-failed: true`: CI reached RED and
fix round 3 is the configured ceiling, so no further fixes were applied.

25 of 26 checks pass. The single failure is `lint`, and it is narrow —
two TS2345 errors in one test file:

```
packages/ocapn/test/ascii.test.js(93,37): error TS2345: Argument of type
  '{ type: string; transport: string; designator: string; hints: boolean; }'
  is not assignable to parameter of type 'OcapnLocation'.
packages/ocapn/test/ascii.test.js(98,36): error TS2345: Argument of type
  '{ designator: string; type: string; transport: string; hints: boolean; }'
  is not assignable to parameter of type 'OcapnLocation'.
```

Both are test-fixture object literals that do not satisfy `OcapnLocation`.
Fix the fixtures (or the type, if the literals are correct and the type is
too narrow — decide from the `OcapnLocation` definition, do not merely cast).

Head at halt: `005665a23b`. Failing run:
https://github.com/endojs/endo-but-for-bots/actions/runs/31772960981

## Definition of done
- `lint` green on #980, other 25 checks still green.
- Report whether the gauntlet should be re-run (`run the gauntlet #980`) —
  do not re-run it yourself.
