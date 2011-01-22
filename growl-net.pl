#!/usr/bin/env perl -w
#
# This is a simple irssi script to send out Growl notifications using
# Net::Growl. Currently, it sends notifications when you receive
# private messages.  Based on the original growl script by Nelson
# Elhage and Toby Peterson.

use strict;
use vars qw($VERSION %IRSSI $growl);

use Irssi;
use Net::Growl;

$VERSION = '0.2';
%IRSSI = (
    authors      => 'Abhi Yerra'.
                    'Paul Traylor (gntp version), '.
                    'Alex Mason, Jason Adams (based on the growl.pl script from Growl.info by Nelson Elhage and Toby Peterson)',
    contact      => 'http://github.com/kfdm/irssi-growl',
    name         => 'growl-net',
    description  => 'Sends out Growl notifications over the network or internet for Irssi. '.
                    'Requires Net::Growl',
    license      => 'BSD',
    url          => 'http://github.com/kfdm/irssi-growl (gntp version), '.
                    'http://axman6.homeip.net/blog/growl-net-irssi-script-its-back.html (udp version),  '.
                    'http://growl.info/',
);

# Notification Settings
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_privmsg', 1);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_hilight', 1);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_notify', 1);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_topic', 1);
# Network Settings
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_pass', 'password');
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_client', 'localhost');
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_port', '23053');

sub cmd_help {
    Irssi::print('Growl-net can be configured with these settings:');

    Irssi::print('%WNotification Settings%n');
    Irssi::print('  %ygrowl_show_privmsg%n : Notify about private messages.');
    Irssi::print('  %ygrowl_show_hilight%n : Notify when your name is hilighted.');
    Irssi::print('  %ygrowl_show_topic%n : Notify about topic changes.');
    Irssi::print('  %ygrowl_show_notify%n : Notify when someone on your away list joins or leaves.');

    Irssi::print('%WNetwork Settings%n');
    Irssi::print('  %ygrowl_net_client%n : Set to the hostname you want to recieve notifications on.');
    Irssi::print('    %R>>>> (computer.local for a Mac network. Your \'localhost\').');
    Irssi::print('  %ygrowl_net_pass%n : Set to your destination\'s Growl password. (Your machine)');
}

sub growl_message {
    my $title = shift;
    my $description = shift;

    my $GrowlPass   = Irssi::settings_get_str('growl_net_pass');
    my $AppName     = "irssi";

    notify(application => $AppName,
           title       => $title,
           description => $description,
           priority    => 0,
           sticky      => "False",
           password    => $GrowlPass,
        );
}

sub sig_message_private {
    return unless Irssi::settings_get_bool('growl_show_privmsg');

    my ($server, $data, $nick, $address) = @_;
    growl_message($nick, $data);
}

sub sig_notify_joined ($$$$$$) {
    return unless Irssi::settings_get_bool('growl_show_notify');

    my ($server, $nick, $user, $host, $realname, $away) = @_;
    growl_message("$realname" || "$nick", "<$nick!$user\@$host>\nHas joined $server->{chatnet}");
}

sub sig_notify_left ($$$$$$) {
    return unless Irssi::settings_get_bool('growl_show_notify');

    my ($server, $nick, $user, $host, $realname, $away) = @_;
    growl_message("$realname" || "$nick", "<$nick!$user\@$host>\nHas left $server->{chatnet}");
}

sub setup {
    my $GrowlHost   = Irssi::settings_get_str('growl_net_client');
    my $GrowlPass   = Irssi::settings_get_str('growl_net_pass');
    my $AppName     = "irssi";

    Irssi::print("%G Registering to send messages to $GrowlHost");

    register(host        => $GrowlHost,
             application => "irssi",
             password    => $GrowlPass);

    growl_message("irssi", "Started irssi growl.");
}

Irssi::command_bind('growl-net', 'cmd_help');

Irssi::signal_add_last('message private', 'sig_message_private');
Irssi::signal_add_last('notifylist joined', 'sig_notify_joined');
Irssi::signal_add_last('notifylist left', 'sig_notify_left');

setup();
Irssi::print('%G>>%n '.$IRSSI{name}.' '.$VERSION.' loaded (/growl-net for help.)');
