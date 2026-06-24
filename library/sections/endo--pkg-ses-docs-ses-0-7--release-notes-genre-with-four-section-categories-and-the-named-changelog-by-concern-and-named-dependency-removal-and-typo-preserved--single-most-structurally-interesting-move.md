---
title: Single most structurally interesting move
section-slug: endo--pkg-ses-docs-ses-0-7--release-notes-genre-with-four-section-categories-and-the-named-changelog-by-concern-and-named-dependency-removal-and-typo-preserved
source-slug: endo--pkg-ses-docs-ses-0-7
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/ses-0.7.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/ses-0.7.md
total-lines: 64
ingest-cycle: 295
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--pkg-ses-docs-ses-0-7--release-notes-genre-with-four-section-categories-and-the-named-changelog-by-concern-and-named-dependency-removal-and-typo-preserved
---

**§the-named-dependency-removal-as-named-release-event-shape** combined with **§the-removal-IS-named-with-named-explanation-of-the-prior-problem** — the release notes don't just say "we removed dependencies X and Y"; they explicitly name *what each removed dependency was doing wrong*. The `esm` package "transpiles code, alters globals, and proxies module namespaces" — three named side-effects that conflict with SES's purposes.

This generalizes to any security-tooling release notes: **the named-removal-IS-the-named-release-content**, and **the named-prior-problem-IS-the-named-justification**. Removing dependencies IS a celebrated release event in security-tooling because reducing surface area = reducing attack surface. The discipline IS to *name the problem the dependency caused*, not just *what was removed*.

§the-removal-IS-not-just-a-deletion-IS-a-named-architectural-shift — and the architectural shift IS named with its motivating problem.
