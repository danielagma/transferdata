# Knowledge base — Darwin (regression testing)

## Purpose

Each file in `user-stories/` documents a Darwin user story that is **already implemented and in production**, and that is part of the regression testing scope. The goal is for each file to contain all the context needed to automate that story without relying on memory or re-investigating from scratch: what the feature does, how it behaves, how it was validated as QA, and what's missing for an automated test.

The regression testing Excel remains the high-level tracker (what exists, in which release); this knowledge base is the per-story detail.

## Structure

```
knowledge-base/
├── README.md                          this file
├── _TEMPLATE.md                       template for creating a new user story
├── INDEX.md                           traceability table: all stories and their automation status
└── user-stories/
    └── FE-12345 - Ticket name/
        ├── FE-12345 - Ticket name.md          story document
        └── evidence/                          original screenshots (ticket, criteria, QA evidence)
            ├── 01-ticket.png
            ├── 02-criteria.png
            └── ...
```

Each user story has its own folder, containing the `.md` with the extracted information and an `evidence/` subfolder with the screenshots as received, so the original source of the ticket can be consulted at any time.

## Naming convention

The folder and the `.md` file are named the same: `<TICKET> - <Ticket name>`, for example:
`FE-21331 - Journey Insights channel cards`

Both are included because the ticket gives direct traceability to Jira, and the name makes the folder identifiable without having to open it.

Screenshots inside `evidence/` are numbered in the order they are received (`01-`, `02-`, ...) with a short name indicating what they show (ticket, acceptance criteria, QA evidence, etc.).

## Workflow

1. One or more screenshots of a complete user story are received (description, acceptance criteria, QA evidence).
2. `user-stories/<TICKET> - <Name>/` is created, the original screenshots are saved in `evidence/`, and the `.md` is created from `_TEMPLATE.md`, extracting and organizing the information.
3. The corresponding row in `INDEX.md` is added/updated.
4. When the story is automated, the "Automation status" field is updated in the file and in `INDEX.md`, and the corresponding spec/PR is linked.

## What does NOT go here

- Stories that are not yet implemented or that are still in development.
- TestRail case detail (that lives in TestRail).
- Test code (that lives in the corresponding automation repo).
