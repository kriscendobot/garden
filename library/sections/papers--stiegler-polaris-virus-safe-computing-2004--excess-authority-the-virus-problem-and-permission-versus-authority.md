---
title: "Excess authority: why viruses exploit the system as designed, and the permission-versus-authority distinction"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller]
source_year: 2004
source_venue: "HP Laboratories Technical Report HPL-2004-221"
source_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
---

## Abstract

Polaris's framing argument: viruses delivered through email attachments, document
macros, and web scripts are not exploiting code flaws — they are *using the system
the way it was designed to be used*. Every widely-used OS bases security on the
identity of the logged-in user, so every program a user runs inherits the user's
full authority "whether you want it done or not." The root defect is **excess
authority**: there is no reason Solitaire needs to read your disk and exfiltrate
secrets, or Excel to write a Trojan into your startup folder, yet identity-based
systems grant exactly that. Sandboxing and "May I?" permission dialogs are the usual
mitigations and both fail — static sandbox rules cannot follow a running program's
changing needs, and dialog fatigue erases the distinction between user-intended and
software-initiated requests. The section closes on the report's load-bearing
conceptual tool, the **permission-versus-authority** distinction.

## Body

**Viruses use the system as designed.** Unlike malware that depends on a security
hole in some piece of code, macro/attachment/script viruses exploit nothing broken;
they do "things you're allowed to do that you don't want done." The report quotes the
first of Microsoft's *10 Immutable Laws of Security* — "If a bad guy can persuade you
to run his program on your computer, it's not your computer anymore" — and treats it
not as a law of nature but as an indictment of identity-based security: the law is
only true because every program runs with all of the user's authority.

**Why the usual mitigations fail.** *Sandboxing* (e.g. Java 2 security) sets up a
static rule set per program; the failing is that the rules are static, so adding an
authority to a running program (such as the authority to open a newly-chosen file) is
hard. The alternative — controlling access to individual resources — has historically
been "too hard to use," nagging the user with "May I?" dialogs (the report's Figure 1
shows Java Web Start's). The deeper problem with such advisories: hiding them for the
session removes the only signal distinguishing a request the *user* made from one the
*software* made, so dismissing the dialog can let software act against the user's
wishes. The belief that fine-grained control is unusable pushes designers to group
authorities into "relatively large chunks," which look easy to use until you try to
stop viruses abusing those chunks — then come the virus scanners, firewalls, and the
defensive advice that *reduces* functionality: "Don't launch email attachments,"
"Disable macros," "Turn off scripting." Excel's macro dialog (Figure 2) epitomizes
the dilemma: it asks the user to choose between not getting work done and losing
control of the machine, without supplying enough information to decide intelligently
("Why is the macro needed? What damage might it do? You have no way of knowing").

**Permission versus authority.** The report's sidebar draws the distinction (citing
Saltzer-Schroeder's Principle of Least Privilege [4] and Miller-Shapiro's *Paradigm
Regained* [5]): **permission** is the set of rules as written down, e.g. entries in an
access control list; **authority** is the set of actions a process can actually *cause
to happen*, combining permissions with the behavior of the parties holding them. The
canonical example: a web server has *permission* (an ACL entry) to read the site's
files; a visitor has no ACL entry yet has the *authority* to read those files because
the server presents them. Security analysis that counts only permission is therefore
incomplete; analysis that counts authority is bounded only by our ability to
understand program behavior — but a usable bound on authority is often obtainable.
This distinction is what lets Polaris later claim that a restricted account can have
the *authority* to change a file without ever being granted *permission* to it.

## Translation (paper idiom → Endo / contemporary surface)

| Polaris / 2004 idiom | Endo / contemporary equivalent |
|---|---|
| excess authority | ambient authority a program holds beyond what its task needs |
| Principle of Least Authority (POLA) | the same POLA Endo invokes for bundles/compartments |
| permission (ACL rules as written) | the static grant recorded somewhere |
| authority (actions a process can cause) | what a capability holder can actually effect — the reachable access graph |
| "May I?" dialog / large chunks of authority | coarse, ambient grant + consent-fatigue UX |

## See also

- [[principle-of-least-authority]] — the discipline Polaris retrofits onto Windows.
- [[permission-versus-authority]] — the distinction this section turns on.
- [papers--miller-shapiro-paradigm-regained-2003](../sources/papers--miller-shapiro-paradigm-regained-2003.md) — the cited source of the permission/authority distinction.
- [papers--close-acls-dont-2009](../sources/papers--close-acls-dont-2009.md) — Tyler Close's fuller account of why ACL authority assignment is structurally wrong.

## Common confusions

- **"Polaris is antivirus / a sandbox."** No — it does not scan for or recognize
  viruses, and it is not a static rule-set sandbox. It removes the *excess authority*
  a virus would need, so a virus that runs simply cannot do much. The defense is
  structural (least authority), not signature- or rule-based.
- **"Permission and authority are synonyms."** The report's whole argument depends on
  their being different: a process can wield authority it was never granted explicit
  permission for (the web-server visitor), which is exactly why permission-only
  analysis under-counts what a virus can do.

Source: [Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)](https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html), §intro and the "Privilege, Permission, and Authority" sidebar. PDF SHA-256 `6c95faf1…`.
