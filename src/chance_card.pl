:- include('chance_card_acts.pl').

:- dynamic(ccwsum/1).

/* ======================================================== */
/* *** FAKTA *** */
/* chance_card(name, weight, text) */
all_cards([card_dummy, card_tax_jmp, card_tax_smol, card_tax_med, card_tax_beeg, card_gift_smol, card_gift_med, card_gift_beeg]).
chance_card(card_dummy,     0,      'Baka! Eh bukan dummy yang itu deng.').
chance_card(card_tax_jmp,   100,    'MENGHINDARI PAJAK ADALAH KEJAHATAN INTERNASIONAL! Maju ke petak PAJAK selanjutnya.').
chance_card(card_tax_smol,  300,    'Dompet Anda bocor! Anda kehilangan Rp10.000.').
chance_card(card_tax_med,   150,    'Kena typu! Anda kecurian Rp50.000.').
chance_card(card_tax_beeg,  50,     'Rumah sakit moment! Bayar Rp400.000.').
chance_card(card_gift_smol, 200,    'Uang tercecer di jalan! Anda menemukan Rp5.000.').
chance_card(card_gift_med,  100,    'Bonus! Anda menerima Rp40.000.').
chance_card(card_gift_beeg, 20,     'Warisan! Anda mendapatkan Rp150.000.').

/* ======================================================== */
/* *** RULE *** */
/* EXTERNAL: Memilih satu card acak dan melakukan aksi yang bersesuaian */
ambilChanceCard:-
    pick_chance_card(Card),
    act_chance_card(Card).

/* INTERNAL: Memanggil rule sesuai dengan chance card yang dipilih */
act_chance_card(Card):-
    /* Switch case */
    /* Format:
    Card == card_name,      rule, ..., !; */
    Card == card_dummy,     write('dummycard'), nl, !;
    Card == card_tax_smol,  tax_act(10000), !;
    Card == card_tax_med,   tax_act(50000), !;
    Card == card_tax_beeg,  tax_act(400000), !;
    Card == card_gift_smol, gift_act(5000), !;
    Card == card_gift_med,  gift_act(40000), !;
    Card == card_gift_beeg, gift_act(150000), !;
    /* Default */
    print_chance_card(Card), !.

/* INTERNAL: Memilih satu chance card secara acak dengan bias terhadap card dengan weight lebih besar
   Menggunakan algoritma weighted random choice */
pick_chance_card(Card):-
    chance_card_wsum(WSum),
    random(0, WSum, R),
    pick(R, Card).

/* INTERNAL: Menampilkan card ke terminal */
print_chance_card(Card):-
    chance_card(Card, _, Desc),
    write('Kartu: '), write(Desc), nl.

/* ======================================================== */
/* *** UTIL *** */
/* INTERNAL: Rule untuk memilih card berdasarkan weight */
pick(_, Card, [Card | []]):- !.
pick(R, Card, [Card | _]):-
    chance_card(Card, W, _),
    R < W, !.
pick(R, Card, [Head | Tail]):-
    chance_card(Head, W, _),
    R >= W,
    R1 is R-W,
    pick(R1, Card, Tail).
pick(R, Card):-
    all_cards(Cards),
    pick(R, Card, Cards).

/* INTERNAL: Penghitungan total weight semua card untuk algoritma weighted random choice */
chance_card_wsum(0, []):- !.
chance_card_wsum(S, [Head | Tail]):-
    chance_card_wsum(S1, Tail),
    chance_card(Head, X, _),
    S is S1+X.
chance_card_wsum(S):-
    /* WSum sudah pernah dihitung: lookup */
    ccwsum(S), !;
    /* WSum belum pernah dihitung: hitung dan simpan hasil */
    \+ ccwsum(_),
    all_cards(A),
    chance_card_wsum(S, A),
    assertz(ccwsum(S)).

/* DEBUG: Menampilkan N chance card yang dipilih berurutan secara acak */
pick_n_chance_cards(0):- !.
pick_n_chance_cards(I):-
    pick_chance_card(X),
    chance_card(X, _, _),
    print_chance_card(X),
    I1 is I-1,
    pick_n_chance_cards(I1).
