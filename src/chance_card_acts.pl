/* *** RULE *** */
/* INTERNAL: Memajukan pemain ke TAX selanjutnya */
tax_jmp:-
    nowPlayer(Player),
    player(Player, _, Coor, _, _, _, _, _, _),
    coor(Coor, Location),
    findDistance(Location, tx, X), !,
    move(Player, X),
    write('Kena pajak!'), nl,
    tax(Player, Y), nl,
    subtractMoney(Player,Y), nl.

/* INTERNAL: Menambahkan uang pemain aktif */
gift_act(Gift):-
    nowPlayer(Player),
    player(Player, _, _, _, _, _, _, _, _),
    addMoney(Player, Gift).

/* INTERNAL: Mengurangi uang pemain aktif */
tax_act(Tax):-
    nowPlayer(Player),
    player(Player, _, _, _, _, _, _, _, _),
    subtractMoney(Player, Tax).

/* INTERNAL: Memberikan angel card ke pemain aktif */
angel_act:-
    nowPlayer(Player),
    give_card_to(card_angel, Player).

/* INTERNAL: Memasukkan pemain aktif ke penjara */
bonk_act:-
    nowPlayer(Player),
    goToJail(Player).

/* INTERNAL: Memberikan card ke pemain */
give_card_to(Card, Player):-
    chance_card(Card, _, _),
    player(Player, Username, Location, Money, PropertiesValue, Asset, Properties, Buildings, Cards),
    appendElement(Card, Cards, NewCards),
    retractall(player(Player, _, _, _, _, _, _, _, _)),
    assertz(player(Player, Username, Location, Money, PropertiesValue, Asset, Properties, Buildings, NewCards)).
