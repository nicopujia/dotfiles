---
description: Commit, push, and create a PR.
agent: build
subtask: true
model: opencode/big-pickle
---

If you are on master, move to a new `nicopujia/` branch based on the diff.
Then commit, push, and create a PR.

Follow this pattern for the description:

```md
**TL;DR:** [one-liner]

## Summary

- [Very concise bullet points detailing the changes. Focus on the outcome, not on the diff (usually you don't need to mention files changed)]

## Test plan

[Brief guide on how to test changes work.]
```
