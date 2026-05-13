# Topic: testing

> Abstract: How to run and write tests in endo. Runtime tests use `ava`; type tests use `tsd` (file pattern `test/types.test-d.ts`). The combined `yarn lint` runs both `lint:types` and `lint:eslint`. Always run `yarn lint` in each modified package before committing.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--testing](../sections/endo--agents--testing.md) | endo AGENTS.md | `yarn test` (ava), `yarn lint:types` (tsd), `yarn lint` (both); pre-commit. |

## See also

- [`agent-conventions`](agent-conventions.md): broader agent rules.
