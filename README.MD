# DevOps Challenge .NET

## Branching Strategy

To streamline the CI/CD process, we use a structured branching strategy designed to efficiently manage code changes across different environments: dev, QA, and prod. Below are the main branches used in our strategy:

### Branches and Their Purpose

- **Main**: The production-ready branch. Only thoroughly tested and approved changes are merged into main.
- **Develop**: The integration branch for feature development. Features are first merged into develop for initial testing.
- **Feature Branches (`feature/jira-id`)**: Developers create feature branches to work on new features. Once completed, they open a pull request (PR) to merge their changes into the develop branch.
- **Release Branches (`release/*`)**: Code freeze branches created to prepare a release. From this branch, code is deployed to QA or performance environments for testing. Once testing is complete, a PR is opened to merge changes into main.
- **Hotfix Branches (`hotfix/*`)**: Created for urgent fixes to production issues. Hotfix branches can directly open PRs to the main branch to expedite the release of critical fixes.

### Branching Strategy Flowchart

Below is a flowchart that represents our branching strategy:

```
           +------------+                    +------------+
           |   Feature  |                    |   Hotfix   |
           |  (feature) |                    |  (hotfix)  |
           +------------+                    +------------+
                 |                                 |
                 |                                 |
                 v                                 v
           +-------------+     cherry-pick     +---------+
           |   Develop   |<--------------------|   Main  |
           +-------------+                     +---------+
                 |                                 |
                 |                                 |
                 v                                 |
          +----------------+                       |
          |   Release/*    |                       |
          +----------------+                       |
                 |                                 |
                 |                                 |
                 v                                 |
           +-------------+                         |
           |     QA      |                         |
           +-------------+                         |
                 |                                 |
                 +-----------------+---------------+
                                   |
                                   v
                                +--------+
                                |  Prod  |
                                +--------+
```

## GitHub Workflows

GitHub workflows are used to automate various stages of the CI/CD process, ensuring a streamlined and consistent approach to development and deployment. Here’s how they help:

### Key Workflows

- **Sonar Scan (sonar.yml)**: Runs SonarCloud to analyze the code for quality, bugs, vulnerabilities, and code smells.
- **Lint Validation (lint.yml)**: Uses GitHub's `github/super-linter@v4` to ensure the code adheres to style guidelines and linting rules.
- **Code QL Analysis (code-ql.yml)**: Uses GitHub CodeQL to scan the code for security vulnerabilities and potential exploits.

### How These Workflows Streamline the Process

- **Automated Checks**: Each PR triggers these workflows, automatically checking for code quality, style, and security vulnerabilities.
- **Branch Protection Rules**: We can branch protection rules so that PRs cannot be merged unless all checks pass. This ensures that only high-quality, secure code makes it to the main branch.
- **Deployment Workflow (deploy.yml)**: This workflow builds and deploys the code based on the branch (`Including db migrations`):
  - **Main**: Deploys to the production environment.
  - **Develop**: Deploys to the development environment.
  - **Release/***: Deploys to the QA environment.

### Reusability

Although these workflows are currently standalone for demonstration purposes, they can be standardized and made reusable across the organization. Reusable workflows reduce redundancy and ensure consistent CI/CD practices across all projects. The same CI/CD process can also be achieved using other CI/CD tools, such as Jenkins, by developing shared libraries, which further simplify the developer experience and reduce DevOps overhead.

## Helm Charts

Helm charts are used to manage the deployment configurations for applications, making the deployment process customizable and repeatable.

### How Helm Charts Streamline the Process

- **Customizable Configurations**: Using values files, engineers can customize the deployment for each environment based on specific requirements. This approach makes it easy to manage different configurations for dev, QA, and prod environments.
- **Standardization**: Although the current Helm charts are standalone, they can be standardized and converted into a Helm chart/library. This allows for consistent deployment configurations across all projects within the organization, reducing the DevOps burden and making deployments more predictable and reliable.

### Benefits

- **Simplifies Deployment**: Helm abstracts the complexity of Kubernetes deployments, allowing developers to focus on their code.
- **Reduces DevOps Overhead**: Standardized Helm charts reduce the need for manual configuration management, making deployments quicker and less error-prone.

# Check list
### Question
1. Introduce best practices into the solution to ensure a high-quality ........ :white_check_mark:

2. Build and package the application as a container in a CI/CD pipeline ready for deployment :white_check_mark:

### Good to have
1. The Swagger UI interface should display the code comments written by the API developer. :white_check_mark:

2. `Server: Kestrel`. This header should not be present in responses sent by the server. :white_check_mark:

3. Creating an index.

### Attempt
* Getting started documentation for a new developer.
* Configuring Git's behaviour for particular files. :white_check_mark:
* Versioning of artifacts. :white_check_mark:
* Linting and code quality analysis. :white_check_mark:
* Scanning for code vulnerabilities. :white_check_mark:
* Running unit tests. :white_check_mark:
* Assessing code coverage. :white_check_mark:
* Indexing PDBs for debugging in a deployed environment.
* Preparing to run integration tests on a deployed environment.
* Preparing to deploy database schema migrations. :white_check_mark:
* Generating a client for the API.



