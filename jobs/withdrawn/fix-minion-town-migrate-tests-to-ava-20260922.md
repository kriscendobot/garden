---
withdrawn: true
withdrawn_reason: Reversed by the maintainer. The ava directive (review 5273122355, 'This house uses ava', 2026-09-22T00:26Z) is superseded by kriskowal's later comment 5770443815 (2026-09-22T02:39Z, PR #87): 'Repo-wide migration to vitest. The Endo repository dictates house style.' minion.town is ALREADY entirely on vitest (51 test files since initial commit; vitest.config.ts; npm test == vitest run); Endo itself migrated ava->vitest, so house style is vitest, not ava. The vitest->ava migration must NOT happen; this parked entry's scope question is answered as 'stay on vitest, repo-wide.'
withdrawn_by: gardener
withdrawn_at: 2026-09-22T03:09:05Z
withdrawn_from_gate: awaiting-maintainer
---

---
gate: awaiting-maintainer
maintainer_question: 'Migrate minion.town vitest->ava: repo-wide dedicated PR (rec) vs PR #87-local vs other?'
asked_at: https://github.com/kriscendobot/minion.town/pull/87#pullrequestreview-5273122355
priority: normal
posted_by: fixer
posted_at: 2026-09-22T01:51:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Migrate minion.town test suite from vitest to ava (kriskowal directive)

Origin: review directive on kriscendobot/minion.town#87
(pullrequestreview-5273122355, kriskowal): "This house uses `ava` for testing."

The whole repo currently uses **vitest** (51 test files including PR #87's 6 new
claude-*.test.ts; a vitest.config.ts; `npm test` == `vitest run`; devDep vitest,
no ava — vitest present since the initial commit 315fbd0). Satisfying the
directive coherently means a REPO-WIDE migration, NOT a per-PR conversion (two
runners can't cleanly coexist; converting only some files breaks CI).

Scope PENDING maintainer confirmation (asked via maintainer inbox 2026-09-22):
recommended option (a) — a dedicated repo-wide vitest->ava migration PR, after
which kriscendobot/minion.town#87 rebases onto it with its tests in ava.

Work when promoted (fixer/americanizer-style deterministic conversion):
- Add ava devDep + ava config; drop vitest config/devDep; update `test` script.
- Convert all *.test.ts: describe/it -> flat ava tests with prefixed titles;
  expect(x).toBe/toEqual/... -> t.is/t.deepEqual/...; rejects.toThrow ->
  t.throwsAsync; beforeEach/afterEach -> test.beforeEach/afterEach or per-test
  fixtures; vi mocks -> plain fakes/esmock as needed.
- Keep the vitest excludes semantics (deploy/thunks/siwe, tools/claude-harness).
- `npm run typecheck` + the new ava `npm test` both green (CI's two gates).
