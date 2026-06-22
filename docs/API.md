# Ultimate Bridge API Documentation

## Framework Detection
```lua
local framework = exports['ultimate_bridge']:GetFramework()
-- returns "esx", "qb", "qbox", or "standalone"
```

## Player
### GetPlayer
```lua
local player = exports['ultimate_bridge']:GetPlayer(source)
```
Properties:
- `player.source`
- `player.identifier`
- `player.firstname`
- `player.lastname`
- `player.name`
- `player.job`
- `player.grade`
- `player.money`
- `player.bank`
- `player.metadata`

Methods:
- `player.AddMoney(account, amount, reason)`
- `player.RemoveMoney(account, amount, reason)`
- `player.SetMoney(account, amount)`
- `player.SetJob(job, grade)`

## Money
- `AddMoney(source, account, amount, reason)`
- `RemoveMoney(source, account, amount, reason)`
- `SetMoney(source, account, amount)`
- `GetMoney(source, account)`

## Inventory
- `AddItem(source, item, amount, metadata)`
- `RemoveItem(source, item, amount, metadata)`
- `HasItem(source, item, amount)`
- `GetItem(source, item)`
- `CanCarryItem(source, item, amount)`

## Notify
- `Notify(source, text, type, duration)` -- Works on server and client

## UI (Client)
- `ProgressBar(label, duration, options)`
- `TextUI(text, type)`
- `HideTextUI()`
- `Teleport(coords)`
- `SpawnVehicle(model, coords, networked)`

## Database
- `Query(query, params)`
- `Single(query, params)`
- `Insert(query, params)`
- `Update(query, params)`
- `Transaction(queries, params)`
