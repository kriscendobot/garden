---
title: Command-line tooling — transcript, verify, JSON compile, and the diagnostic graph view
source: README.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The `kni` command is not only an interactive reader; it can **record a transcript** of one interpretation, **verify** that a later script still reproduces a recorded transcript, **compile** a script to a JSON instruction graph (and run from precompiled JSON), and **describe** a story as a flat diagnostic listing of its instructions. For this ingest's lens these flags are the concrete evidence of determinism, replayability, and auditability: a transcript is a replayable record of a walk through the graph; verify is a regression check that the same inputs still produce the same narrative; the JSON is the serializable state machine; and `-d` exposes the compiled graph as inspectable rows (thread label, instruction type, description, next-thread indicator).

Beyond running a story interactively, the command line tool can:

- **Produce a transcript** of an interpretation of the story: `kni hello.kni -t hello.1`.
- **Verify** that a transcript continues to produce the same narrative after alterations to the script: `kni hello.kni -v hello.1`. The kni test suite uses this mechanism to validate itself against its examples and test scripts.
- **Generate a JSON representation** of the script: `kni -j hello.kni`. The JSON script can be embedded in a web application as a module and interpreted by the lightweight kni engine.
- **Interpret a script from precompiled JSON**: `kni -J hello.json`.
- **Produce a diagnostic view** of a story: `kni hello.kni -d`.

The diagnostic view is the compiled decision graph made legible. The first column is the thread label, then the instruction type, a description of the instruction, and an indicator for the next thread. In the absence of an indicator, the engine proceeds to the next instruction. A forward arrow indicates a jump and a backward arrow indicates a return to a calling thread, a procession to the next thread of a question or answer sequence, or an exit.

```
$ kni hello.kni -d
start     text    -Hello, "World!"
loop      option  (Q loop.0.2 loop.0.3) (A loop.0.1 loop.0.3 loop.0.4)  -> loop.1
loop.0.1  text    -You s-                                               <-
loop.0.2  text    -S-                                                   <-
loop.0.3  text    -ay, "Hello."                                         <-
loop.0.4  text    You are too kind, hello again                         -> loop
loop.1    option  (Q loop.1.2 loop.1.3) (A loop.1.1 loop.1.3 loop.1.4)  -> loop.2
loop.1.1  text    -You s-                                               <-
loop.1.2  text    -S-                                                   <-
loop.1.3  text    -ay, "Farewell."                                      <-
loop.1.4  goto                                                          -> loop.3
loop.2    prompt
loop.3    text    -The End.
```

The transcript/verify pair, plus a seedable random number generator (`-S <seed>`) and a restorable *waypoint* (`-r <waypoint>`, see [hackni runtime hooks](kni--hackni--runtime-hooks.md)), are why a kni walk is reproducible: the same script, seed, and answer sequence reproduce the same narrative, and a saved waypoint replays the narrative since the last answer.

Source: [README.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/README.md) at commit `120fd885`.
