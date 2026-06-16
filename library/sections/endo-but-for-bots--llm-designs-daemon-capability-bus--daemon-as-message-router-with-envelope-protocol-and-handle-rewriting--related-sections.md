---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Related sections
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *capabilities as shared resources* worldview shift; this
  cycle is the *daemon as their message router* worldview shift.
- cycle 101
  [[endo-but-for-bots--llm-designs-daemon-commands-as-messages--ai-agent-commands-routed-as-form-and-value-messages]]
  — *form-request and value-message commands* are at the application
  layer; the capability bus is what carries those messages between
  subprocesses at the transport layer.
- cycle 103
  [[endo-but-for-bots--llm-designs-daemon-value-message--value-as-reply-primitive-for-ai-agent-form-request-flows]]
  — the *value-message* application-layer primitive that rides over
  the envelope `"deliver"` verb.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — *Dir/Shell/Git capabilities* exposed to agents; each capability
  is a handle on the daemon's capability bus.
