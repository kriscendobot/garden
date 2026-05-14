# Topic: testing

> Abstract: How to run and write tests in endo. Runtime tests use `ava`; type tests use `tsd` (file pattern `test/types.test-d.ts`). The combined `yarn lint` runs both `lint:types` and `lint:eslint`. Always run `yarn lint` in each modified package before committing.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [agoric-sdk--agents--build-test-and-development-commands](../sections/agoric-sdk--agents--build-test-and-development-commands.md) | agoric-sdk AGENTS.md | The canonical command inventory for agoric-sdk work: `corepack enable && yarn install` to bootstrap, `yarn build` for kernel bundles, `yarn test` for AVA across all packages, `yarn lint` / `yarn lint-fix`, `yarn run -T tsc --noEmit --incremental` for fast per-package typecheck (plus a `--watch --preserveWatchOutput` mode the agent can monitor), `yarn typecheck-quick` for whole-repo (4-7s), `yarn format` (dprint), `yarn hooks:install` for git hooks, `./ |
| [agoric-sdk--agents--testing-guidelines](../sections/agoric-sdk--agents--testing-guidelines.md) | agoric-sdk AGENTS.md | agoric-sdk's testing framework is AVA. |
| [agoric-sdk--contributing--integration-tests](../sections/agoric-sdk--contributing--integration-tests.md) | agoric-sdk CONTRIBUTING.md | Integration tests in agoric-sdk are slow and do not run on every PR push by default. |
| [agoric-sdk--pkg-smart-wallet-readme--notifiers](../sections/agoric-sdk--pkg-smart-wallet-readme--notifiers.md) | agoric-sdk packages/smart-wallet/README.md | There are no automated on-chain tests for the smart wallet; this section is the manual procedure. |
| [agoric-sdk--readme--test](../sections/agoric-sdk--readme--test.md) | agoric-sdk README.md | How to run unit tests in agoric-sdk: `yarn test` from the top-level runs across all packages; per-package, `cd packages/<name>` and `yarn test`. |
| [endo--agents--testing](../sections/endo--agents--testing.md) | endo AGENTS.md | Endo's three test commands are `yarn test` (ava, runtime), `yarn lint:types` (tsd, type tests in `test/types.test-d.ts`), and `yarn lint` (runs both `lint:types` and `lint:eslint`). |
| [endo--contributing--validation](../sections/endo--contributing--validation.md) | endo CONTRIBUTING.md | How to run the test and lint suites before submitting a PR: yarn test, yarn lint, yarn lint:types (tsd). |
| [endo--pkg-eventual-send-readme--use-in-tests](../sections/endo--pkg-eventual-send-readme--use-in-tests.md) | endo packages/eventual-send/README.md | Patterns for testing eventually-sent code: the eventual-send shim is synchronous-by-default in single-threaded JS (just defers to the microtask queue), so tests can await an E() call directly. |
| [endo--pkg-ses-ava-readme--compatibility](../sections/endo--pkg-ses-ava-readme--compatibility.md) | endo packages/ses-ava/README.md | Compatibility notes: which ava features work as-is under SES, which need adaptation, and which are unsupported. |
| [endo--pkg-ses-ava-readme--overview](../sections/endo--pkg-ses-ava-readme--overview.md) | endo packages/ses-ava/README.md | @endo/ses-ava is an ava-compatible test framework wrapper that runs tests under a SES-locked-down environment. |
| [endo--pkg-ses-ava-readme--supporting-multiple-configurations](../sections/endo--pkg-ses-ava-readme--supporting-multiple-configurations.md) | endo packages/ses-ava/README.md | How a single test file can exercise multiple SES configurations (different lockdown option combinations). |
| [endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy](../sections/endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy.md) | endo-but-for-bots designs/base64-native-fallthrough.md | Test-only `ENDO_BASE64_FORCE` env-var gate (`native`/`polyfill`/unset); test files split into polyfill-message-regex and native-error-type assertions; CI matrix runs both paths on every supported Node version. |

## See also

- [`agent-conventions`](agent-conventions.md): broader agent rules.
