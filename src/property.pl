/* FAKTA */
harga(a1,'Jakarta','Ibukota Indonesia',200,1000,2000,3000,3000).
sewa(a1,20,120,350,600,1000).

/* RULES */
checkPropertyDetail(X) :-
    harga(X,Loc,Desc,HT,HB1,HB2,HB3,HL),
    sewa(X,BST,BSB1,BSB2,BSB3,BSL),
    write('Nama Properti            : '), 
    write(Loc), nl,
    write('Deskripsi Properti       : '),
    write(Desc), nl,
    write(''), nl,
    write('Harga Tanah              : '),
    write(HT), nl,
    write('Harga Bangunan 1         : '),
    write(HB1), nl,
    write('Harga Bangunan 2         : '),
    write(HB2), nl,
    write('Harga Bangunan 3         : '),
    write(HB3), nl,
    write('Harga Landmark           : '),
    write(HL), nl,
    write(''), nl,
    write('Biaya Sewa Tanah         : '),
    write(BST), nl,
    write('Biaya Sewa Bangunan 1    : '),
    write(BSB1), nl,
    write('Biaya Sewa Bangunan 2    : '),
    write(BSB2), nl,
    write('Biaya Sewa Bangunan 3    : '),
    write(BSB3), nl,
    write('Biaya Sewa Landmark      : '),
    write(BSL),!.
