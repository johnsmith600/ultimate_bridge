# Ultimate Framework Bridge

Ultimate Bridge is a universal compatibility layer for FiveM, supporting ESX Legacy, QBCore, and Qbox. It allows developers to write one set of code that works across all major frameworks.

## Features
- **Automatic Framework Detection**: No configuration needed.
- **Unified API**: Identical exports for player data, money, inventory, jobs, and more.
- **Support for multiple inventories**: ox_inventory, qb-inventory, qs-inventory, etc.
- **Integrated Database Wrapper**: Supports oxmysql, mysql-async, and ghmattimysql.
- **Server/Client Callbacks**: Easy to use callback system.
- **Logging**: Console and Discord webhook logging.
- **High Performance**: Optimized with lazy loading and caching.

## Installation

1. Download the `ultimate_bridge` folder.
2. Place it in your server's `resources` directory.
3. Add `ensure ultimate_bridge` to your `server.cfg`.

### Library Inclusion

To use the `Bridge` global and "live" player objects in your own resource, add the following to your `fxmanifest.lua`:

```lua
shared_script '@ultimate_bridge/lib/bridge.lua'
```

This will automatically set up the `Bridge` object and handle the serialization of player methods and callbacks.

## Documentation
- [Installation Guide](docs/INSTALLATION.md)
- [API Reference](docs/API.md)

## License
Modified MIT License - Commercial use allowed, redistribution and selling not allowed. See [LICENSE](LICENSE) for details.
