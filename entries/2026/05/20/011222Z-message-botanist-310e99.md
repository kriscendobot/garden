---
ts: 2026-05-20T01:12:22Z
kind: message
role: botanist
repo: endojs/endo
project: endo
to: "*"
refs:
  - entries/2026/05/20/011222Z-result-botanist-e97188.md
  - entries/2026/05/13/000050Z-message-steward-e08492.md
---

# Dependabotany ledger row: endojs/endo#3267

First row for the `endojs/endo` project's dependabotany ledger. Future
botanist dispatches against this repo append their rows under the same
`project: endo` tag; the steward's per-cycle scan greps
`grep -rl '^project: endo$' journal/entries/ | xargs grep -l '^# Dependabotany'`
to recover the cumulative posture and re-dispatch on maturity dates.

The format mirrors `endojs/endo-but-for-bots/process/dependabotany.md`
(mirrored verbatim into this journal at
`entries/2026/05/13/000050Z-message-steward-e08492.md`).

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [3267](https://github.com/endojs/endo/pull/3267) | `actions/cache` 4.3.0 → 5.0.5 | MERGE-NOW | n/a | OPEN | GH Actions bump. Two `uses:` pins in `ci.yml` (XS binary cache, `test-xs` job) and `ocapn-guile-interop.yml` (Guix tarball cache). v5.0.0 was the node20 → node24 runtime cutover (Actions Runner floor 2.327.1, only affects self-hosted; endo uses GitHub-hosted `ubuntu-latest` / `macos-15` exclusively). v5.0.5's only delta over v4.3.0 plus inherited fixes is `actions/cache#1747` (ts-http-runtime 0.3.5: stops request headers being forwarded as additional headers during HTTPS CONNECT tunnel establishment). `action.yml` byte-identical except `using:` line; every consumed input unchanged. 37 days mature at verdict (published 2026-04-13). CI 28/28 green including the `zizmor` workflow-security audit and `check-action-pins`. Zero GHSA hits against `@actions/cache`. Posting the verdict comment and merging require maintainer or downstream-authorized dispatch action (bot lacks `workflow` scope for GH-Actions bumps). |

## Botanist self-notes for this project

Carried over from the `endo-but-for-bots` ledger; reaffirmed by this
engagement:

- **Diff `action.yml` between tags via `gh api`, not just release
  notes.** Worked again here: v4.3.0 vs. v5.0.5 was byte-identical
  modulo the `using:` line, which shrunk the source-read substantially.
- **Quote `gh api` paths with `?ref=...`.** Bit me on the first try
  (zsh glob expansion); single-quoting the URL fixed it.
- **Runtime-floor check for GH Actions bumps.** New: v5 of
  `actions/cache` declares a minimum Actions Runner version. The floor
  only bites self-hosted runners, but the botanist should
  affirmatively verify the project has no `self-hosted` jobs before
  granting MERGE-NOW. Recipe: `grep -n 'runs-on\|self-hosted'
  .github/workflows/*.yml`. For endo as of 2026-05-20, every job runs
  on `ubuntu-latest` or `macos-15`; the project has no self-hosted
  runners.
- **Authorization shape for endo Dependabot PRs.** Same as
  `endo-but-for-bots`: posting the verdict comment and any
  `gh pr merge` / `gh pr close` action requires an explicit per-action
  authorization the steward forwards; the bot account does not have
  `workflow` scope, so even a MERGE-NOW row waits on a human
  (kriskowal) merge unless the authorization chain explicitly stages
  a conductor dispatch with the right credentials.

## Scheduled engagements

| Date | Action | Trigger |
|---|---|---|
| (none yet) | | |

No embargo date on this verdict, so the steward's per-cycle scan has
no due re-dispatch.
