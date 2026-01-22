What the Script Does as a Whole

Secures TLS/SSL Communication

Disables TLS 1.0 and TLS 1.1, which are outdated and vulnerable to modern attacks.

Ensures TLS 1.2 is enabled, allowing secure encrypted communication for applications such as IIS, RDP, SQL Server, and APIs.

These changes reduce the risk of downgrade attacks and help meet modern security compliance requirements.

Removes Weak Encryption (Triple DES)

Disables the Triple DES (168-bit) cipher, which is considered weak and vulnerable to cryptographic attacks.

Forces the system to use stronger encryption algorithms like AES, improving overall data confidentiality.

Enforces SMB Signing

Configures both SMB client and server to always use SMB signing.

Protects file-sharing traffic from man-in-the-middle, relay, and tampering attacks.

Ensures integrity and authenticity of SMB communications within the network.

Ensures Safe and Repeatable Execution

Checks for missing registry keys and creates them if necessary.

Can be safely re-run without causing errors or duplicate issues.

Uses clear status messages to show progress and completion.

Applies Changes System-Wide

All settings are applied under HKLM (HKEY_LOCAL_MACHINE), meaning they affect the entire operating system.

A system reboot is required to activate TLS and cipher changes because these settings are loaded at startup.
