---
name: java
description: Guide Claude in working with Java projects using Maven or Gradle. Covers building, testing, dependencies, and project conventions.
user-invocable: false
allowed-tools: Read Grep Glob Bash(sdk *) Bash(java *) Bash(javac *) Bash(jar *) Bash(mvn *) Bash(./mvnw *) Bash(gradle *) Bash(./gradlew *)
---

# Java Development

You are working in an environment with:
- Java
- Maven
- Gradle

SDKMan is available to manage additional versions (e.g. `sdk list java`, `sdk install java 21.0.10-tem`, `sdk use java 21.0.10-tem`).

When a project provides a `.sdkmanrc` file, you can install the required Java version with:
```bash
sdk env install
sdk env
```

## Build Tool Detection

Before running any build commands, detect which build tool the project uses:
- `pom.xml` → Maven project
- `build.gradle` or `build.gradle.kts` → Gradle project
- If a wrapper script exists (`mvnw` / `gradlew`), always prefer it over the system-installed binary.

## Building and Testing

- Always run a build or test from the project root directory.
- Prefer running targeted tests over the full suite when working on a specific class or module:
  - Maven: `mvn test -pl module-name -Dtest=ClassName`
  - Gradle: `gradle :module-name:test --tests ClassName`
- After modifying code, run at least the directly related tests to verify correctness before reporting success.
- When a build or test fails, read the full error output carefully. Do not retry the same command without making a change first.

## Code Conventions

- Follow the existing code style in the project (indentation, brace placement, naming).
- Check for a formatter config (`.editorconfig`, `checkstyle.xml`, `spotless` plugin in the build file) and respect it.
- Use the project's existing Java version (check `pom.xml` properties, `build.gradle` `sourceCompatibility`, or `.java-version` file) — do not assume the container default is the target version.

## Dependencies

- When adding a dependency, look up the latest stable version. Do not guess version numbers.
- For Maven, add dependencies to `pom.xml`. For Gradle, add to `build.gradle(.kts)`.
- Prefer well-known libraries already used in the project over introducing new ones.

## Multi-Module Projects

- Identify the module structure before making changes (`mvn -pl` / `gradle projects`).
- Make changes in the correct module. Check imports and module boundaries.
