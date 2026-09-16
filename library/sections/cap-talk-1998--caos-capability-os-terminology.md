---
title: "CAOS - A Capable OS? (what counts as a capability; syscall-gating is not an ocap)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jim Dennis, Andrej Presern, Jonathan S. Shapiro]
source_date: 1998-03-22
thread_subject: "CAOS - A CApable OS? [was: Process Authentication Groups (PAGs)]"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
---

Abstract: A long founding-month thread on whether one could build a "capable OS" on top of Linux, and — more durably — a sharp early instance of the *terminology confusion* that dogs the capability field: Andrej Presern proposed a model where a parent process grants a child each syscall it may use ("every Linux process had to explicitly request each of the syscalls that it intends to call and the system must explicitly grant it"), and Jim Dennis pushed back that active syscall-monitoring by a parent — however useful — **is not a capabilities model** and should not be called one, because doing so "will serve to confuse some and irritate others ... the few people who really understand the existing concepts of the capabilities model." This is the primary-source seed of the enduring complaint that POSIX "capabilities" (and syscall-gating sandboxes generally) borrow the word without the model.

## The proposal: parent grants each syscall

Presern's design (paraphrased in the thread): a child process "cannot count on being able to do _anything_ at all (not even execute a single instruction of its code) and it doesn't inherit _anything_ at all from the parent"; it must explicitly request each capability (thought of as an individual function / syscall) and the parent must explicitly grant it, retaining the right to "at any time for any reason terminate access." He was explicit that he used "a very broad definition of a 'capability'" that "probably differs from what it means on other 'capability oriented' operating systems," giving the worked example of denying a setuid binary the `exec()` syscall to blunt a stack-overflow exploit.

## The pushback: that is not a capability model

> I was thinking along the same lines for awhile. I've come to the conclusion that I was wrong (largely due to my conversations with Hugh Daniel). This might be an interesting feature -- but it *isn't* a capabilities model. We shouldn't try to refer to this sort of thing (active process monitoring by "parent" or other processes) as ``capabilities'' since that will serve to confuse some and irritate others. Worst, it is most likely to irritate the few people who really understand the existing concepts of the ``capabilities'' model.

Dennis situated the syscall-interception approach alongside contemporaries — the Janus project (David Wagner et al.), Java-style VM sandboxing, Multics protected shared libraries — and judged that none "substantially improve security at the OS level" because "you still have the same problems of subversion" across whatever IPC channel remains. The reason syscall-gating is not an object-capability model, in the vocabulary the list later adopts: gating *which operations* a process may invoke on *ambient* resources still designates authority by identity/policy rather than by unforgeable reference, so it retains ambient authority and the confused-deputy exposure that the object-capability model removes.

## Why this is filed under open questions

The thread is filed under [cap-talk-open-questions](../topics/cap-talk-open-questions.md) as the archive's recurring *definitional* dispute: what is and is not "a capability." It never fully converges — the field keeps re-encountering it (POSIX capabilities, "capability URLs," seccomp) — and the disagreement itself is the useful signal that "capability" is an overloaded word, sharpened only when the object-capability qualifier is used.

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), messages from Jim Dennis, Andrej Presern, and Jonathan S. Shapiro, 1998-03-21 to 1998-03-24.
