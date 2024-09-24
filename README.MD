# Developer Guide for DevOps Challenge Sales API

## Table of Contents
1. [Clone the Repository](#clone-the-repository)
2. [Setup the Database](#setup-the-database)
   - [Run MS SQL Server Using Docker](#run-ms-sql-server-using-docker)
   - [Create the Database](#create-the-database)
   - [Configure the Application](#configure-the-application)
   - [Set Environment Variables](#set-environment-variables)
3. [Build and Run the Project Locally](#build-and-run-the-project-locally)
4. [Run Database Migrations](#run-database-migrations)
5. [DevOps Challenge .NET (Technical Overview)](#devops-challenge-net-technical-guide)
6. [Check List](#check-list)

---

## Clone the Repository

Clone the repository to your local machine using the following command:

```bash
git clone https://github.com/swivel/sales-api.git
cd sales-api
```

## Setup the Database

### Run MS SQL Server Using Docker

For development purposes, you can run MS SQL Server in a Docker container. This allows you to have a consistent and easily manageable environment.

1. **Pull and Run the SQL Server Docker Image**:

   ```bash
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrongPassword!" -p 1433:1433 --name mssql -d mcr.microsoft.com/mssql/server:2019-latest
   ```

   - **ACCEPT_EULA=Y**: Accepts the SQL Server license agreement.
   - **SA_PASSWORD=YourStrongPassword!**: Sets the `sa` (system administrator) password. Replace `YourStrongPassword!` with a secure password.
   - **-p 1433:1433**: Maps the default SQL Server port 1433 from the container to your local machine.

### Create the Database

Once the SQL Server container is running, connect to it using SQL Server Management Studio (SSMS), Azure Data Studio, or the command line.

1. **Create a New Database** (e.g., `SalesAPI`):

   Using SQLCMD inside the container:

   ```bash
   docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrongPassword! -Q "CREATE DATABASE SalesAPI;"
   ```

### Configure the Application

1. **Copy the Sample Configuration File**:

   Copy the sample appsettings file to create a development configuration:

   ```bash
   cp src/DevOpsChallenge.SalesApi/appsettings.Development.sample.json src/DevOpsChallenge.SalesApi/appsettings.Development.json
   ```

2. **Create the Connection String**:

   Update the `appsettings.Development.json` file with the connection string for the MS SQL Server running in Docker.

   **Example Connection String**:
   ```json
   {
     "ConnectionStrings": {
       "Database": "Server=localhost,1433;Database=SalesAPI;User Id=sa;Password=YourStrongPassword!;"
     }
   }
   ```

### Set Environment Variables

Export the required environment variables for development:

```bash
export ASPNETCORE_ENVIRONMENT=Development
export ConnectionStrings__Database="Server=localhost,1433;Database=SalesAPI;User Id=sa;Password=YourStrongPassword!;"
```

## Build and Run the Project Locally

### Build the Project

To build the project locally, navigate to the source folder and run:

```bash
cd src/DevOpsChallenge.SalesApi
dotnet build
```

This command will compile the application and ensure all dependencies are properly restored.

### Run the Project

After building, you can run the application locally:

```bash
dotnet run
```

The application will start, and you can access the API at `http://localhost:5000`.

## Run Database Migrations

Before running the application, ensure that the database schema is up to date by running the migrations.

1. **Install EF Core Tools Globally**:

   Make sure the EF Core tools are installed globally on your machine:

   ```bash
   dotnet tool install --global dotnet-ef
   ```

2. **Run Migrations Locally**:

   Execute the migration command from the project directory to update the database schema:

   ```bash
   cd src/DevOpsChallenge.SalesApi
   dotnet ef database update
   ```

3. **Verify the Migrations**:

   Confirm that the database schema has been updated in the MS SQL Server instance by checking the tables and indexes in the `SalesAPI` database.

---

By following these steps, you should be able to set up your development environment, build and run the application, and ensure the database is correctly configured with the necessary migrations.

# DevOps Challenge .NET (Technical Guide)

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

3. Creating an index. :white_check_mark:

### Attempt
* Getting started documentation for a new developer. :white_check_mark:
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



