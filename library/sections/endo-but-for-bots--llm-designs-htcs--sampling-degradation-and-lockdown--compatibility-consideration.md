---
title: Compatibility consideration
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
parent: endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown
---

> *Code that monkey-patches the codecs.* Any code that today does
> `TextEncoder.prototype.foo = ...` after `@endo/init` will throw,
> because the permitted intrinsics are frozen. Such code must
> perform its mutation before lockdown (the same rule that already
> applies to every other intrinsic).

The design recommends noting this in the SES changeset for the
release that ships the shim.
