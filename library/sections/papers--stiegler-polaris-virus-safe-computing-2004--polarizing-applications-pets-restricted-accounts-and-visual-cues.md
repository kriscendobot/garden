---
title: "Polarizing applications: Pets, restricted user accounts, the synchronizer, and visual cues"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller]
source_year: 2004
source_venue: "HP Laboratories Technical Report HPL-2004-221"
source_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, patterns]
status: current
---

## Abstract

How Polaris is configured and how it works under the hood, without changing the OS or
the applications: **polarizing** an application produces a configured instance called a
**Pet** (named, with associated file extensions); each Pet runs in its own *separate
restricted Windows user account* launched via a `RunAs` variant, so a user can keep
several isolated Pets per application (an Intranet browser Pet, an Internet browser
Pet, a disk-reading Pet). Polaris copies the designated document into a folder the
restricted account can reach and runs a **synchronizer** to keep copy and original
consistent; this is deliberately *not* an in-place ACL edit, for two reasons — temp
files and the permission-versus-authority distinction (stopping the synchronizer
revokes authority cleanly, leaving no dangling permissions). **Visual cues** (a pet
name and a colored title bar, propagated to sub-windows) keep the protection state
legible to the user.

## Body

**Polarizing and Pets.** Configuring an application to run virus-safe is called
**polarization**; an instance of a polarized application is a **Pet** (the report's
Figure 3 shows the "PolaBear Polarizer" dialog configuring an Excel Pet). The user
gives the Pet a one-word pet name — which appears in the title bar of every window the
Pet runs, a continuous verification that the running program is virus-safe — and
optionally a set of file extensions, so clicking a file with a matching extension
launches the Pet. It often makes sense to have several Pets for one application: a
browser Pet for the Intranet, another for the Internet, a third for reading files from
disk. Because each Pet runs in a *separate user account*, the Intranet Pet can remember
passwords without the Internet Pet (visiting an external site) being able to read them;
and a file-reading Pet configured to treat all sites as untrusted cannot accidentally
run a malicious script.

**How it works: restricted accounts + synchronizer.** Polaris "doesn't change the
operating system or the applications; all that changes is the way applications are
launched." Instead of starting in the logged-in user's account, a polarized
application launches in a **restricted user account that has very few permissions**,
using the OS's own security to bound what the software (including any virus in it) can
do. The launch (Figure 5) proceeds in steps: copy the document into a folder the
restricted account can reach; set up a **synchronizer** to keep the copy and the
original file consistent; launch the application under the restricted account via a
variant of the Windows `RunAs` command. A virus running in the restricted account can
damage only the file it is in — it cannot touch the startup folder, read other files
for secrets, or (for a polarized browser) plant spyware/adware; the report notes pilot
users who visited virus-bearing pages and were unharmed.

**Why not just edit the ACL in place.** Two reasons. First, many applications (e.g.
Word) write temp files into the document's own directory, so editing in place would
require granting read+write to the *whole directory*, greatly enlarging what a virus
could damage. Second, the **permission-versus-authority** distinction: the restricted
account is given the *authority* to effect changes to the original file (through the
synchronizer) but never the *permission* (an ACL entry). The payoff is clean
revocation — stop the synchronizer (e.g. on a crash) and the authority is gone, with
no dangling permissions to clean up later.

**Visual cues and opt-out.** Security state must be visible but unobtrusive. Polaris
puts the pet name in the title bar (blank if the app was not launched under Polaris)
and recolors the title bar of Pet windows; the cues appear in all sub-windows, which
matters when a macro virus in Excel opens a file dialog overlapping a Word window — the
cue tells the user which application would receive the file. Polarizing an application
does not bar the unsafe path: the user may still launch the app directly or right-click
a file and choose Open (rather than OpenSafe), running it with full user permissions —
but then a virus inside it can abuse any of the user's authorities.

## Translation (paper idiom → Endo / contemporary surface)

| Polaris idiom | Endo / contemporary equivalent |
|---|---|
| Pet | a configured least-authority instance of an application |
| polarization | configuring an app to launch with only the authority its task needs |
| restricted user account (`RunAs`) | OS-enforced confinement boundary for the instance |
| synchronizer | the broker that grants *authority* to write the original without *permission* |
| separate account per Pet | per-instance isolation (one compromise cannot reach a sibling's secrets) |
| OpenSafe vs Open | least-authority launch vs ambient-authority launch |

## See also

- [[principle-of-least-authority]] — what each Pet's restricted account enforces.
- [[permission-versus-authority]] — why copy+synchronizer beats an in-place ACL edit.
- [[powerbox]] — how a running Pet later acquires authority to additional files.
- [ocap-history--e-capdesk-polaris](../sources/ocap-history--e-capdesk-polaris.md) — market-history survey placing Polaris among the first working ocap systems.

## Common confusions

- **"The synchronizer grants permission to the original file."** It grants *authority*,
  not permission — exactly the distinction that makes revocation clean. The restricted
  account never gets an ACL entry on the original.
- **"One Pet per application."** Multiple Pets per application is a feature, not a
  redundancy: separate accounts are how the Intranet password store stays invisible to
  the Internet browser.

Source: [Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)](https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html), "Polarizing an Application," "Visual Cues," and "How Polaris Works." PDF SHA-256 `6c95faf1…`.
