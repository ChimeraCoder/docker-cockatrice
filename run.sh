#! /bin/bash


if [ ! -f "/home/planeswalker/.local/share/data/Cockatrice/Cockatrice/cards.xml" ]; then
    echo "cards.xml not present... downloading"
    if [ -z "$CARDS_URL" ]; then
        echo "cards.xml not found, and \$CARDS_URL not defined. Please specify the URL in order to download cards.xml"
    else
        wget -O cards.xml "$CARDS_URL"
        mv cards.xml /home/planeswalker/.local/share/data/Cockatrice/Cockatrice/cards.xml
        chown -R planeswalker:planeswalker /home/planeswalker
    fi
else
    echo "cards.xml is already present"
fi

exec /usr/sbin/sshd -D
