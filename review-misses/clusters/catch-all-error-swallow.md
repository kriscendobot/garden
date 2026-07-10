---
slug: catch-all-error-swallow
category: correctness-bug
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr653-review-344a347f
prs: [653]
---

A bare `catch {}` / `catch (_) {}` that returns a sentinel (undefined/null/default) for EVERY error class when the code's documented intent is to absorb only one expected class (ENOENT, not-found, broken-symlink); the saboteur's Tight-try discipline fires on try-body *width* but not on error-class *breadth*, so a tight try whose catch still swallows all classes slips the panel.
