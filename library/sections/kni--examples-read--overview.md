---
title: "Bot interview and rendered profile"
source: examples/read.kni
source_repo: kriskowal/kni
source_commit: 8af2380b2b5e7932fde71927d4f92b9cb1967001
source_date: 2019-01-01
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

> Abstract: A literal, compact bot-intake decision graph: collect a free-text name, route a bounded gender choice into a variable, collect entropy, then render the gathered values as a profile. It is direct evidence for kni as a deterministic elicitation and feedback-rendering loop.

The script asks three questions in sequence. `> Name name` captures free text in `Name`; a three-option prompt writes `Gender`; and `> Entropy` captures another free-text value. Its last line reads `Gender` and `Name` to render a grammatically selected profile. The values are not inferred from prose after the fact: the graph explicitly names each field and its allowed branch values.

For an agent context scaffold, this is the smallest useful interview shape. The decision graph owns the fixed order, the menu, and the record. An agent or dialog owner supplies each free-form answer, then receives a deterministic rendering of the collected state. The example also makes the limitation visible: this graph stores short fields and numeric choices, so rich interview artifacts belong in external state through the handler seam.

Source: [examples/read.kni](https://github.com/kriskowal/kni/blob/8af2380b2b5e7932fde71927d4f92b9cb1967001/examples/read.kni) at commit `8af2380b`.
