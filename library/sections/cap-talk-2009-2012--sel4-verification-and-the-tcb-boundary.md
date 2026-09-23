---
title: "seL4 verification and the trusted-computing-base boundary"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-February/
source_snapshot: http://web.archive.org/web/20130603012729id_/http://www.eros-os.org/pipermail/cap-talk/2011-February.txt.gz
source_content_sha256: 04dab0af089f2d19a65291f03086bcc171b5fda8b785f79e64a4633a99b81a85
source_authors: [Gernot Heiser, Jonathan Shapiro, David-Sarah Hopwood, Bill Frantz, Matej Kosik]
source_date: 2011-02-25 to 2011-03-03
thread_subject: "Public Release of seL4: a formally verified capability-based microkernel"
ingested: 2026-09-16
ingested_by: scholar
topics: [sandbox-platforms, capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages. The thread begins in the February bundle and concludes in March."
---

Abstract: The public seL4 release prompted a precise argument about what had been verified. Gernot Heiser stated the boundary: the proof establishes functional correctness of the roughly 9,000-line privileged microkernel, not the complete operating system, its user-level services, or applications. That boundary is useful because privileged kernel code cannot rely on enforced internal isolation, while a verified kernel can enforce interfaces among user components and let later proofs treat them separately. Jonathan Shapiro added the economic boundary: proof cost delayed the product enough that commercial systems did not initially use the verified kernel, even though source availability enabled third parties to inspect the proof and reproduce the binary. The thread presents microkernel minimality, POLA, reproducible verification, and proof economics as parts of one trusted-computing-base design.

## What the proof covers

A kernel is the privileged part of an operating system; a microkernel is a small kind of kernel, not a claim to be the whole OS. Heiser contrasted a roughly 9,000-line seL4 kernel with mainstream kernels measured in millions of lines. The proof applies only to kernel code. User libraries, services, and sample applications remain outside it. This does not make the result merely partial in the dismissive sense: once the kernel's isolation mechanisms are trustworthy, user-level components can be analyzed independently while retaining enforced boundaries between them.

## Why the boundary is small

Code executing with undivided privilege can potentially interfere with any other kernel component, so internal module boundaries are conventions until some lower mechanism enforces them. A microkernel moves drivers and services outside that zone. Bill Frantz and Shapiro noted that language or type-based separation can shrink the trusted part further in purpose-written code, but some mechanism must ultimately decide when data becomes executable instructions and preserve that decision. Errors there own whatever the layer controls.

## Verification economics and reproducibility

Shapiro welcomed source distribution because it lets a third party check the proof and, with build instructions, reproduce the shipping binary. He also explained why the release's non-commercial terms did not erase the achievement: proof investment was large, financing compounds with delay, and the verified kernel's proof schedule had already made it too expensive for the first commercial products. Verification scope is therefore both a proof-composition question and a delivery constraint.

## Bearing on Endo

Endo uses a language rather than a microkernel as its enforcement substrate, but the boundary lesson transfers. Keep the lockdown, evaluator, marshal, and transport mechanisms small enough that their invariants can support separate reasoning about application compartments and vats. State exactly which layers a proof or audit covers. Source availability and reproducible builds let another party check the claim, but do not extend it to dependencies or application code outside the examined boundary.

Source: [cap-talk 2011-February archive](http://www.eros-os.org/pipermail/cap-talk/2011-February/) and [2011-March continuation](http://www.eros-os.org/pipermail/cap-talk/2011-March/) (Internet Archive original-bytes snapshots, sha256 `04dab0af` and `53c91978`), thread "Public Release of seL4: a formally verified capability-based microkernel", 2011-02-25 to 2011-03-03.
