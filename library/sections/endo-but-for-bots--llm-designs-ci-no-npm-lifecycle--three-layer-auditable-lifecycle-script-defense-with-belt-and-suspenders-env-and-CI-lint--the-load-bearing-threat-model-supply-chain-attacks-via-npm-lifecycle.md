---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §load-bearing-threat-model — supply-chain attacks via npm lifecycle
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

The §What-is-the-Problem-Being-Solved section opens with the
threat model:

> *GitHub Actions workflows that install dependencies with
> scripts enabled give every transitive dependency — and
> every future transitive dependency — arbitrary code
> execution inside the CI runner. That runner has a checkout
> of the repository, cached credentials, and, on release
> workflows, publish tokens and signing keys. One compromised
> `postinstall` in a dependency five levels deep is enough to
> exfiltrate secrets, tamper with build artifacts, or push
> forged commits.*

The §the-runner-is-the-attack-surface observation. CI runners
hold *write access to the workspace + read access to any
secret the job mounted*. A malicious `postinstall` runs with
*all* of those privileges, *before any source is audited*.

§Supply-chain-attacks-cited:

> *The risk is not hypothetical. Supply-chain attacks against
> the npm ecosystem (event-stream, ua-parser-js, node-ipc,
> the 2024 XZ-style typosquatting campaigns) have repeatedly
> delivered their payload through lifecycle scripts rather
> than through source imports, precisely because lifecycle
> scripts run at install time before any source is executed
> or audited.*

The §lifecycle-scripts-run-before-source-audit observation:
this is the *structural why* of the attack vector. Source-
review processes assume source is read before it runs;
lifecycle scripts violate that assumption.
