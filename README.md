# Swift Development Container for vapor projects

## Example `devcontainer.json`:
```json
{
  "name": "inventori-ordering",
  "image": "jhoogstraat/swift-vapor-dev",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": "false",
      "username": "vscode",
      "userUid": "1000",
      "userGid": "1000",
      "upgradePackages": "false"
    },
    "ghcr.io/devcontainers/features/git:1": {
      "version": "os-provided",
      "ppa": "false"
    }
  },
  "runArgs": [
    "--cap-add=SYS_PTRACE",
    "--security-opt",
    "seccomp=unconfined"
  ],
  "customizations": {
    // Configure properties specific to VS Code.
    "vscode": {
      "settings": {
        "lldb.library": "/usr/lib/liblldb.so",
        "apple-swift-format.path": "/usr/local/bin/swift-format",
        "editor.formatOnSave": true,
        "protoc": {
          "path": "/usr/local/bin/protoc",
          "compile_on_save": false,
          "options": [
            "--proto_path=${workspaceRoot}/Sources/App/Models/Requests",
            "--swift_out=${workspaceRoot}/Sources/App/Models/_Generated"
          ]
        }
      },
      "extensions": [
        "vknabel.vscode-apple-swift-format",
        "zxh404.vscode-proto3",
        "sswg.swift-lang"
      ]
    }
  },
  // Use 'forwardPorts' to make a list of ports inside the container available locally.
  // "forwardPorts": [],
  // Use 'postCreateCommand' to run commands after the container is created.
  "postCreateCommand": "swift --version",
  // Set `remoteUser` to `root` to connect as root instead. More info: https://aka.ms/vscode-remote/containers/non-root.
  "remoteUser": "vscode"
}
```
