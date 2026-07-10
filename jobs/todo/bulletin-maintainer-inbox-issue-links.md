# Render issue/PR numbers as hyperlinks in the bulletin's maintainer inbox

**Garden's own repo** (`kriskowal/garden`, `main2`): build in an isolated worktree
off `origin/main2` and push directly — no PR (garden-infra convention). Precedent
for this exact area: `journal/jobs/tada/bulletin-message-links-or-body.md` (commit
`4fa4c29f`), which made the maintainer-inbox entries followable and added a test
SUBTEST; extend that work.

## The problem

The gh-pages bulletin's **maintainer inbox** ("Messages to the maintainer",
rendered by `compute_dashboard`'s `maint` loop in `scripts/jobs/bulletin.sh`, and
re-rendered client-side by `docs/bulletin/markdown.js`) shows each message body as
a blockquote. That body is full of GitHub **issue/PR references** — `#652`,
`endojs/endo-but-for-bots#650`, full issue/PR URLs — but they render as **dead
plain text**. The maintainer wants to click straight through to the issue/PR from
the inbox.

## What to do

Make issue/PR references in the maintainer-inbox entries render as **working
hyperlinks** on the **live gh-pages bulletin**:

- **`owner/repo#N`** (unambiguous) → link to `https://github.com/owner/repo/issues/N`
  (GitHub redirects issues↔pull for the right type, so `/issues/N` is fine).
- **Full GitHub issue/PR URLs** → ensure they render as links (not bare text).
- **Bare `#N`** → THE IMPORTANT NUANCE: a bare `#N` in a maintainer message almost
  always refers to the **project the sending gardener was working**, NOT the garden
  repo. Resolve the target repo from the message's originating doer — the `from:` /
  `reply_to:` frontmatter encodes it (e.g.
  `from: gardener:endojs-endo-but-for-bots-mount-...` → `endojs/endo-but-for-bots`;
  the `<owner>-<repo>` job-base convention and the bare clones under `worktrees/`
  are the mapping). Only link a bare `#N` to `kriskowal/garden` when the message's
  own context is the garden itself. **If the repo cannot be resolved with
  confidence, leave the bare `#N` as plain text** rather than mislink it — a wrong
  link is worse than none.

Pick the right layer: `bulletin.sh` is where the doer→project mapping is known, so
resolving bare `#N` almost certainly belongs there (emit proper Markdown links in
the rendered body); purely syntactic autolinking of `owner/repo#N` / URLs could
also live in `docs/bulletin/markdown.js`. Do not double-link. Do not let a
reference inside a fenced code block get rewritten (keep fences intact, as the
existing `msg_body_quote` is careful to).

## Verify (required — this renders on a live public surface)

- Add/extend a test assertion mirroring the existing SUBTEST in
  `scripts/jobs/test/run-test.sh`: a fixture maintainer message containing `#652`,
  `endojs/endo-but-for-bots#650`, and a bare `#N` whose repo resolves from the
  doer must render the correct links (and the unresolvable case must stay plain).
- Confirm on the **live bulletin**: commit + push to `origin/main2`, sync the
  changed file(s) into the deployed tree, restart `garden-bulletin.service`, and
  observe the reposted `journal2:README.md` (and, if you touched the client
  renderer, the gh-pages page) rendering the maintainer-inbox references as real
  hyperlinks pointing at the correct repos. Cite the observed result.
- `bash -n` / `shellcheck` clean on `bulletin.sh`; no regression to the existing
  blob-link + blockquoted-body rendering.

## Skills

- [self-improvement](../../skills/self-improvement/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md).

## Done

The maintainer inbox on the live gh-pages bulletin renders `owner/repo#N`, bare
`#N` (resolved to the originating project repo, or left plain when unresolvable),
and full issue/PR URLs as working hyperlinks — verified on the live bulletin and
by a test assertion, committed and pushed to `main2` with the bulletin service
reposting the change. The `tada` report gives the SHA, the file(s) touched, the
repo-resolution rule implemented, and the live-render observation.
