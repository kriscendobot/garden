---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §native-addons exception with §`@lavamoat/allow-scripts`
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

> *Two packages declare `"built": true` in `dependenciesMeta`
> and appear in the lavamoat allowlist:*
> *- `@ipshipyard/node-datachannel`*
> *- `better-sqlite3`*
>
> *Both are legitimate native-module builds, not arbitrary
> scripts. They run through `@lavamoat/allow-scripts`, which
> checks each entry against the repo's explicit allowlist
> before executing.*

The §narrow-allowlist-for-legitimate-exceptions discipline.
Native node-gyp builds are *necessary*; the allowlist names
them *explicitly*. Any future package trying to sneak a build
into the workspace must be *added* to the allowlist, which
shows up as a diff a reviewer can audit.

The §named-list-not-pattern-match approach: the allowlist
contains *exact package names*, not regex patterns. A new
malicious package can't masquerade as an allowlisted one by
having a similar name.
