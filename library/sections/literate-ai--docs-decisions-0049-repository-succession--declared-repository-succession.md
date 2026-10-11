---
title: "ADR 0049: Declared repository succession"
source: docs/decisions/0049-repository-succession.md
source_repo: jordanhubbard/literate-ai
source_commit: e797acdd6d8cf7254e38135f90b0421ad3ed4168
source_date: 2026-10-05
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [repository-governance, signed-updates, software-supply-chain]
status: current
---

> Abstract: One exact predecessor-to-successor declaration permits update continuity without rewriting recorded provenance; an attempted private bridge release failed, so 1.0.x prefix installs require one manual reinstall.

Declare repository moves explicitly in `literate_ai.repository_urls`. A move is a
predecessor-to-successor mapping between exact GitHub coordinates. The only declaration
is `github.com/NVIDIA-dev/literate-ai` to `github.com/jordanhubbard/literate-ai`.

- `repository_origin_continues(previous, upstream)` accepts an upstream that is the same
  repository, by existing transport-alias rules, or that resolves to the same current
  repository through declared moves. Project update planning uses it in place of plain
  equivalence. Different hosts, owners, repositories, ports and credentials stay
  distinct, and `repository_urls_equivalent` is unchanged.
- `current_repository_origin(url)` follows declared moves. Self-update resolves its
  release endpoint through it, so a build whose embedded origin is the predecessor
  checks the successor's releases.
- Recorded origins, initialization baselines and Standard pins are never rewritten.
  The project keeps its historical provenance; Standard rebind remains the reviewed
  path for any changed installed payload, as for every upgrade.

Releases 1.0.x cannot learn the successor. For enrolled prefix installs, the 1.1.0
release publishes one bridge: the identical 1.1.0 wheel is also attached to a `v1.1.0`
release on the predecessor repository, which is unarchived only for that publication.
1.0.x installs then self-update once to 1.1.0, whose embedded public origin directs
every later check to the successor. Pip and editable installs upgrade manually from
the successor's releases.

**Amended at 1.1.0 publication (2026-10-04):** the bridge release was published
(`v1.1.0` on the predecessor, identical wheel), but it cannot complete the upgrade.
The predecessor is an internal repository. 1.0.x reaches its release API with a
token, then downloads the wheel from its `browser_download_url`, which returns 404 for
non-public repositories even when authenticated. The predecessor stays internal, so
1.0.x prefix installs migrate manually by reinstalling from the successor (see the
migration guide). The bridge release remains as a pointer to the successor.

Historical tags `v0.1.0a1` through `v1.0.1` exist in the successor as annotated tags on
parentless marker commits. Each contains a README naming the release, its date and
original commit, plus its changelog section. They keep version history and changelog
links coherent without publishing pre-export source.

Source: [docs/decisions/0049-repository-succession.md](https://github.com/jordanhubbard/literate-ai/blob/e797acdd6d8cf7254e38135f90b0421ad3ed4168/docs/decisions/0049-repository-succession.md) at commit `e797acdd`.
