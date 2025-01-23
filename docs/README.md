# Dartblaze Documentation

This repository contains the Dartblaze framework Documentation built with VitePress, a modern static site generator powered by Vue 3.

## Prerequisites

- Node.js 18.x or higher
- npm or yarn package manager

## Installation

Install dependencies:
```bash
npm install
```

## Key Dependencies

- VitePress: ^1.0.0
- vitepress-sidebar: ^1.30.2

## Configuration

The VitePress configuration is located in `.vitepress/config.mts`. It includes:
- Site metadata
- Theme configuration
- Automatic sidebar generation using vitepress-sidebar

## Running the Documentation

1. Development server:
```bash
npm run docs:dev
```
This will start a local server at `http://localhost:5173`

2. Build for production:
```bash
npm run docs:build
```

3. Preview production build:
```bash
npm run docs:preview
```

## Writing Documentation

1. All documentation files should be written in Markdown format (.md)
2. Place new documentation files in the appropriate subdirectory under `docs/`
3. The sidebar will be automatically generated based on your file structure
4. Each markdown file should include proper frontmatter:

```markdown
---
title: Your Page Title
---

# Content starts here
```