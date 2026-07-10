# Forbid partially-qualified issue/PR references in posted messages (upstream fix)

**Garden's own repo** (`kriskowal/garden`, `main2`): build in an isolated worktree
off `origin/main2` and push directly — no PR (garden-infra convention).

## Why (the upstream framing)

The garden just shipped a *downstream* fix (`bulletin-maintainer-inbox-issue-links`,
commits `4858ade79`/`88dd7d5ea`) that hyperlinks issue/PR references in the bulletin
and heuristically resolves a **bare `#N`** to the sending gardener's project repo.
The maintainer's directive (2026-07-10): **fix it at the source instead** — make
message-posting require **fully-qualified** issue/PR references, enforced by a
**deterministic, Markdown-aware check that reports and forbids** apparently
partially-qualified references. Then a bare `#N` never enters the bus in the first
place, and rendering it is unambiguous everywhere. (The bulletin's bare-`#N`
resolver stays as a harmless fallback for legacy/pre-existing messages; do not
remove it.)

## What to build

### 1. A deterministic checker (shell, no LLM)

A single shared checker — a new `scripts/jobs/check-issue-refs.sh` (or a function in
`scripts/jobs/common.sh`) — that scans a **message body** and **reports + fails**
(nonzero exit) when it finds an **apparently partially-qualified** GitHub issue/PR
reference.

- **Forbidden (partial):** a bare `#<number>` issue/PR reference — a `#` immediately
  followed by digits, at a word boundary, that is **not** part of a fully-qualified
  form. Consider other clearly-partial forms the corpus uses (e.g. `owner#N` with no
  repo, `GH-N`) and forbid what is genuinely ambiguous; keep the rule tight and
  documented.
- **Allowed (fully-qualified):** `owner/repo#N`, and full
  `https://github.com/owner/repo/(issues|pull)/N` URLs. These resolve without
  context, so they pass.
- **Markdown-aware exemptions (do NOT flag references inside):**
  - **fenced code blocks** (```` ``` ```` and `~~~`, including indented/info-string
    fences) — the maintainer named this explicitly; and
  - **inline code spans** (`` `...` ``) — the SAME false-positive class the bulletin
    fix had to handle (e.g. `` `rebase #652` `` and `` `run the gauntlet #N` `` are
    vocabulary/command examples, not references). Skipping fences but not inline
    spans would still misfire.
  - Also avoid obvious non-references: a Markdown ATX heading marker (`#` / `##`
    followed by a space) is not a `#N` ref; watch the `#RRGGBB` hex-color
    false-positive (prefer the code-span exemption to cover it, and require the ref
    to look issue-shaped — `#` + 1–6 digits at a boundary — rather than any `#`+hex).
- **Report clearly:** on failure, print each offending reference with its line and a
  one-line remedy — "fully-qualify as `owner/repo#N` or a full issue/PR URL" — so the
  sender can fix and retry. The check is the gate; the message is *not* posted until
  it passes.

### 2. Wire it into every message-send primitive

Call the checker on the body **before the push** in each posting path so enforcement
is uniform:
`scripts/jobs/message-user.sh`, `scripts/jobs/send-msg.sh`,
`scripts/jobs/inbox-send.sh`, and `scripts/jobs/maintainer-reply.sh` (and any other
primitive that posts an author-written body — audit `scripts/jobs/` for callers).
Frontmatter is not a message body; check the body only.

### 3. Document the convention in the skill

Update `skills/message-bus/SKILL.md` (the posting playbook) to state the rule:
issue/PR references in message bodies must be fully-qualified (`owner/repo#N` or a
full URL); bare `#N` is rejected by the deterministic check; code fences and inline
code spans are exempt. Keep it a short, procedural note where senders will see it.

## Verify

- Add a test to `scripts/jobs/test/run-test.sh` (or the nearest harness) asserting:
  a body with bare `#652` is **rejected** with a report; `owner/repo#N` and a full
  URL **pass**; a bare `#N` inside a fenced block **passes**; a bare `#N` inside an
  inline code span **passes**; an ATX heading line is not flagged.
- `bash -n` + `shellcheck -S warning` clean on every file touched.
- Exercise the real path: attempt an actual `message-user.sh`/`send-msg.sh` post
  with a bare `#N` and observe the rejection + report, then a fully-qualified post
  and observe success. Cite the observed output.
- **Note the pre-existing SUBTEST 6 failure** the bulletin job reported
  (`maintainer-reply … has no reply_to`, reproduces on pristine baseline) — do not
  let it mask your new test; if it blocks the suite, run your assertion in a focused
  harness and say so.

## Skills

- [self-improvement](../../skills/self-improvement/SKILL.md),
  [message-bus](../../skills/message-bus/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md).

## Done

Every author-written message-send primitive rejects a body containing an apparently
partially-qualified issue/PR reference, with a clear report and remedy, while
fully-qualified refs and refs inside code fences / inline code spans pass — the rule
documented in `skills/message-bus/SKILL.md` and covered by a test. Committed and
pushed to `main2`. The `tada` report gives the SHA, the files touched, the exact
forbidden/allowed rule implemented, the list of send primitives wired, and the
real-path rejection/acceptance observation.
