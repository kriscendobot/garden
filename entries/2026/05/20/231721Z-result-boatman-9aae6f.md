---
ts: 2026-05-20T23:17:21Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/20/231218Z-dispatch-liaison-f97683.md
---

Ferried the spackle documentation port from `endojs/endo-but-for-bots#329` to `endojs/endo#3273` (https://github.com/endojs/endo/pull/3273), opened **non-draft**.

- Upstream PR: #3273, head SHA `1fb74152adab20855d20e6c54c158622f162724c`, base `master` at `bf951df346cfcf605a6709e6a5479f2fdd526113`. Branch: `kriskowal-spackle-docs`.
- Squash: cherry-picked `398eb22c`, `edb1b06f`, `a9624e71` with `--no-commit`, then a single `git commit -F`. Tree-identity check: `git diff a9624e71 HEAD -- docs/spackle.md` is empty (verbatim port); `git diff bf951df34 HEAD -- docs/spackle.md typedoc.json` equals `git diff 398eb22c^ a9624e71 -- docs/spackle.md typedoc.json` up to base-blob SHA header lines only (the `projectDocuments` insertion is identical). Trailer-strip clean (`git interpret-trailers --parse` empty).
- Attribution verified: `git log origin/master..HEAD --pretty=fuller` shows one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`. No `Co-Authored-By` survived the squash.
- Source-side cross-link: posted at https://github.com/endojs/endo-but-for-bots/pull/329#issuecomment-4503408258 (under kriskowal identity on the bots repo, which is the garden and a permitted comment target). Names upstream PR URL, head SHA, and confirms the 3->1 squash.
- Title: `docs: introduce spackle, the polyfill+ponyfill race pattern` (verbatim from source commit 1; already upstream-native).
- Body: composed per `skills/pr-formation/SKILL.md` using the endo PR template's section headings verbatim (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior-and-intent prose, no checklists, no file callouts beyond the load-bearing `typedoc.json` wiring, no fork-only references, no `kriscendobot/endo@8848cb052` mention.

Self-improvement: `git push origin HEAD:<branch>` failed with "not a full refname" because the upstream branch did not yet exist; the working form for a first push of a new branch is `git push origin HEAD:refs/heads/<branch>`. Worth a one-liner in `roles/boatman/AGENT.md` or `skills/pr-formation/SKILL.md` about the `refs/heads/` prefix on the initial push of a brand-new upstream branch.
