---
title: "Using and polarizing an application: designation as authorization, the PowerBox, Pets, visual cues"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark Miller]
source_year: 2004
source_venue: HP Laboratories Palo Alto Technical Report HPL-2004-221
source_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_fetched_via: wayback
source_wayback_timestamp: 20220423221140
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security]
status: current
---

## Abstract

How Polaris is used: three ideas carried over from CapDesk — combining designation with authorization, the installation endowment, and the PowerBox — let fine-grained authority be managed while almost all security decisions disappear into normal use. Double-clicking a file designates *and* authorizes; the PowerBox replaces the File Open dialog and grants exactly the one file the user selects; an application is "polarized" into one or more "Pets" (per-account configurations); and visual cues (pet name and a colored title bar) keep the user aware of which protection state each window is in.

## Content

**Designation as authorization.** "We have found from our earlier work on CapDesk that combining designation with authorization allows us to manage fine-grained authorities while making almost all of the security decisions disappear into the background. Double clicking on the icon for a spreadsheet to launch Excel is an act of designation. In Polaris, we treat the act of designation also as one of authorization." Applications can be configured to launch "in polarized mode, that is with only the rights they need for the job the user wants done."

**Installation endowment.** A polarized process needs more than the file being edited — its own executable, shared libraries, fonts, temporary files. "Since access to these files is needed every time the application runs, regardless of which file it is editing, we give each application an *installation endowment* consisting of the ability to read these files, another concept we carried over from CapDesk. It is this coupling of an installation endowment and the combining of designation with authorization that makes the security decisions part of the user's normal activity."

**The PowerBox.** "Unlike sandboxing or Java Web Start, Polaris is able to add to the authorities available to a process without any extra effort on the part of the user. The user simply clicks the File Open icon. Polaris detects the dialog box and replaces it with one from the *PowerBox*, a process that has access to all the user's files. After the user selects a file, Polaris makes that one file accessible to the running program. There are no extra security decisions to be made. Polaris infers what authorities the user wants to grant by detecting the user's acts of designation in the PowerBox. The Powerbox is the third concept Polaris adopted from CapDesk."

**Polarizing into Pets.** Configuring an application to run safe from viruses is called *polarization*; an instance of a polarized application is a **Pet**. The user gives the Pet a name (which appears in the window title bar, giving "a convenient verification that the program being run is safe from viruses") and optional file extensions that trigger it. "It often makes sense to have more than one pet for a given application" — e.g. separate browser Pets for Intranet, Internet, and reading local files, "since each pet runs in a separate user account", so passwords remembered by the Intranet pet are not exposed when the Internet pet visits an external site.

**Visual cues.** "It is important that the user be aware of the security environment, but the cues should not be obtrusive." Polaris modifies the title bar: a running Pet shows its pet name (blank if not launched under Polaris) and, using a Windows XP feature, a changed title-bar color. The cues appear in all sub-windows — important when, for example, "a macro virus running in Excel could open a file dialog box that overlaps a window running Word"; without the cue the user "might select a file without knowing which application would get permission to edit it." A Polarized application can still be run unsafely (launch directly or right-click → Open instead of OpenSafe), in which case it runs with all the user's permissions and a virus in it can abuse any of them.

Source: Polaris: Virus Safe Computing for Windows XP, HP Laboratories technical report HPL-2004-221 (December 2004); PDF fetched via the Internet Archive original-bytes capture (`source_fetched_via=wayback`, [web/20220423221140id_/](http://web.archive.org/web/20220423221140id_/http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf)), PDF SHA-256 `6c95faf1`.
