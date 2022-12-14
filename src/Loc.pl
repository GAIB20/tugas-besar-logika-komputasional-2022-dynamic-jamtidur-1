:- dynamic(infoLoc/9).
:- discontiguous(isLoc/1).
:- discontiguous(infoLoc/9).

/*Papan*/
/*Fakta*/
/*coor(X,Y), true jika X adalah koordinat dari Y*/
coor(0, go).
coor(1, a1).
coor(2, a2).
coor(3, a3).
coor(4, cc).
coor(5, b1).
coor(6, b2).
coor(7, b3).
coor(8, jl).
coor(9, c1).
coor(10, c2).
coor(11, c3).
coor(12, tx).
coor(13, d1).
coor(14, d2).
coor(15, d3).
coor(16, fp).
coor(17, e1).
coor(18, e2).
coor(19, e3).
coor(20, cc).
coor(21, f1).
coor(22, f2).
coor(23, f3).
coor(24, wt).
coor(25, g1).
coor(26, g2).
coor(27, g3).
coor(28, tx).
coor(29, cc).
coor(30, h1).
coor(31, h2).







/**/
/*Aturan*/
/*mod(X,Y,Z), true jika X mod Y adalah Z(warning, this prevent world cup and rotational income)*/
/*map, menampilkan papan (probably will use recurese or loop, mostly not)*/
/*Contoh map
         ==============================================================
        |  FP  |  E1  |  E2  |  E3  |  CC  |  F1  |  F2  |  F3  |  WT  |
        |==============================================================|
        |  D3  |                                                |      |
        |======|                                                |======|
        |  D2  |
        |======|                                                |======|
     PL |  D1  |
        |======|                                                |======|
        |  TX  |                M O N O P O L Y                 |
        |======|                                                |======|
        |  C3  |
        |======|                                                |======|
        |  C2  |
        |======|22                                               |======|21
        |  C1  |12                                                        11
        |==============================================================|
        |  JL  |  B3  |  B2  |  B1  |  CC  |  A3  |  A2  |  A1  |  GO  |
         ==============================================================

*/
/*Semua diakhiri \n
printBorderOut, menampilkan frame terluar
printBorderIn, menampilkan
printSpace, menampilkan space antara inner border
printHorizontal(Array,  ,Sentinel1, Sentinel2) rekursif
printMonopoly, menampilkan space antara inner border dengan kata monopoly ditengahnya
printVerticalLoc(Array)
printVerticalOwn(Array) rekursif
printOwnership(X)
print()
*/
map:- 
write('        '), printVerticalOwn([fp, e1, e2, e3, cc, f1, f2, f3, wt]),
printBorderOut,
write('        '), printVerticalLoc([fp, e1, e2, e3, cc, f1, f2, f3, wt]),
printBorderIn,
printHorizontal([d3,g1,d2,g2,d1,g3,tx,tx,c3,cc,c2,h1,c1,h2],13,0),
printBorderIn,
write('        '), printVerticalLoc([jl,b3,b2,b1,cc,a3,a2,a1,go]),
printBorderOut,
write('        '), printVerticalOwn([jl,b3,b2,b1,cc,a3,a2,a1,go]),
nl,nl,nl,
printCurloc,
!.



printOwnership(X):-infoLoc(X,Type,_,_,_,_,_,_,_),Type > 0, write('       '),!.
printOwnership(X):-infoLoc(X,Type,_,_,Y,_,_,_,_), Type =:= 0, Y==none,  write('       '),!.
printOwnership(X):-infoLoc(X,Type,_,_,Y,_,_,Z,_), 
Type =:= 0,  Y\==none,
write('   '),  write(Y), write(Z), write('  '),!.


printBorderOut:-write('         ============================================================== \n'),!.
printBorderIn:- write('        |==============================================================|\n'),!.
printSpace:- write('                                                '),!.
printMonopoly:- write('                M O N O P O L Y                 '),!.

printVerticalLoc([X]):- write('|  '), write(X), write('  |\n'),!.
printVerticalLoc(Array):- Array = [X|Tail],write('|  '), display(X), write('  '), printVerticalLoc(Tail).


printVerticalOwn([X]):-  printOwnership(X),  nl,!.
printVerticalOwn(Array):-[X|Tail] = Array,printOwnership(X), printVerticalOwn(Tail).
/*Start with 13*/
printHorizontal([X], _, _):-  
write('|  '), display(X),write('  |'),printOwnership(X),write('\n'),!.

