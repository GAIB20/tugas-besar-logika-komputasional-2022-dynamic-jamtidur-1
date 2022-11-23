/* *** RULE *** */
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
    player(Player, Username, Location, Money, PropertiesValue, Asset, Properties, Buildings, Cards),
    appendElement(card_angel, Cards, NewCards),
    retractall(player(Player, _, _, _, _, _, _, _, _)),
    assertz(player(Player, Username, Location, Money, PropertiesValue, Asset, Properties, Buildings, NewCards)).
