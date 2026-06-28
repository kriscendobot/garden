---
id: polaris
aliases: [Polaris, polarize, polarization, polarized application, Pet, PolaBear, "Polaris Windows XP", "virus-safe computing", "PolaBear Polarizer"]
topics: [capability-security, capability-theory]
---

# polaris

**Polaris** is an HP Labs package (Stiegler, Karp, Yee, Miller; HP Labs Technical
Report HPL-2004-221, December 2004; revised with a fifth author, Tyler Close, as a
2006 CACM article) that retrofits the **Principle of Least Authority** onto unmodified
Windows XP and its shrink-wrapped applications. It changes only how applications are
*launched*, not the OS or the apps: a **polarized** application instance — a **Pet** —
runs in a separate restricted Windows user account (via a `RunAs` variant) holding
only an *installation endowment* (read-authority over its own code/libraries/fonts)
plus authority to the specific document the user designated. Adding authority to a
running Pet is handled by the **PowerBox** (it intercepts File-Open and grants a
single-file authority on the user's selection), so security decisions disappear into
the ordinary act of choosing what to work on. Polaris is the legacy-platform
sandboxing companion to the team's from-scratch CapDesk desktop, and a canonical
worked example of POLA applied to an ambient-authority OS. By the 2006 revision the
beta had **closed the GUI hole** (the 2004 report's one unblocked residual attack) and
carried two years of alpha/beta pilot use with reported real-world virus saves.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [excess-authority-the-virus-problem-and-permission-versus-authority](../sections/papers--stiegler-polaris-virus-safe-computing-2004--excess-authority-the-virus-problem-and-permission-versus-authority.md) | (2004) Why viruses exploit the system as designed; the permission-vs-authority distinction. |
| [designation-as-authorization-powerbox-and-installation-endowment](../sections/papers--stiegler-polaris-virus-safe-computing-2004--designation-as-authorization-powerbox-and-installation-endowment.md) | (2004) The three CapDesk-derived mechanisms: designation=authorization, installation endowment, PowerBox. |
| [polarizing-applications-pets-restricted-accounts-and-visual-cues](../sections/papers--stiegler-polaris-virus-safe-computing-2004--polarizing-applications-pets-restricted-accounts-and-visual-cues.md) | (2004) Pets, restricted user accounts, the copy+synchronizer, visual cues. |
| [status-limits-and-residual-attacks](../sections/papers--stiegler-polaris-virus-safe-computing-2004--status-limits-and-residual-attacks.md) | (2004) Pilot status, incompatibilities, and the network/GUI-hole residual attacks. |
| [what-the-2006-cacm-revision-adds](../sections/papers--stiegler-polaris-cacm-2006--what-the-2006-cacm-revision-adds.md) | (2006) The 2004→2006 diff: fifth author, pilot experience, closed GUI hole, Vista/UAP comparison. |
| [closing-the-gui-hole-shatter-proofing-windows](../sections/papers--stiegler-polaris-cacm-2006--closing-the-gui-hole-shatter-proofing-windows.md) | (2006) The beta closes the GUI hole via the Shatter-proofing-Windows API technique; Pet sandbox now contains the in-process adversary. |
| [two-years-of-pilot-experience-and-residual-limits](../sections/papers--stiegler-polaris-cacm-2006--two-years-of-pilot-experience-and-residual-limits.md) | (2006) Alpha since 2005, beta 2006, George Mason + US Navy pilots, real virus saves; residual network/Direct3D/PGP/Cygwin/linked-file limits. |
| [privilege-permission-and-authority](../sections/papers--stiegler-polaris-cacm-2006--privilege-permission-and-authority.md) | (2006) The permission-vs-authority sidebar (web-server example), with an Endo translation table. |
| [ocap-history--e-capdesk-polaris-market-history--polaris-sandboxing-legacy-apps-hp-labs-mid-2000s](../sections/ocap-history--e-capdesk-polaris-market-history--polaris-sandboxing-legacy-apps-hp-labs-mid-2000s.md) | Market-history survey's account of Polaris's adoption arc. |

## See also

- [[powerbox]] — Polaris's trusted file-broker; the component the GUI-hole attack targets.
- [[principle-of-least-authority]] — the discipline Polaris retrofits.
- [[capdesk]] — the from-scratch POLA desktop Polaris borrows designation-authorization, installation endowment, and the PowerBox from.
- [[permission-versus-authority]] — the distinction that justifies copy+synchronizer over an in-place ACL edit.
