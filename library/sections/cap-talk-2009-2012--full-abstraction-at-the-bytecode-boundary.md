---
title: "Full abstraction at the source-to-bytecode security boundary"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-September/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-September.txt.gz
source_content_sha256: bde2949e1c5f8bc041b0c2e9b474a8b8bbd00abbb22f51949a9ec987e58b3151
source_authors: [Mark Miller, Sandro Magi, David Wagner, Ben Kloosterman, Bill Frantz, David-Sarah Hopwood]
source_date: 2009-09-04 to 2009-09-13
thread_subject: "Security and Full Abstraction (was: Cap OS question)"
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, capability-security, hardened-javascript]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Bytecode verification that proves memory safety or blocks a few ambient APIs is not enough to preserve a source language's security reasoning. David Wagner's example shows verified JVM bytecode can supply a value to a Java `byte` parameter that no Java source program can produce, changing a predicate a Java programmer would reasonably treat as tautological. This is a failure of full abstraction: distinctions invisible in the source language become observable or constructible below it. Mutually suspicious components can therefore violate each other's assumptions without escaping the VM. The trusted boundary must preserve the source language's semantic invariants, not only machine-level isolation.

## The verifier is not the source language

The thread began with the proposal that a managed OS could compile arbitrary admitted bytecode after checking that it cannot damage another application or the kernel. Sandro Magi suggested bytecode analysis could at least enforce immutable static state and tame authority-bearing methods. Wagner replied that collaboration between mutually distrusting components requires more: each component reasons about what arbitrary *source-language* code can do, but hostile bytecode may inhabit states that the source language cannot express.

His compact JVM example accepts a Java `byte` and tests that it lies between -128 and 127. Every Java caller makes the result true. Verified JVM bytecode can nevertheless invoke it with a value outside that range and make it false. No native method, reflection escape, or verifier rejection is required. A service secure against every Java program may therefore be insecure against a verifier-accepted class file.

## Full abstraction as the criterion

Mark Miller connected this to Martin Abadi's full-abstraction framing. A secure translation should not let target-language contexts distinguish or construct cases that the source language treats as equivalent or impossible. Merely preventing memory corruption proves a lower-level safety property while leaving higher-level component contracts unsound.

The same reasoning extends to user interfaces. If a system cannot prevent an adversarial action, hiding that action from the honest user's model creates false confidence. The interface and the implementation must expose the same adversarial possibilities that the security argument assumes.

## Bearing on Endo

This is a precise test for SES transforms, bundlers, XS bytecode, and any future Endo compilation cache. The lower representation must not add observable operations or values that Hardened JavaScript excludes. Validation must cover the whole semantic boundary: primordials, evaluator behavior, module linkage, host-call surfaces, numeric and object representation, and deserialization. "The generated code cannot overwrite memory" is necessary but weaker than "the generated code preserves the source-level ocap model."

Source: [cap-talk 2009-September archive](http://www.eros-os.org/pipermail/cap-talk/2009-September/) (Internet Archive original-bytes `id_` snapshot of `2009-September.txt.gz`, sha256 `bde2949e`), thread "Security and Full Abstraction", 2009-09-04 to 2009-09-13.
