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
