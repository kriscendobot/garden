---
title: Keyboard shortcut handler
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future
---

```js
document.addEventListener('keydown', e => {
  if (!e.metaKey && !e.ctrlKey) return;
  if (e.shiftKey || e.altKey) return;

  const num = parseInt(e.key, 10);
  if (num >= 1 && num <= 9) {
    const sortedSpaces = [...spaces].sort((a, b) => a.order - b.order);
    if (num - 1 < sortedSpaces.length) {
      e.preventDefault();
      selectSpace(sortedSpaces[num - 1].id);
    }
  }
});
```

Two design notes:

1. **Cmd-vs-Ctrl across platforms** is handled by accepting either
   (`e.metaKey || e.ctrlKey`); the platform-appropriate-modifier-key
   principle from
   [[endo-but-for-bots--llm-designs-chat-invariants--principles]]
   applies to the *display* layer (`⌘Enter` vs `Ctrl+Enter`), not
   to the *handler* layer, which accepts both.
2. **Shift / Alt explicitly excluded** — these slots are reserved
   for future per-space actions (`Shift+Cmd+N` might mean "rename
   space N"). Defending the namespace by explicit exclusion is the
   discipline that preserves the modeline-completeness invariant:
   no modifier-combination silently does something unexpected.
