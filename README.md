This is a bit of a cleanup of the original codebase and makes it a bit
simpler to understand as there isn't much code duplication. I did,
however, take out a few features from the original which I didn't need.
I will slowly readd them in the future.

# ORIGINAL

Irssi growl script taken from
[here](http://axman6.homeip.net/blog/growl-net-irssi-script-its-back.html).

# SETTINGS

## Notification Settings

### `growl_show_privmsg`
(ON/OFF/TOGGLE) Send a notification on private messages

### `growl_show_hilight`
(ON/OFF/TOGGLE) Send a notification when your name is hilighted

### `growl_show_notify`
(ON/OFF/TOGGLE) Send a notification when someone on your away list joins or leaves

### `growl_show_topic`
(ON/OFF/TOGGLE) Send a notification when the topic for a channel changes

## Network Settings

### `growl_net_client`
Set to the hostname you want to send notifications to

On a Mac network this may be computer.local

### `growl_net_port`
The port on the destination computer

### `growl_net_pass`
The growl password of the destination computer

