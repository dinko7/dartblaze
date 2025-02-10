# Introduction

Dartblaze CLI is a powerful command-line interface tool for managing Firebase and Google Cloud projects and functions.

## Getting Started

Before you begin using Dartblaze CLI, ensure you have:
- Firebase account
- Google Cloud account
- Proper authentication credentials

## Installation

::: tip
Installation instructions coming soon
:::

## Basic Usage

To see all available commands, run:

```bash
dartblaze
```

# Commands

## doctor

Check your system for potential issues and verify your setup.

### Usage

```bash
dartblaze doctor
```

### Description

The doctor command runs a series of diagnostics to ensure your development environment is properly configured.

## login

### Usage

```bash
dartblaze login
```

### Description

Authenticate with Firebase and Google Cloud services. This command must be run before using any commands that require authentication.

## logout

### Usage

```bash
dartblaze logout
```

### Description

Sign out from Firebase and Google Cloud services and remove local authentication credentials.

## init

### Usage

```bash
dartblaze init --email <user-email> --project-id <project-id>
```

### Options

| Option | Alias | Required | Description |
|--------|--------|----------|-------------|
| `--email` | `-e` | Yes | User email for granting deployment permissions |
| `--project-id` | `-p` | Yes | Google Cloud project ID |

### Description

Initialize a new project with EventArc service account and set up deployment permissions. The email address must be valid and follow standard format.

### Example

```bash
dartblaze init --email developer@company.com --project-id my-cloud-project
```

## use

### Usage

```bash
dartblaze use <project-id>
```

### Description

Set the active project for Firebase and Google Cloud operations. All subsequent commands will be executed in the context of this project.

::: warning
Use command can only be used after the project has been initialized with `init` command.
:::

### Example

```bash
dartblaze use my-project-id
```

## projects:list

### Usage

```bash
dartblaze projects:list
```

### Description

Display a list of all Firebase projects associated with your account. Requires authentication.

## deploy

### Usage

```bash
dartblaze deploy <function-name> --region=<database_region>
```

### Options

| Option | Required | Description |
|--------|----------|-------------|
| `--region` | Yes | Region of the database |
| `--max-instances` | No | Maximum number of instances for this function, defaults to 1 |

### Description

Deploy a Cloud Function to your active project. If no function name is specified, all functions will be deployed.

::: warning
Multi-region Firestore deployments are not available at this time.
:::

### Example

```bash
dartblaze deploy authFunction --region=europe-west3
```

## delete

### Usage

```bash
dartblaze delete <function-name>
```

### Description

::: warning
This command deletes the specified function from **all** regions
:::

Delete a Cloud Function and its associated triggers. Use with caution as this action cannot be undone.

### Example

```bash
dartblaze delete oldFunction
```