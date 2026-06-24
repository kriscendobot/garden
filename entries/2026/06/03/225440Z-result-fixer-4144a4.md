---
ts: 2026-06-03T22:54:40Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/03/225145Z-dispatch-liaison-4144a4.md
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3352371885
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3352382552
---

# result: fixer 4144a4 — #394 SHA-256 throughout (reverse spike SHA-1 framing)

## Delivered

- New head SHA: `fb8ec34e3` on
  `endojs/endo-but-for-bots:design/gateway-package-phase-6`
  (regular append on top of the prior spike-application commit
  `0acea588b`).
- One commit:
  `docs(gateway): use SHA-256 Git variant per kriskowal preference (revert spike SHA-1 framing)`.
- Inline-thread reply posted on `discussion_r3352371885`; reply
  id `3352382552`.

## Old to new text summary

The Feature 3 daemon-side-scope **Content key** paragraph
(`designs/gateway-package.md`, near line 600 in the prior head):

Old (from `0acea588b`):

> Endo's content identity is **sha256** (locked); git's internal
> object database runs in its **default SHA-1 object format**
> behind a persistent `sha256 -> git-oid` index, per the spike's
> Open Question 2 recommendation that the maintainer ratified.
> This decouples the locked decision (sha256 identity for every
> Endo formula, `cas-*` verb, and cross-peer reference) from the
> immature one (git's experimental SHA-256 object mode, whose
> library coverage trails its SHA-1 coverage, including in the
> ratified `git2` crate). A later transparent adoption of git's
> SHA-256 object format remains possible because the Endo-facing
> key never changes.

New (in `fb8ec34e3`):

> Endo's content identity is **sha256** (locked), and git's
> internal object database runs in git's **SHA-256 object
> format** so that the git-oid is the sha256 of the object
> exactly as Endo names it. The maintainer's standing preference
> is to avoid SHA-1 in this project on the grounds that it is a
> compromised hash (kriskowal on PR #394, 2026-06-03, restating
> the original verbatim directive: "Let's also make sure we use
> the sha256 Git variant and avoid the sha1 version"). That
> preference governs Feature 3's content-key choice here,
> superseding the spike's earlier Open Question 2 framing that
> proposed retaining SHA-1 internally with a `sha256 -> git-oid`
> side index. Endo's sha256 identity stays locked across every
> Endo formula, `cas-*` verb, and cross-peer reference; git's
> object database underneath is also SHA-256, so no translation
> table sits on the hot path.
>
> The libgit2 implementation reality is that SHA-256 repository
> support shipped behind the build-time `experimental.sha256`
> feature flag and the runtime `GIT_OBJECT_FORMAT=sha256`
> option, matching git's own experimental rollout. Adopting it
> on the daemon side requires building libgit2 with the feature
> enabled and pinning a version whose SHA-256 paths cover the
> operations the daemon uses (object read and write, ref update,
> pack-file ingest, the in-process reachability sweep). If a
> specific operation in the chosen libgit2 version turns out to
> be SHA-1-only, the daemon-side spike (PR #369) is the place
> to record the gap and choose between waiting for upstream
> libgit2 coverage, contributing the missing path, or falling
> back to a pure-Rust SHA-256-capable git implementation
> (gitoxide's SHA-256 work is the obvious fallback if `git2`
> cannot cover the surface in time). The gateway-side wire
> shape is unaffected either way: pack-file bytes ride the
> smart-HTTP carrier in whichever object format the daemon
> publishes.

Net effect: replaces the spike's SHA-1-with-index framing with
SHA-256 throughout, names the maintainer's compromised-hash
reasoning and the original verbatim directive, and acknowledges
the libgit2 implementation reality as an open implementation
choice deferred to PR #369 rather than pretending no friction
exists.

Also bumped the document's `Updated` metadata from `2026-05-29`
to `2026-06-02` (drift the prior spike-application commit had
not caught; the `designs/README.md` row already read 2026-06-02
so this realigns the two).

## Inline-thread reply

- Thread: `discussion_r3352371885`
  (kriskowal in reply to 0xpatrickdev's `r3351927403`).
- Reply id: `3352382552`.
- Body summary: acknowledged the directive; cited the new SHA;
  named the libgit2 reality (build-time `experimental.sha256`,
  runtime `GIT_OBJECT_FORMAT=sha256`); named PR #369 as the
  venue for any operation-level SHA-1-only gap and the gitoxide
  fallback option; noted #369 itself is untouched.

## Judgment calls

1. **libgit2 SHA-256 framing.** The dispatch brief asked me to
   verify the libgit2 reality and choose a graceful framing.
   libgit2's SHA-256 repository format support is real but
   gated by the `experimental.sha256` build option and the
   `GIT_OBJECT_FORMAT=sha256` runtime flag, mirroring git's own
   experimental rollout. I wrote it as a known-real
   implementation surface with a named pin requirement
   (version whose SHA-256 paths cover the operations the daemon
   uses) rather than asserting parity with SHA-1, and named
   gitoxide as the fallback if a specific surface turns out
   to be uncovered. This honors kriskowal's preference (SHA-256
   throughout the design) while not papering over the
   implementation friction the spike fixer had used to justify
   the SHA-1 framing. The escape hatch sits on PR #369 (the
   spike), not on the gateway design.
2. **Did not amend PR #369.** Per the brief's "Not authorized"
   list, the spike's own Open Question 2 framing in
   `designs/daemon-git-backbone.md` is left as-is. The gateway
   design's new text names the supersession explicitly
   ("superseding the spike's earlier Open Question 2 framing")
   so a future reader following the cross-reference from the
   spike lands on the correct local resolution without
   needing the spike itself to be amended.
3. **Cited the original verbatim directive.** The new text
   embeds kriskowal's exact words ("Let's also make sure we
   use the sha256 Git variant and avoid the sha1 version") and
   names the 2026-06-03 reaffirmation. This is the durable
   anchor for the reversal so future readers do not re-litigate
   the choice without seeing the maintainer's framing.
4. **Updated the `Updated` metadata.** The prior commit shipped
   without bumping the document's table, leaving it at
   `2026-05-29` while the `designs/README.md` row read
   `2026-06-02`. I realigned both to today so the cross-document
   sync rule in `designs/CLAUDE.md` holds.
5. **Did not re-request review.** The dispatch is a maintainer-
   reply, not a `CHANGES_REQUESTED` review. The fixer norm
   "re-request review after a substantive fix" applies to formal
   reviews; an inline reply on a single thread does not require
   a re-request, and the brief did not authorize one. The
   maintainer will pick up the reply via standard PR notifications.

## Pre-push gates

Markdown-only diff in `designs/gateway-package.md`. No code,
lint, or test gates applicable. Em-dash style and Latin
shorthand norms applied to the new prose (verified by grep on
the additions). Sentence-per-line and line-wrap (under 72 cols)
applied to the new paragraphs.

## Self-improvement

Nothing this time. The dispatch was a clean reversal of a prior
fixer's framing, with the brief naming the cited verbatim and
the libgit2 acknowledgment as the only judgment surface; no
role or skill gap surfaced.
