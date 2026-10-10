---
name: issues-jira
description: "File, triage, and work through Jira Cloud work items on the configured sites and projects (JQL duplicates, labels, transitions, Smart Commits). Use when the user asks for Jira issues, or when a review before push leaves findings unfixed in a repository that uses Jira."
---

# Jira issue tracking

## 1. Site and project

- Configured sites and project keys: the `jira_sites=` line of `~/.leanagentkit/tracking.conf`, format `https://a.atlassian.net=KEY1,KEY2;https://b.atlassian.net=KEY3`. Written by LeanAgentKit `scripts/install/85-tracking.sh`; holds no credentials.
- Pick the project in this order: the issue tracker named in the repository's `AGENTS.md`; the only configured key; otherwise ask, then offer to add `Issue tracker: Jira <site> <KEY>` to `AGENTS.md`.
- Confirm site and key with the user before the first filing in a session. Never write a token into a file, an issue, or a commit.

## 2. Access

Use the first route that works.

1. Atlassian CLI: `acli jira auth status`. Not signed in: the user runs `acli jira auth login --web`; several sites: `acli jira auth switch --site <host>`. Install: https://developer.atlassian.com/cloud/acli/guides/install-acli/
2. Atlassian Rovo MCP server, if the agent has its tools. Set up once by the user (OAuth sign-in; its tool schemas then load in every session where it is registered):
   - Claude Code: `claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp`, then `/mcp` to sign in.
   - Codex: `codex mcp add atlassian --url https://mcp.atlassian.com/v2/mcp`, then `codex mcp login atlassian`.
   - https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/
3. REST API v3, basic auth with an API token: the user exports `JIRA_EMAIL` and `JIRA_API_TOKEN` in the shell. https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/

None works: say which setup step is missing and stop.

## 3. Work item or OpenSpec change

- Work item: a defect, a review finding, or a task done in one commit.
- OpenSpec change (`openspec-propose`), when the repository has `openspec/`: work that changes behaviour. Its `tasks.md` is the task list, so no sub-tasks. Name the key in `proposal.md`; the commit that completes `tasks.md` carries the key (section 8).
- Epic: a roadmap phase, not a change. `--parent <KEY-n>` on create files under an existing one; create an Epic (`--type Epic`) only when the user names the phase.

## 4. Duplicates

JQL over open and closed work items:

```text
project = KEY AND text ~ "<terms>" ORDER BY created DESC
```

- acli: `acli jira workitem search --jql '<jql>' --fields key,summary,status --json`
- REST: `GET <site>/rest/api/3/search/jql?jql=<jql>&fields=summary,status` (not the removed `/rest/api/3/search`: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/)

`<terms>`: two or three plain words from the title. No quotes, wildcards, or operators (`" * ? ( ) + - ! & |`); a quote inside the string is escaped as `\"`. https://support.atlassian.com/jira-software-cloud/docs/search-syntax-for-text-fields/

Existing work item: add a comment instead (`acli jira workitem comment create --key KEY-1 --body-file <file>`).

## 5. One work item per finding

- Issue type: `Bug` for a defect, `Task` otherwise, as the project offers.
- Labels: one area label; `performance` for a performance finding; `needs-source-check` when a person must verify a source or decide. The source of a finding is in the description, not a label. Components only if the project defines them.
- Description: the template of section 6.

```sh
acli jira workitem create --project KEY --type Bug --summary "<title>" --label <area> [--parent <KEY-n>] --description-file <file>
```

acli `create` has no component flag (https://developer.atlassian.com/cloud/acli/reference/commands/jira-workitem-create/); set components through REST `POST <site>/rest/api/3/issue` with `fields.project.key`, `fields.issuetype.name`, `fields.summary`, `fields.labels`, `fields.components`, `fields.description` (Atlassian Document Format).

## 6. Body

```text
Where: path/to/file:line
Problem: one sentence.
Failure scenario: inputs and the wrong result; measured or inferred.
Proposed fix: the smallest change.
Source: code review, commit range, date.
```

Enhancement: the outcome wanted instead of the failure scenario.

## 7. Review before push

The review before a push (global rule) reports unfixed findings and waits for the user. Offer to file them; after the user agrees, one work item per finding, `needs-source-check` where a person must verify or decide.

## 8. Work loop

1. Pick an open work item: `acli jira workitem search --jql 'project = KEY AND statusCategory != Done'`.
2. A behaviour change in a repository with `openspec/`: `openspec-propose` with the key, then `openspec-apply-change` (section 3). Otherwise fix it with a test; run the project's checks. Commit with the key in the message (`KEY-1 ...`).
3. Smart Commits, only when the site has them enabled and linked to the Git host, the committer email matches exactly one Jira user, and that user may comment on and transition the work item: `KEY-1 #comment <summary> #done`. If comment is a required field, leave out `#comment`. A transition runs by the first word of its name; it fails silently when the transition needs other fields. https://support.atlassian.com/jira-software-cloud/docs/process-issues-with-smart-commits/
4. Push only after the review step.
5. After the push, without Smart Commits: transition instead of closing, `acli jira workitem transition --key KEY-1 --status "Done" --yes`, plus a comment with the commit sha. REST: `GET` then `POST <site>/rest/api/3/issue/KEY-1/transitions` with `{"transition":{"id":"<id>"}}`.
6. Report done and still open work items.

## 9. Publication rules

Work item text follows the repository's publication rules (for example no internal or confidential names). No secrets, tokens, or personal data in work items or comments.
