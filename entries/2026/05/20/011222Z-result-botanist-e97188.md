---
ts: 2026-05-20T01:12:22Z
kind: result
role: botanist
repo: endojs/endo
project: endo
---

# Verdict on endojs/endo#3267: MERGE-NOW

Dependabot bump `actions/cache` 4.3.0 → 5.0.5 (two SHA pins in two workflow files).

**Verdict: MERGE-NOW.**

**Headline.** `chore: bump actions/cache from 4.3.0 to 5.0.5`. Two-line diff, both `uses:` lines re-pinned by SHA with the version moved from `# v4` / `# v4.3.0` to `# v5.0.5`. No source files touched.

**Workflows affected.** Two files, two call sites:
- `.github/workflows/ci.yml` (line 415 area): `Restore XS binary cache` step inside the `test-xs` matrix job; runs on `ubuntu-latest`.
- `.github/workflows/ocapn-guile-interop.yml` (line 92 area): `Restore Guix tarball cache` step; runs on `ubuntu-latest`.

**Runtime-floor check.** v5.0.0 (2025-12-11) cut `using:` from `node20` to `node24` and declares a minimum Actions Runner version of `2.327.1`. The floor only bites self-hosted runners. Both call sites run exclusively on GitHub-hosted runners (`ubuntu-latest` and, elsewhere in `ci.yml`, `macos-15`); the project has no `self-hosted` jobs (grep confirms). GitHub-hosted runners are continuously updated and are already past 2.327.1. The PR's own CI exercised both workflows successfully under v5.0.5.

**Source read.** Compared `action.yml` at `v4.3.0` vs. `v5.0.5` via `gh api 'repos/actions/cache/contents/action.yml?ref=<tag>'`: byte-identical except `using: 'node20'` → `using: 'node24'`. Every consumed `inputs:` key (`path`, `key`, `restore-keys`, `enableCrossOsArchive`, `fail-on-cache-miss`, `lookup-only`, `save-always`, `upload-chunk-size`) and the single `outputs:` key (`cache-hit`) is unchanged. v5.0.5's only delta over v5.0.4 is actions/cache#1747 (yacaovsnc, merged 2026-04-13): a `@typespec/ts-http-runtime` bump to 0.3.5 that stops request headers from being forwarded to proxy servers as additional headers during HTTPS CONNECT tunnel establishment. No new network calls, no new filesystem writes, no new `child_process` spawn, no telemetry. Authored by a legitimate maintainer.

**CVE/GHSA check.** GitHub Advisory Database query against `ecosystem: NPM, package: "@actions/cache"` returns zero advisories. No open issues on `actions/cache` mention v5.0.5 as broken. Intervening v5.0.1-v5.0.4 release notes carry security-relevant transitive bumps (`minimatch` ReDoS, `undici` WebSocket decompression bomb, `fast-xml-parser`, an `@actions/cache` SAS-token-obfuscation fix); v5.0.5 inherits all of those plus the CONNECT-header fix. Upgrade is net safer than v4.3.0.

**CI status.** 28/28 checks green at PR HEAD: full Node 18/20/22/24 × ubuntu/macos matrix, coverage runs, test262, hermes, async-hooks, OCapN Guile interop, OCapN Python, XS (the workflow the bumped action actually runs in), `viable-release`, `check-action-pins`, the `zizmor` workflow-security audit, lint, build, browser tests. Browser-tests workflow has its own greens and is unaffected.

**Upstream publish date of v5.0.5: 2026-04-13T15:57:52Z.**

**Embargo math.** Maturity floor is 7 days; v5.0.5 is 37 days mature (2026-04-13 → 2026-05-20). MERGE-NOW satisfied: ≥7 days old AND CI green AND source read surfaced nothing malicious AND transitive set is benign.

Verdict ledger row landed as a companion `message` entry. The maintainer or an authorized downstream dispatch posts the PR comment.

Self-improvement: nothing this time; the v4.3.0→v5.0.5 single-major bump was a textbook GH-Actions case and the prior `endojs/endo-but-for-bots` ledger's "diff `action.yml` between tags" note carried straight over.
