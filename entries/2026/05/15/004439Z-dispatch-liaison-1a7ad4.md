---
ts: 2026-05-15T00:44:39Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/000521Z-result-liaison-02ccd8.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: source
  - repo: endojs/endo
    pr: 3258
    role: target
---

Re-ferry `endojs/endo-but-for-bots#253` over `endojs/endo#3258`, replacing the existing SECURITY.md-only series with the broadened package-uniformity series. User explicitly asked for **title and description update** alongside the force-push.

Prior state of #3258: opened 2026-05-14T01:01 by an earlier boatman ferrying #228 (the original SECURITY.md uniformity work). Two commits authored by `Kris Kowal <kris@cixar.com>`:
- `0643069a chore: align SECURITY.md across all packages`
- `f4e6e8e6 ci(scripts): check-security-md.sh + lint-job step`

Per the maintainer directive recorded in #253's body ("we need to recreate it, based on master, and expand its scope") a fixer redrafted the work on the bot side as a general package-uniformity checker. Six logical commits on `endojs/endo-but-for-bots:chore/package-uniformity-master`:
- `29bc6af9 ci: enforce general package uniformity across workspace` (the script + CI step)
- `37a99c57 chore: align SECURITY.md across packages` (3 packages: hex, immutable-arraybuffer, panic)
- `12fc44c5 chore: add LICENSE to packages that were missing it` (5 packages)
- `08c19474 chore(packages): fix repository/bugs fields and document type exception` (4 packages + an EXCEPTIONS allowlist entry)
- `39038cfb chore(packages): fill in descriptions for ocapn and ocapn-noise` (2 packages)
- `d6a5df80 chore(packages): align .author on SES-heritage packages to 'Endo contributors'` (4 SES-heritage packages — the one *substantive* metadata change; user noted in the source body it can be reverted as a single commit if the maintainer prefers retaining `Agoric` as the author label there)

Authored as `endolinbot <main.barn5084@fastmail.com>`; the boatman rewrites attribution to Kris Kowal.

The source PR body's claim that "endo#3258 was closed unmerged" is **stale**: #3258 has never been closed (`gh pr view 3258 --json closedAt` returns null). The body was written by the bot fixer ~22:40Z 2026-05-14 and may have been authored against a momentarily-closed state, but the upstream PR is currently OPEN at head `f4e6e8e6`. This is fine — the re-ferry is a force-push that replaces the OPEN PR's commits, not a re-open.

**Source**: `endojs/endo-but-for-bots#253`, branch `chore/package-uniformity-master`, head `d6a5df80828d2c1d163d4061ac377efa02ec267a`. State OPEN (DRAFT), MERGEABLE. CI: 26 SUCCESS, 1 FAILURE (the macOS-15 flake). Base on `master` at `c2fc02eb8`.

**Upstream**: `endojs/endo#3258`, branch `chore/security-md-uniformity`, current head `f4e6e8e6bf4eec329d50e8233e874d098c7f1567` (open, REVIEW_REQUIRED, MERGEABLE). Current `origin/master` tip is `05823033d` (26 commits ahead of the source's base; no files in conflict per spot-check, but the broadened diff touches many `package.json` files and a few SECURITY.md / LICENSE files, so the boatman should rebase carefully).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry; standing pattern).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-package-uniformity-253--20260515-004425--1a7ad4/`. Project worktree on `endojs/endo:chore/security-md-uniformity` (detached at `2e41b378c` — a stale local ref from the earlier #228 ferry; the boatman fetches origin and works from `origin/master` rather than the stale ref).

**Boatman direction**:

- **Recompute from upstream master.** Cherry-pick the six source commits onto `origin/master`, rewriting author + committer to `Kris Kowal <kris@cixar.com>`. **Preserve the six commits as six.** The source split is deliberate (one logical change per commit), and the user-flagged "revertibility" of the SES-heritage author change works only if it stays its own commit. Do not squash.
- If conflicts arise during cherry-pick (likely on the 26-commit gap), resolve in favor of the source intent: the goal is to land the broadened check + the per-package alignment fixes. If a conflict is non-trivial (more than a comment-block reflow), pause and write a `message`-to-liaison rather than guessing.
- Force-push to `chore/security-md-uniformity`. The current 2 commits (Kris Kowal's) will be replaced.
- **Attribution discipline**: every commit must have `Author: Kris Kowal <kris@cixar.com>` and `Commit: Kris Kowal <kris@cixar.com>`. Source commits were authored by `endolinbot`; strip and rewrite. Verify with `git log origin/master..HEAD --pretty=fuller` and `git interpret-trailers --parse` (zero `Co-authored-by`, zero `Generated with Claude Code`, zero bot trailers).
- **Update upstream PR title and body.** Use `gh pr edit 3258 -R endojs/endo --title <new> --body <new>`. The new title should reflect the broadened scope (current upstream title is `ci: enforce uniform SECURITY.md across packages`; the broadened title might be `ci: enforce general package uniformity across packages` or similar — boatman picks a frame-for-upstream variant). The new body composes per `pr-formation`: endo template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior over diff, no checklists, no file callouts. **Drop fork-only references**: the source body's `Refs: endojs/endo#3258, endojs/endo-but-for-bots#228` is self-referential and bot-internal respectively; both come out. The maintainer-directive quote is bot-internal too; drop it (the substance — what's being enforced and why — survives in the Description and Compatibility sections).
- **Source-side cross-link comment** on `endojs/endo-but-for-bots#253`: post a brief comment (under whichever identity is authenticated on this host; the `endo-but-for-bots` standing authorization permits both) naming the upstream PR URL and head SHA. Liaison correction to the prior dispatches' framing: the prompt does **not** require "the bot identity" specifically; either kriskowal or kriscendobot is acceptable on the garden's own repo per the *Pre-staged authorizations* bulletin row.
- **Identity discipline**: no direct comments on `endojs/endo#3258`. If an explanatory comment is warranted on the upstream PR (e.g., naming the scope expansion and the revertibility of the SES-heritage author change), route via `message`-to-`steward`. The user has asked for the title+description update; that's an attribute edit, not a comment, and the boatman handles it directly under `identity_switch_authorized`.

**Expected report** (≤350 words): upstream PR head SHA after force-push (and the six commit SHAs in order), attribution-verified, source-side cross-link comment URL, new upstream title, one-line confirmation that the upstream body was rewritten per `pr-formation`, steward-message path if any, one-line `Self-improvement: ...`. If anything blocks (cherry-pick conflict that's not trivial, an unexpected upstream tip, etc.), `message`-to-liaison and stop without force-pushing.
