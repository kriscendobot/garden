---
id: powerbox
aliases: [PowerBox, powerbox, "power box", "file-picker broker", "powerbox pattern"]
topics: [capability-security, patterns]
---

# powerbox

A **PowerBox** is a trusted broker that holds broad authority (e.g. access to all of a
user's files) and hands out narrow, single-use authority in response to a user's
ordinary act of designation — most familiarly, by replacing an application's File-Open
dialog so that picking a file *is* the act that grants the running application
authority to exactly that file, with no separate security prompt. Introduced in
CapDesk and carried into **Polaris**, the PowerBox is how a least-authority application
acquires *additional* authority at runtime without the user making an out-of-band
security decision — solving the problem static sandboxes handled badly. Its trust is
also its exposure: in Polaris the unblocked Windows "GUI hole" lets a virus drive the
PowerBox with synthetic GUI events to grant itself authority over any file, a
confused-deputy attack against the broker.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [designation-as-authorization-powerbox-and-installation-endowment](../sections/papers--stiegler-polaris-virus-safe-computing-2004--designation-as-authorization-powerbox-and-installation-endowment.md) | The PowerBox intercepts File-Open and mints a single-file authority on selection. |
| [polarizing-applications-pets-restricted-accounts-and-visual-cues](../sections/papers--stiegler-polaris-virus-safe-computing-2004--polarizing-applications-pets-restricted-accounts-and-visual-cues.md) | How a running Pet acquires authority to further files. |
| [status-limits-and-residual-attacks](../sections/papers--stiegler-polaris-virus-safe-computing-2004--status-limits-and-residual-attacks.md) | The GUI-hole attack drives the PowerBox to grant unintended authority. |
| [cap-talk-2004-2008--confinement-crisis-and-capdesk-pola](../sections/cap-talk-2004-2008--confinement-crisis-and-capdesk-pola.md) | The CapDesk demonstration makes dynamic least authority and designation-as-authorization concrete. |
| [cap-talk-2004-2008--polaris-shatter-attacks-and-gui-confinement](../sections/cap-talk-2004-2008--polaris-shatter-attacks-and-gui-confinement.md) | Polaris must mediate the shared Windows GUI channel so a confined application cannot drive the trusted broker. |
| [cap-talk-2004-2008--persistence-session-failure-and-powerboxes](../sections/cap-talk-2004-2008--persistence-session-failure-and-powerboxes.md) | A trusted powerbox persists intended references rather than letting applications edit ambient filenames into authority. |
| [cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest](../sections/cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md) | The powerbox as the deliberate, user-mediated re-introduction of authority: an install-time manifest plus escalation prompts, and the worry that consent prompts habituate users into re-granting ambient authority. |
| [web-powerbox-and-oauth](../sections/cap-talk-2009-2012--web-powerbox-and-oauth.md) | The 2010 Web Powerbox design (Seaborn, Varda, Close, Miller): a browser-held introducer with drag-and-drop grants and a revocable-connection UI, and why it beats OAuth. |

## See also

- [[polaris]] — the system that uses the PowerBox to retrofit POLA onto Windows.
- [[designation-and-authorization]] — the principle the PowerBox embodies (selecting = authorizing).
- [[principle-of-least-authority]] — what the PowerBox preserves while still allowing authority to grow.
- [[confused-deputy]] — the attack class the GUI-hole-driven PowerBox falls to.
