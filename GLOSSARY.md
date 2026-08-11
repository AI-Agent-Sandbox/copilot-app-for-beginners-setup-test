# Glossary

Quick reference for beginner terms used in this course.

## Agent Merge

An advanced GitHub Copilot app workflow where the agent helps carry a pull request through review, checks, and merge readiness. Use it only after you understand the diff, tests, required reviews, and branch protection rules.

## Automation

A saved agent task that can run on demand, on a schedule, or in advanced cases from repository events. Automations should have a clear prompt, limited tools, and a review path.

## Branch

A named line of work in git. A branch lets you make changes without changing the main line until you are ready to merge.

## Canvas

A shared surface inside the Copilot App where humans and agents can inspect or update visible state. Examples include plans, checklists, browser sessions, terminal sessions, dashboards, and documents.

## CI check

An automated check that runs on a pull request or branch. It may run tests, builds, linting, or security scans. CI stands for continuous integration.

## Cloud sandbox

A GitHub-hosted environment where an agent can work away from your local machine. It can improve isolation and portability, but availability depends on plan, policy, repository settings, and permissions.

## Custom agent

A specialized agent configuration for a role or workflow, such as review, documentation, testing, or security. Custom agents are an advanced topic in this beginner course.

## Diff

A view of what changed between two versions of files. In this course, the diff is one of the main places where you inspect agent work before accepting it.

## Local sandbox

A local execution environment with restrictions on file system, network, or system access. It keeps work closer to your machine while limiting what the agent can reach.

## Model Context Protocol (MCP) server

A tool server that uses Model Context Protocol to connect Copilot to external tools or data. MCP servers are useful, but they can add permissions, credentials, and complexity.

## Model

The AI system used for a response or session. Different models may vary in speed, cost, reasoning ability, and output style.

## Pick and Polish

A UI workflow where you pick or describe a visible part of the app, ask Copilot to improve polish, then preview and validate the result. It is useful for spacing, hierarchy, copy, contrast, and responsive layout.

## Plugin

A packaged extension that can add capabilities to the Copilot App. Plugins may include tools, agents, skills, or canvases. Enable only what a workflow needs.

## PR

Pull request. A GitHub request to review and merge changes from one branch into another.

## Quick chat

A lightweight Copilot App conversation for questions, brainstorming, or repository exploration. It is useful when you do not need a branch, worktree, or code changes.

## Reasoning effort

A setting that controls how much thinking the model spends on a task. Higher effort can help complex work, but may be slower or more expensive.

## Session

A Copilot App workspace where an agent can plan, edit, run commands, inspect diffs, and report progress. Sessions may run in a local repository, a new worktree, or a cloud sandbox.

## Skill

Reusable guidance that helps the agent handle a specific kind of task. In this course, repo-local skills are the beginner-friendly way to add focused expertise.

## Worktree

A second working folder attached to the same git repository. In the Copilot App, a session worktree usually has its own branch so parallel work does not collide with your main checkout.
