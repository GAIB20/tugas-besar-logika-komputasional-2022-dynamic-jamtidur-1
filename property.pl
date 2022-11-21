/* FAKTA */
harga(a1,'Universitas Negeri Padang','[]',100,50,50,50,'landmark').
harga(a2,'Universitas Sriwijaya','[]',100,50,50,50,'landmark').
harga(a3,'Universitas Andalas','[]',120,50,50,50,'landmark').
harga(b1,'Universitas Negeri Semarang','[]',140,50,50,50,'landmark').
harga(b2,'Universitas Negeri Malang','[]',140,50,50,50,'landmark').
harga(b3,'Universitas Sumatera Utara','[]',160,50,50,50,'landmark').
harga(c1,'Universitas Lampung','[]',180,100,100,100,'landmark').
harga(c2,'Universitas Gunadarma','[]',180,100,100,100,'landmark').
harga(c3,'Universitas Negeri Yogyakarta','[]',200,100,100,100,'landmark').
harga(d1,'Universitas Muhammadiyah Yogyakarta','[]',220,100,100,100,'landmark').
harga(d2,'Universitas Padjajaran','[]',220,100,100,100,'landmark').
harga(d3,'Universitas Hasanuddin','[]',240,100,100,100,'landmark').
harga(e1,'Universitas Pendidikan Indonesia','[]',260,150,150,150,'landmark').
harga(e2,'Telkom University','[]',260,150,150,150,'landmark').
harga(e3,'Universitas Brawijaya','[]',280,150,150,150,'landmark').
harga(f1,'Universitas Diponegoro','[]',300,150,150,150,'landmark').
harga(f2,'Universitas Sebelas Maret','[]',300,150,150,150,'landmark').
harga(f3,'Universitas Airlangga','[]',320,150,150,150,'landmark').
harga(g1,'Universitas Indonesia','[]',340,200,200,200,'landmark').
harga(g2,'Institut Teknologi Sepuluh November','[]',340,200,200,200,'landmark').
harga(g3,'Institut Pertanian Bogor','[]',360,200,200,200,'landmark').
harga(h1,'Universitas Gadjah Mada','[]',400,200,200,200,'landmark').
harga(h2,'Institut Teknologi Bandung','[]',450,200,200,200,'landmark').

sewa(a1,5,20,60,100,'landmark').
sewa(a2,5,20,60,100,'landmark').
sewa(a3,8,30,90,200,'landmark').
sewa(b1,11,40,120,250,'landmark').
sewa(b2,11,40,120,250,'landmark').
sewa(b3,14,50,150,300,'landmark').
sewa(c1,17,60,180,350,'landmark').
sewa(c2,17,60,180,350,'landmark').
sewa(c3,20,70,210,400,'landmark').
sewa(d1,23,80,240,500,'landmark').
sewa(d2,23,80,240,500,'landmark').
sewa(d3,26,90,270,550,'landmark').
sewa(e1,29,100,300,600,'landmark').
sewa(e2,29,100,300,600,'landmark').
sewa(e3,32,140,420,850,'landmark').
sewa(f1,35,150,450,900,'landmark').
sewa(f2,35,150,450,900,'landmark').
sewa(f3,38,160,480,950,'landmark').
sewa(g1,41,170,510,1000,'landmark').
sewa(g2,41,170,510,1000,'landmark').
sewa(g3,44,180,540,1100,'landmark').
sewa(h1,50,200,600,1200,'landmark').
sewa(h2,55,250,750,1500,'landmark').


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