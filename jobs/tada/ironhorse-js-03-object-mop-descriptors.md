Implemented and pushed ordinary-object MOP completion to shared PR https://github.com/endojs/endo-but-for-bots/pull/970.

- Head: `6c497251c58985cd0572e41d980a4af5897dea61`
- Added centralized get/set/delete/define/ownKeys behavior, descriptors/accessors, symbols, index ordering, extensibility, prototype writes, computed properties, object spread/rest, and strict-delete early errors.
- Object/Reflect slice: 2946 total, 126→1151 covered, 0 failed, 1795 scoped skips.
- Expression slice: 2580 total, 529→1383 covered, 0 failed, 1197 scoped skips.
- Eliminated `set_property_at`, `delete_property_at`, `delete_property`, and `copy_object` skips in scope; accessor-descriptor skips fell 340→2 and partial-descriptor skips 268→3.
- Exact-meter corpus: 1711/1711 covered, zero failures/skips.
- Full workspace: 480 tests passed, zero failed.
- No prior covered cases regressed and no infrastructure results appeared.
- Test262 and XS pins remained unchanged. PR remains open; remaining skips chiefly require arguments/exotic-object or re-entrant Reflect support.
- Posted detailed PR report: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5225381430
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-03-object-mop-descriptors.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3605s

<!-- garden-usage-end -->
