---
title: §Caretaker-revocation
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
section-id: the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
---

> Revoking the capability invalidates the exo and optionally revokes the OAuth token with the provider.

§Two-named-revocation-actions: (1) §invalidate-the-exo (local); (2) §optionally-revoke-the-OAuth-token-with-the-provider (remote). §The-optionally-acknowledges-that §provider-side-revocation-might-fail-or-be-unavailable.

§Borrowable-pattern: §two-layered-revocation (local + remote) with §the-remote-step-as-optional-because-it-might-fail. §The-local-step-is-the-authoritative-revocation; §the-remote-step-is-best-effort-cleanup.

§Sibling to cycle 226 endoclaw-cluster's §every-capability-pair-has-revoke-and-help — cycle 234 §extends-revoke-with-an-optional-provider-side-step.
