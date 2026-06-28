---
title: "Designation as authorization: the PowerBox and the installation endowment"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller]
source_year: 2004
source_venue: "HP Laboratories Technical Report HPL-2004-221"
source_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
---

## Abstract

The three mechanisms Polaris carries over from CapDesk that let it grant fine-grained
authority while making "almost all of the security decisions disappear into the
background": (1) treating an act of **designation** (double-clicking a document) as
simultaneously an act of **authorization**; (2) the **installation endowment**, the
standing read-authority an application needs over its own executable, libraries, and
fonts, independent of which document it edits; and (3) the **PowerBox**, a trusted
broker that intercepts the application's File-Open dialog and grants the running
process authority to exactly the one file the user selects — adding authority to a
running program with zero extra user effort, the very thing static sandboxes could not
do.

## Body

**Designation = authorization.** From the earlier CapDesk work the team found that
"combining designation with authorization allows us to manage fine-grained authorities
while making almost all of the security decisions disappear." When a user
double-clicks a spreadsheet to launch Excel, that click is already an act of
*designation* — it names the file the user wants to work on. Polaris treats that same
click as the act of *authorization*: the launched application is granted access to
precisely the designated file and nothing more. The user makes no separate security
decision because the security decision *is* the ordinary act of choosing what to work
on. Applications configured this way launch in **polarized** mode — "with only the
rights they need for the job the user wants done."

**The installation endowment.** A polarized Excel needs more than the one document:
it needs its own executable, shared libraries, fonts, and a place for temporary files,
every time it runs regardless of which document is open. Polaris grants each
application a static **installation endowment** — read-authority over exactly those
standing files — carried over from CapDesk. The pairing is what makes the scheme
usable: the installation endowment covers the per-run constants, and
designation-as-authorization covers the per-document variable, so the user's normal
workflow supplies all the authority the application legitimately needs and no more.

**The PowerBox.** The case static sandboxes handled badly was *adding* authority to an
already-running program. Polaris solves it without any new user gesture: when the user
clicks File-Open, Polaris detects the standard file dialog and replaces it with one
drawn by the **PowerBox** — a trusted process that itself holds access to all the
user's files. After the user picks a file in the PowerBox, Polaris grants the running
application authority to *that one file*. There is no extra security prompt; Polaris
*infers* the authority the user intends to grant by observing the user's act of
designation inside the PowerBox. The PowerBox is the third concept adopted from
CapDesk, and it is the direct ancestor of the "powerbox" file-picker brokering pattern
in later capability desktops.

## Translation (paper idiom → Endo / contemporary surface)

| Polaris / CapDesk idiom | Endo / contemporary equivalent |
|---|---|
| designation = authorization | naming a resource is granting access to it — no separate consent step |
| installation endowment | the static set of capabilities a bundle needs every run (its own code, libs) |
| PowerBox | trusted file-picker broker that mints a single-file capability on user selection |
| polarized mode | running with only the authority the task requires (least-authority launch) |
| Pet | a configured least-authority instance of a legacy application |

## See also

- [[powerbox]] — the trusted file-broker pattern Polaris names.
- [[principle-of-least-authority]] — what polarized launch enforces.
- [[designation-and-authorization]] — the unifying idea (designation *is* authorization).
- [papers--miller-tulloh-shapiro-structure-of-authority-2004](../sources/papers--miller-tulloh-shapiro-structure-of-authority-2004.md) — §1.1 "designation determines least authority" is the theory this mechanizes.

## Common confusions

- **"The PowerBox is a permission dialog."** It is the opposite. A permission dialog
  asks the user an out-of-band yes/no question; the PowerBox carries *no security
  question at all* — it is just the file picker. The authority grant is a side effect
  of the ordinary act of choosing a file, which is why Polaris can claim there are "no
  extra security decisions to be made."
- **"Installation endowment is the same as the per-document grant."** No: the
  endowment is the standing, static read-authority (executable, libraries, fonts) that
  is identical across runs; the per-document authority is minted fresh each time the
  user designates a file. Conflating them would re-introduce the broad directory
  authority Polaris is trying to avoid.

Source: [Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)](https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html), "Using an Application under Polaris." PDF SHA-256 `6c95faf1…`.
