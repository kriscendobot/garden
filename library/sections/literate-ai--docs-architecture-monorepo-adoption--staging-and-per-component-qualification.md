---
title: Monorepo adoption: staging and per-Component retained qualification
source: docs/architecture/monorepo-adoption.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling, testing]
status: current
---

> Abstract: An internal staging adapter materializes source-free Component projections into a new external bundle whose completion manifest is published last; each Component's revision binds only its own owned files plus declared shared inputs, its retained harness runs in a disposable copy and yields a Component-bound receipt, and a bundle-wide check demands exactly one current receipt per Component, so shared changes requalify owner and consumers and private changes requalify only the affected Component.

The internal staging adapter materializes source-free Component projections into a new external bundle only after acknowledgement and exact plan revalidation. It does not move source, alter the source repository, or initialize a project. Projections start as `staged`, not at a conversion authority stage, and declare no generated product entrypoint. The completion manifest is published last; an interrupted or partially written bundle is not usable. Colliding destinations refuse. Failed staging removes only files still owned by that attempt, preserving concurrently replaced files.

Each Component has its own admitted command inventory and retained receipt policy. Its current revision binds the Component projection, the command/input declaration, and the raw bytes/executable bits of owned files plus declared shared inputs. It does not bind other Components' private source bytes or mutable receipts. Added or deleted files in the applicable owned/shared prefixes require scope refresh; unrelated additions do not invalidate this Component.

An explicitly acknowledged local run copies only the admitted files into a fresh disposable tree, preserving repository-relative paths. The strict retained harness executes the exact commands and requires positive, all-passing test counts with no source mutation. Evidence is Component-scoped retained execution, not native generation, independent semantic acceptance, conversion parity, or a project-wide release receipt. Source/descriptor drift during execution prevents publication. These are same-user local execution guarantees, not host containment.

Component evidence and its typed receipt are retained together in one new external file. Rechecking binds exact evidence, runner/policy, and the current Component revision; a copied receipt cannot be relabeled for another Component. Content digests are not signatures or proof against a hostile operator.

The internal bundle-wide check requires the caller's retained bundle identity and exactly one receipt for every selected Component. It reopens the complete manifest, reviewed plan, and planned projections, then checks all receipts against current source. Missing, extra, substituted, or stale receipts refuse, as does membership outside every selected boundary. Shared changes require new receipts for the owner and every consumer; private changes require only the affected Component to requalify. The result remains a read-only `staged` observation under original-source authority.

Refined conversion consumes this staging API as an internal pre-mutation gate. Installed custody remains at `retained-source` boundary-transfer state independently for each Component; it never marks a Component drafted or qualified and never retires retained source. `project retained-scope refresh` detects stale installed custody; its acknowledged apply additionally requires `--run-component-baselines`, rebuilds the reviewed bundle from the stored selection, reruns only stale Component harnesses, and reuses current receipts. Newly unowned source still refuses and requires a newly reviewed selection rather than inferred ownership.

Implementation: `adapters/monorepo_components.py` (`stage_monorepo_components`, `component_retained_revision`, `run_component_retained_harness`, `check_component_retained_receipt`, and `check_monorepo_retained_receipts`). These are internal integration APIs, not new CLI commands or a substitute for completing #365's adoption transaction.

Source: [docs/architecture/monorepo-adoption.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/monorepo-adoption.md) at commit `fcc40bc`.
