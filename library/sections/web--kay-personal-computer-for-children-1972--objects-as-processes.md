---
title: Objects as processes
source: A Personal Computer for Children of All Ages
source_kind: web-transcription
source_authors: [Alan Kay]
source_year: 1972
source_venue: ACM National Conference, Boston
source_url: https://filiph.net/text/alan-kay-personal-computer-for-children-of-all-ages.html
source_content_sha256: e87da9e50f9a56c3620cc1b23deaba7fd165dc28407a065634c9db37764666f2
ingested: 2026-08-27
ingested_by: scholar
topics: [programming-language-design]
status: current
---

## Abstract

Kay proposes a small, uniform language in which objects are processes with state, independent control paths, and message-based interaction. Memory, computation, and procedures are different rates or forms of process rather than separate system categories. Files, operating-system services, user state, and programs can then share one model, while every object remains redefinable in terms of other objects. This is an early statement of the object-as-computer and message-passing lineage later carried through Smalltalk, Actors, E, and Endo.

## A uniform object model

The language should give one account of what objects are, how they are named, and how they affect one another. Each object may have its own control path. Coordination must therefore be expressed concisely, and evaluation must make message delivery and returned results legible. The system should not reserve a fixed hierarchy of privileged object kinds: every object can be defined through others.

The key abstraction is process. A process has state that changes through interactions. What programmers call data changes slowly; what they call a function changes more quickly. Both have the logical power of a small computer: they accept inputs, emit outputs, remember, compute, and interact. This uniformity lets arrays, records, recursive procedures, and later abstractions enter as library-level constructions rather than permanent exceptions.

## User and files in the same model

Multiple control paths let the machine treat files, monitors, and operating-system activities as processes. The user is also represented by persistent state. When the user leaves, that process is passivated; when they return, it resumes. Direct conversation with the interpreter and concurrent stages of evaluation and debugging replace a separate resident command system.

Source: [Processor and Storage](https://filiph.net/text/alan-kay-personal-computer-for-children-of-all-ages.html#processor-and-storage), retrieved with content hash `e87da9e5`.
