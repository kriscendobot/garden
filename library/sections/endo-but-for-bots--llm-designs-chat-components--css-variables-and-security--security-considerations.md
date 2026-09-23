---
title: Security considerations
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security
---

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