printHorizontal(Array, Sen1, 0):- Sen is Sen1 mod 2, Sen =:= 0, write('        |======|'), printSpace, printHorizontal(Array, Sen1,1).
printHorizontal(Array, Sen1, 1):- Sen is Sen1 mod 2, Sen =:= 0, write('|======|\n'), SenN is Sen1-1, printHorizontal(Array, SenN, 0).


printHorizontal(Array, Sen1, 0):- 
Sen is Sen1 mod 2,
Sen =:= 1, Sen1 =:= 7, 
Array = [X|Tail],
write(' '),printOwnership(X), write('|  '),display(X),write('  |'), printMonopoly, printHorizontal(Tail, Sen1, 1).


printHorizontal(Array, Sen1, 0):- 
Sen is Sen1 mod 2,
Sen =:= 1, Sen1 =\= 7, 
Array = [X|Tail],
write(' '),printOwnership(X), write('|  '),display(X),write('  |'), printSpace, printHorizontal(Tail, Sen1, 1).




printHorizontal(Array, Sen1, 1):- 
Sen is Sen1 mod 2,
Sen =:= 1, 
Array = [X|Tail],
write('|  '),display(X),write('  | '),printOwnership(X),write('\n'), SenN is Sen1-1,printHorizontal(Tail, SenN, 0).
/*currentLoc(Player, Loc), true jika posisis player sekarang adalah di loc
Untuk sekarang di bawah ini bikin error
*/ 
currentLoc(Player, Loc):-player(Player, _,Loc,_,_,_,_,_,_).

printCurloc:-currentLoc(w, X), coor(X,Xout),
write('     Current Location'),nl,
write('     W: '), write(Xout),nl,
currentLoc(v, Y), coor(Y,Yout),
write('     V: '), write(Yout),nl,!.




/*getDistance(X,Y,Z),
bernilai true jika jarak X dan Y secara 
arah jarum jam bernilai Z.
 */

getDistance(Xin, Y, Zin):- Xin =:= Y, Zin is 1, !.
getDistance(Xin, Y, Zin):- Xin =\= Y, X is (Xin + 1) mod 36, getDistance(X,Y,Z), Zin is Z+1.

findDistance(Start, End, Value):-Start == End, Value is 0.
findDistance(Start, End, Value):-Start \== End, coor(X, Start), X1 is X+1, coor(X1, Next), findDistance(Next, End, Val) , Value is Val+1.

distance(Start,End):-findDistance(Start,End, Value), write(Start),write(' dan '), write(End), write(' berjarak: '), write(Value),nl,!.
/*move(X,Y)*/
/*go effect is not implemented yet*/
move(X,Y):-player(X,A,CurLoc,Money,C,Asset,E,F,G),
X1 is CurLoc + Y,
ChangeLoc is X1 mod 32,
ChangeLoc =< CurLoc, !,
Moneynow is Money + 200,
Assetnow is Asset + 200,
retractall(player(X,A,CurLoc,Money,C,Asset,E,F,G)),
assertz(player(X,A,ChangeLoc,Moneynow,C,Assetnow,E,F,G)).

move(X,Y):-player(X,A,CurLoc,Money,C,D,E,F,G),
X1 is CurLoc + Y,
ChangeLoc is X1 mod 32,
ChangeLoc > CurLoc, 
retractall(player(X,A,CurLoc,Money,C,D,E,F,G)),
assertz(player(X,A,ChangeLoc,Money,C,D,E,F,G)).



/*Lokasi*/
/**FAKTA**/
/*isLoc(X), true jika X adalah lokasi valid*/
isLoc(a1).
isLoc(a2).
isLoc(a3).
isLoc(b1).
isLoc(b2).
isLoc(b3).
isLoc(c1).
isLoc(c2).
isLoc(c3).
isLoc(d1).
isLoc(d2).
isLoc(d3).
isLoc(e1).
isLoc(e2).
isLoc(e3).
isLoc(f1).
isLoc(f2).
isLoc(f3).
isLoc(g1).
isLoc(g2).
isLoc(g3).
isLoc(h1).
isLoc(h2).
isLoc(cc).
isLoc(jl).
isLoc(fp).
isLoc(tx).
isLoc(go).
isLoc(wt).

