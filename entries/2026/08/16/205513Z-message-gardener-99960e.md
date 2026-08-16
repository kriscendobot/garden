---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-16T20:55:15Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1004 MERGE-NOW (merged)

project: endo-but-for-bots

`zizmorcore/zizmor-action` 0.5.3 → 0.6.2 (github-actions ecosystem; CI-only
static-analysis tool). Base `llm`, reviewed 2026-08-16T~20:00Z. **Verdict:
MERGE-NOW, executed** — merged as `902ca06c8a0e8346b1044661d952b90a9b5cee00`
at 2026-08-16T20:54:12Z.

- **Base census (step 1):** exactly one call site on base `llm`
  (`.github/workflows/zizmor.yml` @ `b1d7e1fb…` `# v0.5.3`); uniformly behind the
  target — a live upgrade, not a no-op/partial-revert. No sibling PR moves it
  (watcher preflight). Head `ahead=1 behind=0`.
- **Pin verification (tag→commit, both sides + transitive):** `v0.6.2` (lightweight)
  → `3dc1ecc9bcb9e94e9b2c709687979e1298497054` = the pin; `v0.5.3` →
  `b1d7e1fb5de872772f31590499237e7cce841e8e` = outgoing pin; transitive
  `github/codeql-action/upload-sarif` `v4.35.1`→`v4.37.1` (annotated, dereferenced)
  → `7188fc363630916deb702c7fdcf4e481b751f97a` = the pin. Owner `zizmorcore`
  correct. Resolved 2026-08-16.
- **Source read (v0.5.3…v0.6.2):** benign — `action.sh` adds a `--collect` passthrough
  and an explicit `docker pull` of the already-digest-pinned image; `action.yml`
  adds a `collect` input; `support/versions` appends digest-pinned zizmor images
  through 1.29.0 (default version 1.26.x→1.29.0). No new egress/fs-write/spawn/telemetry.
- **Advisories:** none against `zizmorcore/zizmor-action` (actions ecosystem + OSV).
- **Maturity:** floor = v0.6.2 publish `2026-08-01T21:21:25Z` (freshest moved) + 7d
  = `2026-08-08T21:21:25Z`, already past. No new-releaser signal.
- **CI:** shepherded to green, 25/25 checks `success` on the rebased head
  `c91e9da5`; no migration needed.

**Fleet defect surfaced:** the botanist auto-conduct bypass in
`scripts/jobs/gardening/ci-wait-merge.sh` compares the live PR author against the
default `GARDEN_DEPENDABOT_LOGIN=dependabot[bot]`, but `gh` 2.97.0 renders the
dependabot App author as `app/dependabot` via its GraphQL `--json author` path, so
the bypass is denied on every dependabot MERGE-NOW (the gate falls back to
maintainer approval and stalls). This merge required `GARDEN_DEPENDABOT_LOGIN=app/dependabot`
as a one-off override; a durable fix (accept both renderings) is being landed on main2.
