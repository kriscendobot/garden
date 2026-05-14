# Topic: testing

> Abstract: How to run and write tests in endo. Runtime tests use `ava`; type tests use `tsd` (file pattern `test/types.test-d.ts`). The combined `yarn lint` runs both `lint:types` and `lint:eslint`. Always run `yarn lint` in each modified package before committing.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--testing](../sections/endo--agents--testing.md) | endo AGENTS.md | `yarn test` (ava), `yarn lint:types` (tsd), `yarn lint` (both); pre-commit. |
| [endo--pkg-eventual-send-readme--use-in-tests](../sections/endo--pkg-eventual-send-readme--use-in-tests.md) | endo packages/eventual-send/README.md | Testing patterns for code that uses E()/E.when. |
| [endo--contributing--validation](../sections/endo--contributing--validation.md) | endo CONTRIBUTING.md | yarn test, yarn lint, yarn lint:types; CI gates. |
| [endo--pkg-ses-ava-readme--overview](../sections/endo--pkg-ses-ava-readme--overview.md) | endo packages/ses-ava/README.md | SES-aware AVA wrapper: install ava + ses; use wrappedAva instead of ava. |
| [endo--pkg-ses-ava-readme--compatibility](../sections/endo--pkg-ses-ava-readme--compatibility.md) | endo packages/ses-ava/README.md | Compatibility notes between ses-ava and the upstream ava feature set. |
| [endo--pkg-ses-ava-readme--supporting-multiple-configurations](../sections/endo--pkg-ses-ava-readme--supporting-multiple-configurations.md) | endo packages/ses-ava/README.md | Configuring tests for multiple SES options. |
| [agoric-sdk--agents--build-test-and-development-commands](../sections/agoric-sdk--agents--build-test-and-development-commands.md) | agoric-sdk AGENTS.md | Command inventory including yarn test (AVA). |
| [agoric-sdk--agents--testing-guidelines](../sections/agoric-sdk--agents--testing-guidelines.md) | agoric-sdk AGENTS.md | AVA framework; per-package vs whole-repo; c8 coverage. |
| [agoric-sdk--contributing--integration-tests](../sections/agoric-sdk--contributing--integration-tests.md) | agoric-sdk CONTRIBUTING.md | Force/bypass integration labels; merge-queue interaction. |
| [agoric-sdk--readme--test](../sections/agoric-sdk--readme--test.md) | agoric-sdk README.md | yarn test top-level vs per-package. |

## See also

- [`agent-conventions`](agent-conventions.md): broader agent rules.
