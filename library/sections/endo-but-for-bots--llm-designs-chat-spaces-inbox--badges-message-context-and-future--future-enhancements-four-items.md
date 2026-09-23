---
title: Future enhancements (four items)
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future
---

The design records four roadmap items:

| # | Item | Notes |
|---|---|---|
| 1 | **Unread badges** | The proposed implementation above; daemon-vs-client tradeoff still open. |
| 2 | **Last message preview** | Show snippet on hover. Pure-client; no daemon change needed. |
| 3 | **Notification sounds** | When a new message arrives in an *inactive* space. Pure-client. |
| 4 | **Quick reply** | Type message without full navigation. Probably composes with the existing send-form; no new daemon API needed. |

Three of the four are pure-client; one (badges) crosses the
daemon-API boundary. Future cycles ingesting the implementations of
any of these will report on whether the API discipline held.
