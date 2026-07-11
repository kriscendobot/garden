---
title: The idea — don't separate designation from authority (and the Confused Deputy)
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

## Abstract

The core argument of the essay, built around Norm Hardy's admonition **"don't
separate designation from authority."** The capability paradigm is about *access
control*: when a system is asked for a service, it must decide whether to do what the
requestor asks. The intuitive first move — ask *"who are you?"* — is "the first step
on the road to perdition." Morningstar develops why through the Microsoft Word "Save"
example: an **ACL** (Access Control List) checks whether *you* are allowed to write
the file, never whether the write is the one you actually asked for, so an
application you run "can do anything you can do" — it could ship your file to
Macedonia, encrypt your files for ransom, and so on, all under your ambient
permissions. The alternative: when you pick a file from an Open dialog, the OS hands
Word a **handle** (a capability) to that one file rather than a forgeable pathname
string, so Word gets access to exactly the document and nothing else, with *identical*
user experience and no "mother-may-I?" prompts. The section closes with **Norm
Hardy's Confused Deputy** — the true story of a FORTRAN compiler on a timeshared
system tricked into overwriting the billing file — naming **ambient authority** as
the root flaw and noting that between 5 and 8 of the OWASP top 10 are confused-deputy
problems, a conceptual flaw first noticed in the 1970s.

## Content

Norm Hardy summarizes the capability mindset with the admonition **"don't separate
designation from authority."** It is a zen aphorism mainly useful to people who
already understand it, so Morningstar unpacks it.

The capability paradigm is about **access control**. When a system (an OS, a website)
is presented with a request for a service, it must decide whether to actually do what
the requestor asks. Most people's first instinct is to ask the requestor **"who are
you?"** *The fundamental insight of the capability paradigm is that this question is
the first step on the road to perdition* — highly counterintuitive, hence the
controversy.

**The Word "Save" example.** Click Save in Microsoft Word; Word asks the OS to write
the document file; the OS checks whether *you* have write permission and allows or
forbids accordingly. This seems natural, and here it is fine — but the mechanism is
not doing what you might think. It did **not** check whether the specific write was
the one you asked for (it cannot tell); it just checked whether you were allowed. This
is the **ACL** (Access Control List) model: for each resource, the OS keeps a list of
who may do what. Every mainstream OS — Windows, macOS, Linux, FreeBSD, iOS, Android —
is fundamentally the same in this respect.

The model is "fatally flawed." When you run an application, as far as the OS is
concerned everything the application does is done *by you*: **an application you run
can do anything you can do.** Fine for Word saving your file — but what if Word
transmitted your file to a mafia server in Macedonia, erased every file whose name
begins with a vowel, or encrypted all your files and demanded bitcoin? You are allowed
to do all those things, so it can too. And it is not just Word — it is every piece of
software on your computer, much of it from sources far less accountable than
Microsoft, some of which you do not even know is there.

The underlying problem: **the access-control mechanism has no way to determine what
you really wanted.** Asking you to confirm each operation ("Is it OK for Word to write
this file?") fails dismally — people reflexively click "yes," and many access-
controlled operations are internal (fiddling with a config file) whose appropriateness
the user cannot judge anyway.

**The alternative** starts from how you told Word what you wanted: you double-clicked
an icon or picked from an Open File dialog — interactions typically implemented by the
OS, not Word. Today the OS turns your choice into a **pathname string** it hands to
Word, which passes the string back to the OS to open the file. This works in the
normal case, but Word can pass *any* string it chooses, limited only by *your*
permissions. Now imagine it differently: Word starts with **no access to anything**
access-controlled. When you pick the file, the OS itself opens it and gives Word a
**handle** — a capability. Word now has access to your document and *only* that. It
cannot ship the file to Macedonia (no network access was given), cannot delete or
encrypt other files (no access to them). It can mess up the one file you told it to
edit, and if it did you would stop using Word with no further damage. And your
experience is *exactly the same* — no security questions, no annoyance. "In this
world, that handle to the open file is an example of what we call a 'capability.'"

**Back to designation vs. authority.** *Designation* is how we indicate which thing we
mean; *authority* is what we are allowed to do with it. In the ACL world these are
disconnected: the designator is a pathname string, while authority is an ACL the OS
maintains separately. The two pieces of information the OS needs "travel to it via
separate routes, with no assurance that they will be properly associated when they
arrive." So a program can be *fooled into doing things* never intended to be allowed.

**The Confused Deputy (a true story).** Norm Hardy worked for a company running
timeshared computers — "cloud computing" with an earlier generation's buzzwords. One
service was a FORTRAN compiler. Because computing was expensive, each compile wrote a
billing record to a **system accounting file**; the operators carefully arranged that
only the compiler could write that file. Then someone realized they could name the
accounting file as the compiler's *output* file. The access-control system asked,
"does this program have permission to write this file?" — and it did! — so the
compiler overwrote the billing records, and "everybody got all their compilations for
free that day."

Fixing it was "surprisingly slippery." Hardy named the problem **The Confused
Deputy**: the compiler was deputized by two masters — the customer (whose files it
may write) and the operators (whose accounting file it may update) — and it was
*confused about which master it served for which purpose*, because it could not
associate permissions with intended uses. The permissions "were not distinct things it
could wield selectively — the compiler never actually saw or handled them directly."
This is **ambient authority**: authority "just sitting there in the environment,
waiting to be used automatically without regard to intent or context." Under
capability principles the compiler would hold a *distinct* capability from the
operators for the accounting file and a *different* capability from the customer for
the output file — "no confusion and no exploit."

This is not an obscure problem of the industry's dawn: "a whole bunch of security
problems plaguing us today ... including many kinds of injection attacks, cross-site
request forgery, cross site scripting, click-jacking — ... somewhere between 5 and 8
members of the OWASP top 10 list. These are all arguably confused deputy problems,
manifestations of this one conceptual flaw first noticed in the 1970s!"

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
