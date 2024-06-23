#  How to support a new language
If you want to incorporate a new language, all you need to do is to follow the next simple steps:

1.- Copy the `systempanel.pot` file (language catalog template) as 
    `<your_language>`.po. For instance: `fr.po` for French, `it.po` Italian
    and so on.

2.- Open `<your_language>.po` file with Lokalize (http://userbase.kde.org/Lokalize)

3.- Then, you'll need to translate each label into your language. You must
    be very careful not to remove numbers starting with %, like `%1`, `%2`, as
    they represent parameters for the labels. For instance, the label `"Hello %1!"`
    might be printed like `"Hello John!"`, if the user happens to be named so.
    You must also be careful with HTML tags like `<b>something</b>`. Finally,
    you will be provided with a context to let you know what `%1` is referred to
    when considered appropriate.

4.- Save your translation file.

5.- Open the file `src/package/metadata.desktop` and you'll find a couple of lines like the following:

    Name=System panel
    Comment=Applet for KDE Plasma 6 that displays a panel with a set of system actions

Then, add your language in the same way as it has been done for other languages such as:

    Name[es]=Panel de sistema
    Name[fr]=Panneau système
    Comment[es]=Applet para KDE Plasma 6 que muestra un panel con acciones de sistema
    Comment[fr]=Applet pour KDE Plasma 6 qui affiche un ensemble d'actions système

6.- Once all changes are saved, you can either create pull request or send it to musikolo[AT]hotmail{DOT}com, where
    [AT] is '@' character and {DOT} is '.' character.

Thanks a lot for your contribution!