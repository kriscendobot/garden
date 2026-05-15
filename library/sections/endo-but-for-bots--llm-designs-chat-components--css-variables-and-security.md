---
title: CSS theme tokens and security considerations
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, capability-security]
status: current
---

## CSS custom-property theme tokens

The UI uses CSS custom properties as the single source of truth for
visual theming:

| Token | Purpose |
|---|---|
| `--accent-primary` | Primary action color |
| `--accent-light` | Light accent for backgrounds |
| `--text-primary`, `--text-muted` | Text colors |
| `--bg-primary`, `--bg-secondary` | Background colors |
| `--border-color`, `--border-light` | Border colors |
| `--radius-sm`, `--radius-md`, `--radius-lg` | Border radii |
| `--shadow-sm`, `--shadow-md`, `--shadow-lg` | Box shadows |
| `--transition-fast` | Animation timing |
| `--sidebar-width` | Inventory panel width (resizable) |

The token-table-as-design-system pattern is the chat-UI version of
the producer-typed-shape-consumer-rendering discipline applied to
CSS — components author against tokens; the theme (or per-space
color scheme; see `scheme-picker.js`) supplies the values. The
sibling `chat-per-space-color-scheme.md` design is where the per-
space theme variations live and is not yet ingested.

The `--sidebar-width` token being resizable is the only token here
that is *user-visible-state* rather than pure theme — it persists
the user's sidebar choice.

## Security considerations

The design lists seven security claims; six are structural, one is
flagged as currently-relying-on-user-review:

| # | Claim | Status |
|---|---|---|
| 1 | Monaco editor runs in a **sandboxed iframe** | Structural |
| 2 | All pet-name references are resolved through daemon APIs | Structural |
| 3 | No direct file-system access from UI | Structural |
| 4 | WebSocket connection authenticated via daemon | Structural |
| 5 | Eval proposals require **explicit grant from host** | Structural — the eval-proposal action button is the consent surface |
| 6 | Guest `evaluate` mirrors Host `evaluate`, gated by host approval flow | Structural |
| 7 | Counter-proposal messages may include endowments the guest should not accept | **Workflow-only** — *"the current workflow relies on user review; consider revisiting this design if it proves risky"* |

The Monaco sandbox is the only place the chat client steps outside
the SES + harden discipline that the rest of the package follows —
Monaco is too large to ship under SES and runs in an iframe so its
escape from SES is structurally contained.

Claim #5 (eval proposals require explicit grant) is the chat-UI
manifestation of the daemon's **structural confinement over policy**
discipline. The Grant button is the *delegation surface* for the
informed-consent pattern at the agent boundary — the user reads the
proposed source + endowments, then decides.

Claim #7 is the only **soft** item — the design explicitly notes
that counter-proposals can carry endowments the recipient should not
accept, and that the safety relies on user attention rather than a
structural guard. The TODO is left in the design for a future
revision.

## Cross-references

- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the modeline-completeness and keyboard-manual-parity invariants are surfaced by the components named here (chat-bar, inventory, inbox).
- [[endo-but-for-bots--llm-designs-chat-invariants--principles]] — the visual-feedback and contextual-autocomplete principles are realized by `value-render.js`, `time-formatters.js`, `icon-selector.js`, and the three autocomplete components.
- [[delegates-and-epithets]] — the eval-proposal Grant flow is a worked example of *informed consent at the delegation boundary*; epithet-style claims could in principle attach to the propose-er.
- [[caretaker-pattern]] — the Host (creator) / Guest (delegate) split that the Grant flow rests on.
