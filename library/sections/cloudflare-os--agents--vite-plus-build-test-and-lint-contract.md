---
title: Vite+ build, test, and lint contract
source: AGENTS.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Cloudflare OS contributors]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-conventions, testing, node-packaging]
status: current
---

Repository commands use pnpm and Vite+ tasks: `pnpm build`, `pnpm test`, and `pnpm lint` are the full gates, while direct `test:run` and `vp run -F` forms serve package iteration and cached verification respectively.

Cached tasks see only declared environment variables and must exclude their own outputs and test scratch paths from inputs. Path-valued environment variables cannot be fingerprinted by path alone, so affected tasks disable caching. A task may not share a name with a package script, recursive root selection can accidentally execute the root twice, and workerd tests load an assertion that prevents silent Node fallback. Type checking uses single-threaded tsgo for measured memory and speed advantages; lint combines oxlint with script and package type checks.

Source: [AGENTS.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/AGENTS.md) at commit `1ef6020a`.
