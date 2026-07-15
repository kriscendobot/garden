---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: a7d440
refs: [a7d440, 0e08d8]
project: endo
source_pr: endojs/endo-but-for-bots#259
upstream_pr: endojs/endo#3322
upstream_branch: kriskowal-hardened-text-codecs-shim
upstream_head: 2587b0f8cb19497368d513d30f67e791898a1ac1
---

Ferry of endo-but-for-bots#259 (`feat(ses): permit TextEncoder and
TextDecoder as universal intrinsics`) upstream complete. First-time ferry,
pr-handoff Shape 1.

- **Upstream PR**: <https://github.com/endojs/endo/pull/3322> — open,
  ready-for-review (not draft), base `master`, mergeable.
- **Upstream branch**: `kriskowal-hardened-text-codecs-shim`; head
  `2587b0f8cb19497368d513d30f67e791898a1ac1`.
- **Attribution/trailers**: all 3 commits (`488411b5e`, `57524d5e1`,
  `2587b0f8c`) show `Kris Kowal <kriskowal@kriskowal.com>` as author and
  committer; `interpret-trailers --parse` empty on every commit.
- **Upstream CI at report time**: pending (run just started); `zizmor` pass.
  Shepherd handles any CI follow-up.
- **Garden-side cross-link**: comment `4977431934` on #259 —
  `Mirror of https://github.com/endojs/endo/pull/3322 (head 2587b0f8c).`
  No upstream-side comment (per the 2026-05-29 directive).

The boatman's own detailed result entry is `0e08d8`
(`entries/2026/07/15/060733Z-result-boatman-0e08d8.md`).

Process note the boatman surfaced (single occurrence, below the
self-improvement threshold): the pr-handoff § Preconditions freshness-check
example `git ls-remote origin master` is ambiguous against sibling branches
like `changeset-release/master` and briefly produced a false "stale ref"
signal; disambiguating with `refs/heads/master` resolved it. No incorrect
push resulted. Left as a flag for a future gardener pass, not promoted.

Dispatch root `dispatches/boatman--a7d440` torn down on return.
