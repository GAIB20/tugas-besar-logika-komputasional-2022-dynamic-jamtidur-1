:- dynamic(ccwsum/1).

/* ======================================================== */
/* *** FAKTA *** */
/* chance_card(name, weight, text) */
chance_card(card_dummy,     0,      'Baka! Eh bukan dummy yang itu deng.').
chance_card(card_tax_jmp,   100,    'MENGHINDARI PAJAK ADALAH KEJAHATAN, VERGIL! Maju ke petak PAJAK selanjutnya.').
chance_card(card_tax_smol,  250,    'Dompet Anda bocor! Anda kehilangan $100.').
chance_card(card_tax_med,   120,    'Kena typu! Anda kecurian $500.').
chance_card(card_tax_beeg,  25,     'Rumah sakit moment! Bayar $4000.').
chance_card(card_gift_smol, 200,    'Uang tercecer di jalan! Anda menemukan $50.').
chance_card(card_gift_med,  100,    'Bonus! Anda menerima $400.').
chance_card(card_gift_beeg, 20,     'Warisan! Anda mendapatkan $1500.').
chance_card(card_angel,     20,     'Anda mendapatkan Angel Card! Hindari masuk penjara satu kali.').
chance_card(card_bonk,      80,     'KENA BONK! Anda masuk penjara.').

/* ======================================================== */
/* *** RULE *** */
/* EXTERNAL: Memilih satu card acak dan melakukan aksi yang bersesuaian */
pickChanceCard:-
    pick_chance_card(Card),
    act_chance_card(Card).

/* INTERNAL: Memanggil rule sesuai dengan chance card yang dipilih */
act_chance_card(Card):-
    /* Switch case */
    /* Format:
    Card == card_name,      rule, ..., !; */
    Card == card_dummy,     write('dummycard'), nl, !;
    Card == card_tax_jmp,   print_chance_card(Card), tax_jmp, !;
    Card == card_tax_smol,  print_chance_card(Card), tax_act(100), !;
    Card == card_tax_med,   print_chance_card(Card), tax_act(500), !;
    Card == card_tax_beeg,  print_chance_card(Card), tax_act(4000), !;
    Card == card_gift_smol, print_chance_card(Card), gift_act(50), !;
    Card == card_gift_med,  print_chance_card(Card), gift_act(400), !;
    Card == card_gift_beeg, print_chance_card(Card), gift_act(1500), !;
    Card == card_angel,     print_chance_card(Card), angel_act, !;
    Card == card_bonk,      print_chance_card(Card), bonk_act, !;
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
/* INTERNAL: Rule untuk mengumpulkan semua card dalam satu list */
all_cards(L):-
    findall(Card, chance_card(Card, _, _), L).

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

/*memeriksa apakah pemain mempunyai suatu kartu*/
hasCard(Player,Card) :-
    player(Player,_,_,_,_,_,_,_,Card),
    contains(Card,List).
/*hasCard([A|_],A) :- !.
hasCard([H|T],A) :-
    H \= A, hasCard(T,A).*/

/* DEBUG: Menampilkan N chance card yang dipilih berurutan secara acak */
pick_n_chance_cards(0):- !.
pick_n_chance_cards(I):-
    pick_chance_card(X),
    chance_card(X, _, _),
    print_chance_card(X),
    I1 is I-1,
    pick_n_chance_cards(I1).
