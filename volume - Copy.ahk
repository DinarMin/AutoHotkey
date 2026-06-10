; Fix Windows Volume:
$Volume_Up::
SoundGet, volume
Send {Volume_Up}
SoundSet, volume + 1
Return

$Volume_Down::
SoundGet, volume
Send {Volume_Down}
SoundSet, volume - 1
Return