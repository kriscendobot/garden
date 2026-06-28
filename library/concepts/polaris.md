---
id: polaris
aliases: [Polaris, polarize, polarization, polarized application, Pet, PolaBear, "Polaris Windows XP", "virus-safe computing", "PolaBear Polarizer"]
topics: [capability-security, capability-theory]
---

# polaris

**Polaris** is an HP Labs package (Stiegler, Karp, Yee, Miller; HP Labs Technical
Report HPL-2004-221, December 2004; later revised as a 2006 CACM article) that
retrofits the **Principle of Least Authority** onto unmodified Windows XP and its
shrink-wrapped applications. It changes only how applications are *launched*, not the
OS or the apps: a **polarized** application instance — a **Pet** — runs in a separate
restricted Windows user account (via a `RunAs` variant) holding only an *installation
endowment* (read-authority over its own code/libraries/fonts) plus authority to the
specific document the user designated. Adding authority to a running Pet is handled by
the **PowerBox** (it intercepts File-Open and grants a single-file authority on the
user's selection), so security decisions disappear into the ordinary act of choosing
what to work on. Polaris is the legacy-platform sandboxing companion to the team's
from-scratch CapDesk desktop, and a canonical worked example of POLA applied to an
ambient-authority OS.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [excess-authority-the-virus-problem-and-permission-versus-authority](../sections/papers--stiegler-polaris-virus-safe-computing-2004--excess-authority-the-virus-problem-and-permission-versus-authority.md) | Why viruses exploit the system as designed; the permission-vs-authority distinction. |
| [designation-as-authorization-powerbox-and-installation-endowment](../sections/papers--stiegler-polaris-virus-safe-computing-2004--designation-as-authorization-powerbox-and-installation-endowment.md) | The three CapDesk-derived mechanisms: designation=authorization, installation endowment, PowerBox. |
| [polarizing-applications-pets-restricted-accounts-and-visual-cues](../sections/papers--stiegler-polaris-virus-safe-computing-2004--polarizing-applications-pets-restricted-accounts-and-visual-cues.md) | Pets, restricted user accounts, the copy+synchronizer, visual cues. |
| [status-limits-and-residual-attacks](../sections/papers--stiegler-polaris-virus-safe-computing-2004--status-limits-and-residual-attacks.md) | Pilot status, incompatibilities, and the network/GUI-hole residual attacks. |
| [ocap-history--e-capdesk-polaris-market-history--polaris-sandboxing-legacy-apps-hp-labs-mid-2000s](../sections/ocap-history--e-capdesk-polaris-market-history--polaris-sandboxing-legacy-apps-hp-labs-mid-2000s.md) | Market-history survey's account of Polaris's adoption arc. |

## See also

- [[powerbox]] — Polaris's trusted file-broker; the component the GUI-hole attack targets.
- [[principle-of-least-authority]] — the discipline Polaris retrofits.
- [[capdesk]] — the from-scratch POLA desktop Polaris borrows designation-authorization, installation endowment, and the PowerBox from.
- [[permission-versus-authority]] — the distinction that justifies copy+synchronizer over an in-place ACL edit.
