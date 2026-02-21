---
name: add-obsidian-task
description: Use when the user wants to add a task, create a new task, or record work to do in Obsidian. Triggers on phrases like "タスクを追加", "タスクを作成", "タスクを登録", "add a task", "create a task", or any request to record a new task item.
---

# Add Obsidian Task

Add a new task note to Obsidian with project/context tags and metadata via `obsidian` CLI.

## Available Projects and Contexts

### Projects
!`${SKILL_DIR}/scripts/list-projects.sh`

### Contexts
!`${SKILL_DIR}/scripts/list-contexts.sh`

## Workflow

### 1. Determine Title and Body

Generate from user input:

- **Title**: Concise, action-oriented. Must not contain `/\:*?"<>|`.
- **Body**: Detailed description, acceptance criteria, notes in markdown.

If the user already provided a clear title, use it directly after sanitizing.

### 2. Prioritize Tag Candidates

Sort the pre-loaded project and context lists by relevance:

- Current working directory name / git repo name
- Task content keywords
- Place most relevant options first (top 4)

### 3. Ask User

Use `AskUserQuestion` with three questions in a single call:

- **Context** (`ctx`): Top 4 relevant contexts from the list above
- **Project** (`pj`): Top 4 relevant projects from the list above
- **Status**: `icebox` / `planned` / `in-progress`
  - `icebox` — idea captured, no active plan
  - `planned` — scheduled, sets `task_review_date` = today + 7 days
  - `in-progress` — actively working on now

### 4. Execute Script

Run `scripts/add-task.sh` with positional arguments:

```bash
bash "${SKILL_DIR}/scripts/add-task.sh" '<title>' '<project>' '<context>' '<status>' '<content>'
```

The script:
1. Creates the note via `obsidian unique`
2. Sets `tags` property with `#task/ctx/…`, `#task/pj/…`, `#task/status/…`
3. If `planned`, sets `task_review_date` to 7 days from today
4. Prints the created file path

### 5. Report

Show the created file path and confirm applied tags. If `planned`, confirm `task_review_date`.
