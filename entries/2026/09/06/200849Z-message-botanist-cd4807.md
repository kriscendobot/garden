---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-06T20:08:51Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1169

# Dependabotany ledger: endojs/endo-but-for-bots PR #1169 terminal MERGE-NOW

## Verdict: MERGE-NOW, executed

Reviewed head `024fd8c3c039b2110c279a65f4303dcd827be5ed` and merged it into
`llm` as `9905e8fe8ae23fff9a0123ffa83d0bd698993aaf` at
2026-09-06T20:07:27Z. The structured verdict is recorded at
https://github.com/endojs/endo-but-for-bots/pull/1169#issuecomment-5561844432.

The base-ref census found the sole `softprops/action-gh-release` use still at
3.0.2, so the 3.0.3 bump was live. Both annotated tags dereferenced to their
pinned commits on 2026-09-06: v3.0.2 to `3d0d9888cb7fd7b750713d6e236d1fcb99157228`
and v3.0.3 to `efb35369e0ad2afab669f228072c1b0d510eae64`. v3.0.3 was
published 2026-08-30T00:30:08Z and its 2026-09-06T00:30:08Z maturity floor had
passed.

The source review found defensive malformed-GitHub-error parsing plus dependency
security updates, with no new install hook, network destination, filesystem
write, dynamic module load, process spawn, telemetry, or license concern. The
incoming production moves were `@octokit/plugin-retry@8.1.1`,
`@octokit/plugin-throttling@11.0.5`, `@octokit/request-error@7.1.1`, nested
`@octokit/openapi-types@28.0.0` and `@octokit/types@17.0.0`,
`brace-expansion@5.0.9`, and `undici@6.28.0`. OSV returned no finding for any
incoming move or either headline version; the GitHub Actions advisory feed was
also clean. Scripts-disabled npm audit found zero incoming findings, versus ten
GHSA findings across brace-expansion, nanoid, postcss, and undici in the outgoing
upstream tree. Thus the upgrade removes the outgoing audit exposure.

Project provisioning built the scripts-disabled warm cache. All 25 GitHub check
runs completed successfully on the reviewed head, including check-action-pins
and zizmor. The scripts-disabled upstream install also audited clean. The local
upstream Vitest run was not verified because the host uses unsupported Node 22
and could not load the Node-24 rolldown binding.

This is a terminal row. No embargo or recheck schedule applies.

Self-improvement: nothing this time.