isProperties(a1).
isProperties(a2).
isProperties(a3).
isProperties(b1).
isProperties(b2).
isProperties(b3).
isProperties(c1).
isProperties(c2).
isProperties(c3).
isProperties(d1).
isProperties(d2).
isProperties(d3).
isProperties(e1).
isProperties(e2).
isProperties(e3).
isProperties(f1).
isProperties(f2).
isProperties(f3).
isProperties(g1).
isProperties(g2).
isProperties(g3).
isProperties(h1).
isProperties(h2).


/*infoLoc(ID, type, Nama, Deskripcsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color):-
curRent(Nama, CurRent), Cost Spend di track,*/
/*type 0: Kota
type 1: Chance Card
type 2: Free Park
type 3: WT
type 4: Jl
type 5: Go
*/
dynamic(infoLoc/9).

infoLoc(cc, 1, 'Chance Card', 'Dapat kartu', _, _, _, _,_).
infoLoc(fp, 2, 'Free Park', 'Duduk santai di Free Park', _, _, _, _,_).
infoLoc(wt, 3, 'World Tour', 'Pergi kemana saja', _,_,_,_,_).


infoLoc(jl, 4, 'Jail', 'Berhenti sejenak di penjara\n Keluarkan double atau bayar suap untuk bebas keluar penjara.',_,_,_,_,_).
infoLoc(go, 5, 'Start Point', 'Titik Awal', _,_,_,_,_).
infoLoc(tx, 6, 'Tax', '###### kena pajak', _,_,_,_,_).


infoLoc(a1, 0, 'Universitas Negeri Padang', '\n    Tahun berdiri        : 1954 \n    Lokasi               : Padang, Sumatra Barat',none,0,0,0,brown).

infoLoc(a2,0, 'Universitas Sriwijaya','\n    Tahun berdiri        : 1960 \n    Lokasi               : Palembang, Sumatra Selatan',none,0,0,0,brown).
infoLoc(a3,0, 'Universitas Andalas','\n    Tahun berdiri        : 1955 \n    Lokasi               : Padang, Sumatra Barat',none,0,0,0,brown).

infoLoc(b1,0, 'Universitas Negeri Semarang','\n    Tahun berdiri        : 1965 \n    Lokasi               : Semarang, Jawa Tengah',none,0,0,0,red).
infoLoc(b2,0, 'Universitas Negeri Malang','\n    Tahun berdiri        : 1954 \n    Lokasi               : Malang dan Blitar, Jawa Timur',none,0,0,0,red).
infoLoc(b3,0, 'Universitas Sumatera Utara','\n    Tahun berdiri        : 1957 \n    Lokasi               : Medan, Sumatra Utara',none,0,0,0,red).

infoLoc(c1,0, 'Universitas Lampung','\n    Tahun berdiri        : 1965 \n    Lokasi               : Bandar Lampung, Lampung',none,0,0,0,orange).
infoLoc(c2,0, 'Universitas Gunadarma','\n    Tahun berdiri        : 1981 \n    Lokasi               : Depok, Jawa Barat',none,0,0,0,orange).
infoLoc(c3,0, 'Universitas Negeri Yogyakarta','\n    Tahun berdiri        : 1964 \n    Lokasi               : Sleman, Yogyakarta',none,0,0,0,orange).

infoLoc(d1,0, 'Universitas Muhammadiyah Yogyakarta','\n    Tahun berdiri        : 1981 \n    Lokasi               : Bantul, Yogyakarta',none,0,0,0,yellow).
infoLoc(d2,0, 'Universitas Padjajaran','\n    Tahun berdiri        : 1957 \n    Lokasi               : Jatinangor, Jawa Barat',none,0,0,0,yellow).
infoLoc(d3,0, 'Universitas Hasanuddin','\n    Tahun berdiri        : 1956 \n    Lokasi               : Makassar, Sulawesi Selatan',none,0,0,0,yellow).

infoLoc(e1,0, 'Universitas Pendidikan Indonesia','\n    Tahun berdiri        : 1954 \n    Lokasi               : Bandung, Jawa Barat',none,0,0,0,green).
infoLoc(e2,0, 'Telkom University','\n    Tahun berdiri        : 2013 \n    Lokasi               : Bandung, Jawa Barat',none,0,0,0,green).
infoLoc(e3,0, 'Universitas Brawijaya','\n    Tahun berdiri        : 1963 \n    Lokasi               : Malang, Jawa Timur',none,0,0,0,green).

