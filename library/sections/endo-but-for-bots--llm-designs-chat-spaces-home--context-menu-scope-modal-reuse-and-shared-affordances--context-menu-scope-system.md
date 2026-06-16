---
title: Context-menu scope system
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances
---

Menu items carry a `data-menu-scope` attribute that classifies them
along the indelible-vs-delible axis:

| Scope | Shown for |
|---|---|
| `"all"` | All spaces (indelible and delible) |
| `"delible"` | Only non-home spaces |

The runtime toggle:

```js
const isIndelible = spaceId === 'home';
for (const $item of $menu.querySelectorAll('[data-menu-scope]')) {
  const scope = $item.getAttribute('data-menu-scope');
  $item.style.display =
    (scope === 'all' || (!isIndelible && scope === 'delible'))
      ? '' : 'none';
}
```

Currently:

- **Edit Space** (`data-menu-scope="all"`) — shown for every space.
- **Delete Space** (`data-menu-scope="delible"`) — hidden for home.

The pattern generalizes: any future per-space action (Pin /
Duplicate / Mute / Rename) carries one of the two scope values and
the menu builder doesn't need to special-case the home id. This is
the **declarative scope** discipline applied to a context menu —
the data attribute is the *single point* where indelibility shapes
the surface, replacing what would otherwise be N conditional
branches.
