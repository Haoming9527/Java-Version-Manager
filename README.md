# Java Version Manager v1.1 User Guide

This guide explains how to switch between multiple installed Java versions (e.g., Java 8, 11, 17, 25) using custom batch (`.bat`) scripts. All switches are permanent at the system level.

## Usage Instructions

1.  **Configure Environment Variables (System Variables)**:
    *   The top list (**User variables**) should not contain any Java-related entries.
    *   The lower list (**System variables**) should contain `JAVA_HOME`.
        *   Example: `JAVA_HOME = C:\Program Files\Java\jdk-23`
        *   If it doesn't exist, click **New...**. If it points elsewhere, click **Edit...**.
    *   **Delete** these entries from the `Path` variable (if they exist):
        *   `C:\ProgramData\Oracle\Java\javapath`
        *   `C:\Program Files (x86)\Common Files\Oracle\Java\javapath`
    *   **Add** this entry to the `Path` instead:
        *   `%JAVA_HOME%\bin`

2.  **Verify Setup**:
    Open a terminal and run:
    ```cmd
    echo %JAVA_HOME%
    java -version
    ```

3.  **Installed JDKs**:
    Ensure all JDKs are installed in: `C:\Program Files\Java\`
    Folders can have minor version numbers (e.g., `jdk-25.0.2`). The script will automatically find the matching folder starting with `jdk-<version>`. If multiple versions exist (e.g., `jdk-25.0.1` and `jdk-25.0.2`), it will pick the latest one alphabetically.

4.  **Script Location**:
    Place all scripts in: `C:\Program Files\Java\scripts`

5.  **Add Scripts to Path**:
    Add `C:\Program Files\Java\scripts` to your system `Path`.

6.  **Refresh Terminal**:
    Open a new terminal window to apply changes.

7.  **Get Help**:
    Use the `javahelp` command for usage instructions:
    ```cmd
    javahelp
    ```

## 🛠 Adding a New Version (e.g., Java 25)

1.  **Install the JDK**:
    Install to: `C:\Program Files\Java\jdk-25` (or any minor version like `jdk-25.0.2`)

2.  **Run Sync**:
    Run the following command to automatically generate the new script:
    ```cmd
    javasync
    ```

3.  **Use It**:
    You can now immediately use:
    ```cmd
    java25
    ```
