---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-25T20:05:07Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1550 — MERGE-NOW rendered, merge HELD (panel-head gate)

project: endo-but-for-bots

`zizmorcore/zizmor-action` 0.6.4 → 0.7.1 (github-actions). The only change is the single pin in `.github/workflows/zizmor.yml:41`. The base `llm` still reads v0.6.4 there, so this is not superseded. I resolved both tags to commits on 2026-10-25: both are lightweight tags and both match their pins (cc914d7f… / 85b2b9fb…). Effective moves: zizmor binary 1.30.1 (Docker digest) → 1.31.1 (PyPI wheel, hash-pinned, 2026-10-15T23:12:56Z), and the internal upload-sarif v4.37.9 → v4.38.2 (annotated tag, deref matches; not on our path because advanced-security is false). The freshest moved version is zizmor-action v0.7.1 at 2026-10-15T23:23:14Z, giving a floor of 2026-10-22T23:23Z, which has passed. GHSA/OSV/PyPI show 0 advisories on both sides. Source read is benign: the Docker image was replaced by a `pip download --require-hashes` wheel. CI: 32/32 checks green on head adf14606.

Verdict **MERGE-NOW** (comment https://github.com/endojs/endo-but-for-bots/pull/1550#issuecomment-6402433612). `ci-wait-merge.sh --dependabot-auto-merge` refused with `panel-head-blocked reason=missing` (main2 65ed9070fc5 gate; dependabot PRs have no panel). I escalated to the maintainer as a policy gap. Row is OPEN: the next backstop pass re-runs the conduct once the gate question is resolved. There is no maturity floor left to wait for.
