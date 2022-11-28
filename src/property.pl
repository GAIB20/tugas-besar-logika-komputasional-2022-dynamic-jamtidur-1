/* FAKTA */
harga(a1,'Universitas Negeri Padang','\n    Tahun berdiri        : 1954 \n    Lokasi               : Padang, Sumatra Barat',100,50,50,50,75).
harga(a2,'Universitas Sriwijaya','\n    Tahun berdiri        : 1960 \n    Lokasi               : Palembang, Sumatra Selatan',100,50,50,50,75).
harga(a3,'Universitas Andalas','\n    Tahun berdiri        : 1955 \n    Lokasi               : Padang, Sumatra Barat',120,50,50,50,75).
harga(b1,'Universitas Negeri Semarang','\n    Tahun berdiri        : 1965 \n    Lokasi               : Semarang, Jawa Tengah',140,50,50,50,75).
harga(b2,'Universitas Negeri Malang','\n    Tahun berdiri        : 1954 \n    Lokasi               : Malang dan Blitar, Jawa Timur',140,50,50,50,75).
harga(b3,'Universitas Sumatera Utara','\n    Tahun berdiri        : 1957 \n    Lokasi               : Medan, Sumatra Utara',160,50,50,50,75).
harga(c1,'Universitas Lampung','\n    Tahun berdiri        : 1965 \n    Lokasi               : Bandar Lampung, Lampung',180,100,100,100,150).
harga(c2,'Universitas Gunadarma','\n    Tahun berdiri        : 1981 \n    Lokasi               : Depok, Jawa Barat',180,100,100,100,150).
harga(c3,'Universitas Negeri Yogyakarta','\n    Tahun berdiri        : 1964 \n    Lokasi               : Sleman, Yogyakarta',200,100,100,100,150).
harga(d1,'Universitas Muhammadiyah Yogyakarta','\n    Tahun berdiri        : 1981 \n    Lokasi               : Bantul, Yogyakarta',220,100,100,100,150).
harga(d2,'Universitas Padjajaran','\n    Tahun berdiri        : 1957 \n    Lokasi               : Jatinangor, Jawa Barat',220,100,100,100,150).
harga(d3,'Universitas Hasanuddin','\n    Tahun berdiri        : 1956 \n    Lokasi               : Makassar, Sulawesi Selatan',240,100,100,100,150).
harga(e1,'Universitas Pendidikan Indonesia','\n    Tahun berdiri        : 1954 \n    Lokasi               : Bandung, Jawa Barat',260,150,150,150,225).
harga(e2,'Telkom University','\n    Tahun berdiri        : 2013 \n    Lokasi               : Bandung, Jawa Barat',260,150,150,150,225).
harga(e3,'Universitas Brawijaya','\n    Tahun berdiri        : 1963 \n    Lokasi               : Malang, Jawa Timur',280,150,150,150,225).
harga(f1,'Universitas Diponegoro','\n    Tahun berdiri        : 1957 (berubah nama menjadi Universitas Diponegoro pada tahun 1960) \n    Lokasi               : Semarang, Jawa Tengah',300,150,150,150,225).
harga(f2,'Universitas Sebelas Maret','\n    Tahun berdiri        : 1976 \n    Lokasi               : Surakarta, Jawa Tengah',300,150,150,150,225).
harga(f3,'Universitas Airlangga','\n    Tahun berdiri        : 1954 \n    Lokasi               : Surabaya, Jawa Timur',320,150,150,150,225).
harga(g1,'Universitas Indonesia','\n    Tahun berdiri        : 1924 (berubah nama menjadi Universitas Indonesia pada tahun 1950) \n    Lokasi               : Depok, Jawa Barat \n                           Jakarta Pusat, DKI Jakarta',340,200,200,200,300).
harga(g2,'Institut Teknologi Sepuluh November','\n    Tahun berdiri        : 1957 \n    Lokasi               : Surabaya, Jawa Timur',340,200,200,200,300).
harga(g3,'Institut Pertanian Bogor','\n    Tahun berdiri        : 1963 \n    Lokasi               : Bogor, Jawa Barat',360,200,200,200,300).
harga(h1,'Universitas Gadjah Mada','\n    Tahun berdiri        : 1949 \n    Lokasi               : Sleman, Yogyakarta',400,200,200,200,300).
harga(h2,'Institut Teknologi Bandung','\n    Tahun berdiri        : 1920 (berubah nama menjadi Institut Teknologi Bandung pada tahun 1959) \n    Lokasi               : Bandung, Jawa Barat',450,200,200,200,300).

sewa(a1,5,20,60,100,500).
sewa(a2,5,20,60,100,500).
sewa(a3,8,30,90,200,600).
sewa(b1,11,40,120,250,750).
sewa(b2,11,40,120,250,750).
sewa(b3,14,50,150,300,800).
sewa(c1,17,60,180,350,900).
sewa(c2,17,60,180,350,900).
sewa(c3,20,70,210,400,950).
sewa(d1,23,80,240,500,1000).
sewa(d2,23,80,240,500,1000).
sewa(d3,26,90,270,550,1050).
sewa(e1,29,100,300,600,1100).
sewa(e2,29,100,300,600,1100).
sewa(e3,32,140,420,850,1300).
sewa(f1,35,150,450,900,1350).
sewa(f2,35,150,450,900,1350).
sewa(f3,38,160,480,950,1400).
sewa(g1,41,170,510,1000,1500).
sewa(g2,41,170,510,1000,1500).
sewa(g3,44,180,540,1100,1600).
sewa(h1,50,200,600,1200,1800).
sewa(h2,55,250,750,1500,2100).


/* RULES */
checkPropertyDetail(X) :-
    harga(X,Loc,Desc,HT,HB1,HB2,HB3,HL),
    sewa(X,BST,BSB1,BSB2,BSB3,BSL),
    write('Nama Properti            : '), 
    write(Loc), nl,
    write('Deskripsi Properti       '),
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
