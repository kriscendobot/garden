---
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller]
source_title: "Polaris: Virus Safe Computing for Windows XP"
source_year: 2004
source_venue: "HP Laboratories Technical Report HPL-2004-221 (Mobile and Media Systems Laboratory, HP Labs Palo Alto), December 1, 2004"
source_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_pdf_pages: 9
source_fetched_via: wayback
source_wayback_timestamp: 20220423221140
source_snapshot: http://web.archive.org/web/20220423221140id_/https://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf
ingested: 2026-06-28
ingested_by: scholar
section_count: 4
status: current
notes: |
  Fetched via the Internet Archive original-bytes fallback (`scripts/jobs/fetch-source.sh`):
  www.hpl.hp.com refused connections from the bot sandbox, so the bytes came from the
  Wayback `id_` capture at timestamp 20220423221140. `source_pdf_sha256` (over the
  fetched bytes) is the idempotency anchor, not a git SHA.

  NUMBER CORRECTION. The posting job ("scholar-ingest-source-hpl-techreports-polaris")
  named this report "HPL-2004-116" with authors "Stiegler, Karp, Close, Frantz, Miller".
  Both were wrong. `HPL-2004-116.pdf` at that URL is an unrelated HP Labs Bristol paper,
  *"Fancy a Schmink?": a novel networked game in a café* (Reid, Lipson, Hyams, Shaw,
  Oct 2004) — confirmed by fetching it (sha256 eb4f5e4ad5bf742c69ca2889c1e1a55d47bb9c429b777b0bc15034ab3b08a659).
  The Polaris report is **HPL-2004-221** with four authors — Marc Stiegler, Alan H. Karp,
  Ka-Ping Yee, Mark S. Miller (Tyler Close is added on the 2006 CACM revision, not this
  report). The corrected source was confirmed against the report's own title page.
---

The December 2004 HP Labs technical report introducing **Polaris**, a package for
Windows XP that retrofits the **Principle of Least Authority (POLA)** onto an
unmodified, identity-based operating system without changing the OS or the
applications — only the way applications are *launched*. Polaris is the legacy-app
sandboxing companion to the team's earlier from-scratch CapDesk work: where CapDesk
demonstrated a POLA-disciplined desktop built on the E language, Polaris asks how
much of the same safety can be bought for the shrink-wrapped Windows applications
people already run (Excel, Word, Internet Explorer) without rewriting them.

**The diagnosis.** All widely-used operating systems base security on the identity
of the logged-in user, so *every program you run can do anything you can do, whether
you want it done or not*. Viruses that ride email attachments, document macros, and
web scripts are not exploiting code flaws — they are using the system as designed,
abusing the **excess authority** every program is handed. Solitaire does not need to
read your disk and phone home; Excel does not need to write your startup folder.
Sandboxing (static rule sets, Java 2 security) and "May I?" permission dialogs fail
because static rules cannot follow a running program's changing needs and dialog
fatigue trains users to click through.

**The mechanism.** Polaris carries three ideas over from CapDesk: combining
**designation with authorization** (double-clicking a document is simultaneously the
act that names the file and the act that grants access to it), the **installation
endowment** (the static read-authority a polarized app needs over its own
executable, libraries, and fonts), and the **PowerBox** (a trusted broker that
intercepts the File-Open dialog and grants the running app authority to exactly the
one file the user picked). Each polarized application instance — a **Pet** — runs in
a separate restricted Windows user account via a `RunAs` variant, with the document
copied in and a **synchronizer** keeping copy and original consistent; stopping the
synchronizer revokes the authority cleanly, leaving no dangling permissions. Visual
cues (a pet name and colored title bar) keep the protection state legible.

**The honest limits.** The report is candid about a pre-Alpha/Alpha system: launch
is slow, linked files and Java apps misbehave, Direct3D (and so over half of games),
PGP, and Cygwin are incompatible, and two attacks remain unblocked — network
exfiltration and the Windows **GUI hole** (any app can read and inject GUI events to
any window, so a virus could drive the PowerBox). The report frames the GUI hole
wryly: if virus authors are reduced to attacking the PowerBox, Polaris has already
won.

For the Endo / Agoric library this report is the **canonical worked example of POLA
retrofitted onto a legacy, ambient-authority platform** — the practical mirror of
the theory in *The Structure of Authority* and *Paradigm Regained*. Its
permission-vs-authority sidebar (drawn from Saltzer-Schroeder and Miller-Shapiro) is
the same distinction Endo invokes when it argues that a capability bound to a bundle
is *authority* the holder can wield, not merely a *permission* recorded somewhere.
The designation-is-authorization and PowerBox patterns are direct ancestors of
file-picker / powerbox brokering in capability desktops and of Endo's discipline of
endowing bundles with capability *handles* rather than path *names*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [excess-authority-the-virus-problem-and-permission-versus-authority](../sections/papers--stiegler-polaris-virus-safe-computing-2004--excess-authority-the-virus-problem-and-permission-versus-authority.md) | capability-security, capability-theory | current |
| [designation-as-authorization-powerbox-and-installation-endowment](../sections/papers--stiegler-polaris-virus-safe-computing-2004--designation-as-authorization-powerbox-and-installation-endowment.md) | capability-security, capability-theory, patterns | current |
| [polarizing-applications-pets-restricted-accounts-and-visual-cues](../sections/papers--stiegler-polaris-virus-safe-computing-2004--polarizing-applications-pets-restricted-accounts-and-visual-cues.md) | capability-security, patterns | current |
| [status-limits-and-residual-attacks](../sections/papers--stiegler-polaris-virus-safe-computing-2004--status-limits-and-residual-attacks.md) | capability-security | current |

## See also

- [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md) — the market-history survey that names Polaris (and CapDesk, E, Waterken) as the first wave of working object-capability systems; this primary report is the technical source behind that survey's Polaris narrative.
- [papers--miller-tulloh-shapiro-structure-of-authority-2004](papers--miller-tulloh-shapiro-structure-of-authority-2004.md) — the contemporaneous theory paper; Polaris is its legacy-platform proof-of-concept.
- [papers--miller-shapiro-paradigm-regained-2003](papers--miller-shapiro-paradigm-regained-2003.md) — source of the permission-vs-authority distinction Polaris's sidebar uses (cited as reference [5] in the report).
- [papers--close-acls-dont-2009](papers--close-acls-dont-2009.md) — Tyler Close's later articulation of why ACL-based access control fails; Polaris is the system that routes *around* the ACL rather than editing it in place.

## Provenance

- Ingested by a gardener wearing the scholar role on 2026-06-28, completing job `scholar-ingest-source-hpl-techreports-polaris`.
- Source PDF SHA-256 `6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71`, 9 pages, fetched from the Internet Archive `id_` capture `http://web.archive.org/web/20220423221140id_/https://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf` (canonical host `www.hpl.hp.com` refused connections from the bot sandbox).
- Maintainer context: capability theory and POLA are foundational defensive-security research; Mark Miller is the maintainer's longtime mentor and a co-author; the work is publicly available HP Labs research aimed at defending against the harms three decades of capability-security research have worked to forestall.