infoLoc(f1,0, 'Universitas Diponegoro','\n    Tahun berdiri        : 1957 (berubah nama menjadi Universitas Diponegoro pada tahun 1960) \n    Lokasi               : Semarang, Jawa Tengah',none,0,0,0,blue).
infoLoc(f2,0, 'Universitas Sebelas Maret','\n    Tahun berdiri        : 1976 \n    Lokasi               : Surakarta, Jawa Tengah',none,0,0,0,blue).
infoLoc(f3,0, 'Universitas Airlangga','\n    Tahun berdiri        : 1954 \n    Lokasi               : Surabaya, Jawa Timur',none,0,0,0,blue).

infoLoc(g1,0, 'Universitas Indonesia','\n    Tahun berdiri        : 1924 (berubah nama menjadi Universitas Indonesia pada tahun 1950) \n    Lokasi               : Depok, Jawa Barat \n                           Jakarta Pusat, DKI Jakarta',none,0,0,0,indigo).
infoLoc(g2,0, 'Universitas Teknologi Sepuluh November','\n    Tahun berdiri        : 1957 \n    Lokasi               : Surabaya, Jawa Timur',none,0,0,0,indigo).
infoLoc(g3,0, 'Institut Pertanian Bogor','\n    Tahun berdiri        : 1963 \n    Lokasi               : Bogor, Jawa Barat',none,0,0,0,indigo).

infoLoc(h1,0, 'Universitas Gadjah Mada','\n    Tahun berdiri        : 1949 \n    Lokasi               : Sleman, Yogyakarta',none,0,0,0,violet).
infoLoc(h2,0, 'Institut Teknologi Bandung','\n    Tahun berdiri        : 1920 (berubah nama menjadi Institut Teknologi Bandung pada tahun 1959) \n    Lokasi               : Bandung, Jawa Barat',none,0,0,0,violet).











/*set(X,Y), true jika Array Y merupakan himpunan dari colour X*/


/*Rule*/
/*calculateRent(X,Y), true jika Y adalah harga sewa saat ini untuk X
curRent dikalkulasi menggunakan konditional (harus cek colorset)
asumsi sudah punya*/
calculateRent(X,Y):-infoLoc(_,_,_,_,X,Rent,_,_,Z),colorSet(X,Z),!, Y is (Rent*1.5).
calculateRent(X,Y):-infoLoc(_,_,_,_,X,Rent,_,_,Z), \+colorSet(X,Z), Y is Rent.


/*colorSet(X,Y), true jika player X memiliki colorSet Y*/
colorSet(X,brown):-own(X,a1), own(X,a2),own(X,a3),!.
colorSet(X,red):- own(X,b1), own(X,b2),own(X,b3),!.
colorSet(X,orange):- own(X,c1), own(X,c2),own(X,c3),!.
colorSet(X,yellow):- own(X,d1), own(X,d2),own(X,d3),!.
colorSet(X,green):- own(X,e1), own(X,e2),own(X,e3),!.
colorSet(X,blue):- own(X,f1), own(X,f2),own(X,f3),!.
colorSet(X,indigo):- own(X,g1), own(X,g2),own(X,g3),!.
colorSet(X,purple):- own(X,h1), own(X,h2),!.

/*checkLocationDetail(X)*/
checkLocationDetail(X):-
infoLoc(X, Type, Nama, Deskripsi, _, _, _, _, _),
Type > 0,
write('Nama Lokasi      : '),
write(Nama), 
write('\nDeskripsi Lokasi : '), 
write(Deskripsi),!.


checkLocationDetail(X):-infoLoc(X, Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel, Colorset),
Type == 0,
write('\nNama Lokasi          : '),
write(Nama), 
write('\nDeskripsi Lokasi     : '), 
write(Deskripsi),
write('\nWarna                : '),
write(Colorset),
write('\n\nKepemilikan          : '),
write(Pemilik),
write('\nBiaya Sewa Saat Ini  : '),
write(CurRent),
write('\nBiaya Akuisisi       : '),
write(CostSpend),
write('\nTingkatan Properti    : '),
write(PropertyLevel),!.




/*Basis*/
/*own(X,Y), true jika X memiliki Y*/
own(X,Y):-infoLoc(Y,_,_,X,_,_,_,_,_).
/*color(X,Y), true X memiliki color Y*/
color(X,Y):-infoLoc(X,_,_,_,_,_,_,_,Y).
