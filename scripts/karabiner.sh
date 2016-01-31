#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set remap.jis_command2eisuukana_prefer_command 1
/bin/echo -n .
$cli set repeat.wait 10
/bin/echo -n .
$cli set repeat.initial_wait 250
/bin/echo -n .
$cli set remap.semicolon2return_nomod 1
/bin/echo -n .
$cli set remap.fkeys_to_consumer_f1 1
/bin/echo -n .
$cli set remap.fkeys_to_consumer_f10 1
/bin/echo -n .
$cli set remap.fkeys_to_consumer_f7 1
/bin/echo -n .
/bin/echo
