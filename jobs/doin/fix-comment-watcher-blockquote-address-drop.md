---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# comment-watcher drops a genuine @kriscendobot address when preceded by a quoted reply

Confirmed live on `endojs-endo-but-for-bots#1329`, comment
https://github.com/endojs/endo-but-for-bots/pull/1329#issuecomment-5785807820.
Its body:

```
> @kriscendobot Please run gauntlet.

@kriscendobot pardon. Please investigate how the stylist missed the db
initialism instead of recommending expanding the abbreviation to Database
```

Log evidence (`journalctl --user -u garden-comment-watcher@endojs-endo-but-for-bots.service`):

```
DROP (not-addressed): pr-comment cid=5785807820 on #1329 does not begin
exactly '@kriscendobot ' — not dispatching
```

`comment-watcher.sh`'s EXPLICIT ADDRESS gate (search
`DROP (not-addressed)` — around line 1823) requires
`@$GARDEN_BOT_LOGIN ` at byte zero of the comment body. This comment begins
with `> @kriscendobot Please run gauntlet.` — a markdown blockquote of the
PREVIOUS comment (the standard shape GitHub produces when you quote-reply,
or when a maintainer manually quotes prior context before responding) — so
byte zero is `>`, not `@`, and the ENTIRE comment is dropped, even though a
correctly-formed `@kriscendobot ...` address appears on the very next
paragraph with a genuine new request. The cursor slides past it as if it
were never addressed at all — no job, no reactji, no reply, silently.

This is NOT a case for loosening the gate to "the bot's name appears
anywhere" — the byte-zero requirement is a deliberate anti-false-positive/
anti-injection discipline (per the code's own comment: "A watched
conversation is not implicitly addressed to this bot") and must stay
strict against arbitrary content. The fix is narrower: **strip a leading
markdown blockquote before applying the byte-zero test**, the same
principled prefix-stripping the code already does for review bodies
(`sed -E 's/^(\[[A-Z_-]+\] )*//'` for source-owned state markers,
immediately above this gate). A markdown blockquote is a well-defined,
structurally-recognizable pattern — one or more consecutive lines starting
with `>` (optionally with GitHub's `\r\n` line endings), followed by a
blank line, then the real content — not arbitrary untrusted text able to
forge a fake address.

## Fix

Add a strip step (mirroring the existing review-body marker strip)  that
removes a leading blockquote block before the `case "$address_body" in
"@$GARDEN_BOT_LOGIN "*) ;; ...` test, for `pr-comment` and any other
surface where a human might quote-then-reply (not just `pr-review-body`,
which already has its own distinct strip for a different marker shape).
Preserve the strict byte-zero requirement on whatever remains after
stripping — do not weaken it further than "skip a genuine leading
blockquote block."

## Verify

A real regression test: a comment shaped exactly like the one above (a
blockquoted prior comment, blank line, then a real `@kriscendobot ...`
address) must now DISPATCH, not drop. Also test the negative case is
unchanged: a comment that merely mentions "@kriscendobot" somewhere in
running prose without a blockquote-then-address shape must still DROP.

Given this gate is deliberately conservative, audit (don't just fix the one
observed shape) whether other common GitHub UI patterns similarly defeat
the byte-zero check — e.g. leading whitespace, a leading blank line before
the address, multiple paragraphs of blockquote from a multi-comment
thread-quote — and address what you find, or explicitly note what you
checked and ruled out.

## Report

Confirm other recently-DROPped comments across the watched repos weren't
silently missed for this same reason — grep recent
`DROP (not-addressed)` log lines (or the self-heal capture equivalent) for
any starting with `>` and flag any that look like a genuine missed
directive, not just this one instance.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T23:51:51Z
