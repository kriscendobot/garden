# Topic: security-disclosure

> Abstract: How to report a vulnerability to the endo / SES / Agoric ecosystem, and what timelines to expect. Three reporting channels: Agoric HackerOne, encrypted email to `security@agoric.com`, or Keybase to `@agoric_security`. Acknowledgement within one business day; validation within ~72 hours; intent to beat the 90-day industry norm; post-fix attribution via release notes / CVE / Hall of Fame.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-security--overview](../sections/endo--docs-security--overview.md) | endo docs/security.md | Frame for the policy. |
| [endo--docs-security--supported-versions](../sections/endo--docs-security--supported-versions.md) | endo docs/security.md | Latest branch only; users encouraged to upgrade. |
| [endo--docs-security--coordinated-vulnerability-disclosure](../sections/endo--docs-security--coordinated-vulnerability-disclosure.md) | endo docs/security.md | Reporting channels, acknowledgement and validation timelines, attribution. |
| [endo--docs-bugs--overview](../sections/endo--docs-bugs--overview.md) | endo docs/bugs.md | Pointer: security bugs via coordinated disclosure; non-security via Agoric Issues page. |
| [endo--pkg-ses-readme--audits](../sections/endo--pkg-ses-readme--audits.md) | endo packages/ses/README.md | Inventory of security audits SES has undergone, with auditors and dates. |
| [endo--pkg-ses-readme--bug-disclosure](../sections/endo--pkg-ses-readme--bug-disclosure.md) | endo packages/ses/README.md | Same coordinated-disclosure protocol covered by docs/security.md, cited from the SES README. |
| [endo--pkg-module-source-readme--bug-disclosure](../sections/endo--pkg-module-source-readme--bug-disclosure.md) | endo packages/module-source/README.md | Same coordinated-disclosure pointer, cited from the module-source README. |
| [agoric-sdk--security--supported-versions](../sections/agoric-sdk--security--supported-versions.md) | agoric-sdk SECURITY.md | master + latest `agoric-upgrade-*` are the supported security-update set. |
| [agoric-sdk--security--coordinated-vulnerability-disclosure](../sections/agoric-sdk--security--coordinated-vulnerability-disclosure.md) | agoric-sdk SECURITY.md | Same Agoric HackerOne channel as endo; per-repo policy. |
| [endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint](../sections/endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint.md) | endo-but-for-bots designs/ci-no-npm-lifecycle.md (Complete; shipped 2026-05-14) | **Supply-chain-defense design** for the npm lifecycle-script attack vector. The §lifecycle-scripts-run-before-source-audit observation is the *structural why* of the attack class: source-review processes assume source is read before it runs; lifecycle scripts violate that assumption. Supply-chain attacks cited: event-stream / ua-parser-js / node-ipc / 2024 XZ-style typosquatting — *all delivered their payload through lifecycle scripts rather than through source imports*. §Three-layer-auditable defense (config + allowlist + named step). §Belt-and-suspenders env vars with §reviewer-visible-defense rationale. §Two-layer enforcement (repo-level lint + positive `@lavamoat/preinstall-always-fail` tripwire). §Five Design Decisions including §lockfile-immutability-as-supply-chain-defense via `yarn install --immutable` (closes vector where malicious PR mutates lockfile to change what gets resolved). |

## See also

- [`repository-governance`](repository-governance.md): broader governance frame.
