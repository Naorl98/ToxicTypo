# Toxic-Naor Jenkins Pipeline

## Overview
This Jenkins pipeline automates the build, test, publish, and deployment processes for the Toxic-Naor application. It integrates Docker, Maven, and AWS services to ensure a smooth and reliable CI/CD workflow.

## Naor Ladani 

## Pipeline Stages

### Checkout
- **Purpose**: Retrieves the latest source code from the repository to ensure that all subsequent actions in the pipeline are performed on the most up-to-date codebase.
- **Tools Used**: Git SCM, Maven.

### Build Test
- **Purpose**: Compiles the code, runs tests, and builds Docker images. This stage ensures that any changes pass all tests and that the Docker image is ready for deployment.
- **Conditions**: Triggered for commits to `main` or any `feature/*` branches.
- **Tools Used**: Maven for Java builds and Docker for containerization.

### Run Tests
- **Purpose**: Executes integration tests using the newly built Docker images to validate functionality and interaction between components.
- **Conditions**: Runs on updates to `main` and `feature/*` branches to ensure that new features integrate smoothly without disrupting existing functionality.

### Publish
- **Purpose**: Tags the Docker images and pushes them to AWS Elastic Container Registry (ECR), making them available for deployment.
- **Conditions**: Only executes on the `main` branch to ensure that only fully tested and approved changes are deployed to production.

### Deploy
- **Purpose**: Deploys the Docker image to an AWS EC2 instance. This stage handles the remote setup and updates, ensuring the new version of the application is running smoothly in the production environment.
- **Tools Used**: Docker for container management and SSH for remote server interaction.

## Environment Configuration
- Lists and manages all necessary environment variables and credentials needed throughout the pipeline to handle AWS access, Docker configurations, and secure connections.

## Notifications
- **Purpose**: Sends automated notifications about the build and deployment status, providing immediate feedback on the CI/CD process to the development team.

## Cleanup
- **Purpose**: Ensures that all temporary or unused resources, such as Docker containers and networks, are removed after the pipeline execution, keeping the CI/CD environment clean and efficient.

---

This README is set up to provide a quick overview of the entire CI/CD process for developers and maintainers, ensuring everyone is informed about the pipeline's structure and functionality.
