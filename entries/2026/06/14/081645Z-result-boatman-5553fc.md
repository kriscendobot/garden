---
ts: 2026-06-14T08:16:45Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/14/081236Z-dispatch-liaison-fd70dd.md
---

Shape-3 fast-forward append onto endojs/endo#3300 (branch `kriskowal-shellcheck-ci`). Appended the one fold-in commit from endo-but-for-bots#401 (`2ee513b4be9b470f050f0c598bc0dbf58593ac45`, `chore(shellcheck): fold shellcheck into the CI lint job`, by endolinbot) onto the prior upstream head `32d76f46b30085bd8fc1a0018a9bb63998cce392`.

- New #3300 head: `89a46187c76bbeda9f8a063b401a13c56cdd0dea` (short `89a46187c`).
- Fast-forward confirmed: remote response `32d76f46b..89a46187c`, no leading `+`. Pre-flight `merge-base --is-ancestor origin/kriskowal-shellcheck-ci HEAD` passed (remote tip was still `32d76f46b`). Cherry-pick was clean (parent blobs matched, as the dispatch predicted).
- Attribution: author AND committer `Kris Kowal <kriskowal@kriskowal.com>`. `interpret-trailers --parse` EMPTY. Body cleaned of the fork-side reference line (`Per kriskowal's directive on PR #401 (issuecomment-...)`); technical explanation retained. (Note: an initial inline-heredoc amend mangled backticks via shell escaping; corrected by re-amending from a `-F` message file. The trailer gate and final body were both re-verified after the fix.)
- Scope (2 files): `.github/workflows/ci.yml` modified (+9), `.github/workflows/shellcheck.yml` deleted (-44).
- Post-push: 4 commits, MERGEABLE, reviewDecision APPROVED. gibson042's APPROVED review persists (a fast-forward append never dismisses; the review is anchored to the still-reachable `32d76f46b`). turadg + kriskowal COMMENTED reviews also intact.
- CI: freshly triggered for the new head (run set 27492987067, all 16 checks pending at report time; lint job now carries the shellcheck steps). Did not wait.
- Cross-link: edited endo-but-for-bots#401 comment id `4645026707` in place to `Mirror of https://github.com/endojs/endo/pull/3300 (head 89a46187c).` No upstream-side comment; no `message: boatman → steward`.
- Host preconditions: `gh auth status` showed `kriskowal` active; `gh api repos/endojs/endo --jq .permissions` showed `push: true` / `admin: true`. Re-confirmed kriskowal active immediately before the push.

Self-improvement: a near-miss worth noting but below the threshold for a skill edit. Building a multi-paragraph commit body with backtick-quoted code spans inside a single-quoted inline `-m '...'` shell argument is fragile: the `'\''` escaping for the embedded apostrophes left literal `\` artifacts adjacent to backticks. The robust pattern (already implied by pr-handoff's `--amend -m '<subject>' -m '<body>'` examples, but worth making explicit) is to write any non-trivial body to a temp file and use `commit --amend -F <file>`. I corrected in-flight and re-ran the trailer gate, so nothing shipped wrong; not landing a skill change for a one-line operator-technique note. Message-to-liaison not warranted.
