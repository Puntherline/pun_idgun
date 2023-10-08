# Puntherline's ID Gun
<sub>Note: This is a very simple resource, I've made a more advanced version available [here](https://github.com/Puntherline/pun_propinfo) (free of course)</sub>


### Installation
- Code > Download ZIP
- Unzip in `resources` folder
- Add `ensure pun_idgun` to `server.cfg`
- Add `command.idgun` ace to your `server.cfg`, example:
```
add_ace group.moderator command.idgun allow
```

If you wish to disable permission checking, change `requirePermissions` in `server.lua` to `false`.



### What it does
This resource will get the coordinates, heading, rotation and hash of any entity you aim a gun at. It also shows you the hash, courtesy of [PhilippRedel](https://github.com/PhilippRedel).



### Credits
- [PhilippRedel](https://github.com/PhilippRedel) (For updating the resource to show hashes)
- qalle_coords (For simple command that toggles on/off)
- object delete gun (For the aiming gun at object lines)
- SimpleCarHUD (For some text-elements and design)
