= Vendor A: WarungLegacy

== Latar Belakang Vendor A

WarungLegacy merupakan salah satu warung lokal yang beroperasi di wilayah Banyuwangi dengan fokus pada produk-produk lokal berkualitas tinggi. Warung ini telah menggunakan sistem kasir komputer, namun masih menggunakan arsitektur database yang relatif lama (legacy system). Sistem informasi yang ada saat ini belum terintegrasi dengan platform digital modern, sehingga proses integrasi data ke marketplace Banyuwangi memerlukan pendekatan khusus untuk menangani karakteristik unik dari struktur datanya.

Dalam konteks integrasi ke Banyuwangi Marketplace, WarungLegacy mewakili tipe vendor dengan sistem informasi generasi lama yang masih relevan secara bisnis namun memerlukan transformasi data untuk kompatibilitas dengan infrastruktur marketplace modern.

== Simulasi Sistem Legacy dengan String

Vendor A (WarungLegacy) menggunakan sistem legacy dengan karakteristik utama yaitu semua field data disimpan dalam format STRING, termasuk nilai harga dan status ketersediaan stok. Pendekatan ini merupakan hal yang umum pada sistem yang dikembangkan pada era awal komputasi bisnis ketika fleksibilitas tipe data string lebih diutamakan dibanding kecanggihan tipe data yang lebih spesifik.

Struktur penyimpanan data yang demikian mengharuskan proses konversi (parsing) dan validasi pada saat integrasi dengan sistem marketplace yang mengharapkan tipe data dengan spesifikasi yang lebih ketat.

== Struktur Data Vendor A

Setiap produk dari Vendor A memiliki empat field utama yang merepresentasikan identitas dan status produk:

- *kd_produk*: Kode identifikasi unik untuk setiap produk, menggunakan format `"A###"` (contoh: A001, A002)
- *nm_brg*: Nama atau deskripsi singkat dari produk yang dijual
- *hrg*: Nilai harga produk dalam Rupiah, disimpan sebagai string numerik tanpa format pemisah ribuan
- *ket_stok*: Status ketersediaan stok dengan nilai enum sederhana ("ada" atau "habis")

== Contoh Output JSON Vendor A

Data berikut merupakan contoh respons dari endpoint API Vendor A yang menampilkan empat produk dengan status stok bervariasi:

```json
[
	{
		"kd_produk": "A001",
		"nm_brg": "Kopi Bubuk 100g",
		"hrg": "15000",
		"ket_stok": "ada"
	},
	{
		"kd_produk": "A002",
		"nm_brg": "Kripik Singkong 200g",
		"hrg": "10000",
		"ket_stok": "ada"
	},
	{
		"kd_produk": "A003",
		"nm_brg": "Teh Celup 25pcs",
		"hrg": "8000",
		"ket_stok": "habis"
	},
	{
		"kd_produk": "A004",
		"nm_brg": "Tape Manis 500g",
		"hrg": "15000",
		"ket_stok": "ada"
	}
]
```

== Penjelasan Struktur Data

Masing-masing field dalam struktur JSON Vendor A memiliki fungsi spesifik dalam sistem kasir mereka:

- *kd_produk* (String): Identifikator unik yang digunakan sistem kasir untuk tracking dan inventori. Format konsisten dengan dua karakter vendor ("A") diikuti tiga digit nomor urut.

- *nm_brg* (String): Nama barang dalam bahasa Indonesia yang ditampilkan pada struk kasir dan laporan. Beberapa produk menyertakan spesifikasi ukuran atau kemasan.

- *hrg* (String): Harga jual dalam Rupiah. Disimpan sebagai string tanpa simbol atau pemisah desimal karena sistem legacy hanya mendukung tipe data dasar. Nilai numerik dapat langsung dikonversi dengan fungsi parsing standar.

- *ket_stok* (String Enum): Status ketersediaan stok yang bersifat Boolean tapi direpresentasikan dalam string. Nilai standar adalah "ada" untuk produk yang tersedia dan "habis" untuk produk yang stok habis.

== Catatan Integrasi

Pada saat integrasi dengan Banyuwangi Marketplace, data dari Vendor A akan melalui tahap normalisasi yang mencakup:

1. Konversi tipe data harga dari string ke integer untuk memastikan kompatibilitas dengan sistem marketplace
2. Transformasi status stok dari string enum ke boolean value
3. Penerapan logika bisnis khusus yaitu diskon otomatis 10% untuk semua produk Vendor A
4. Validasi data untuk memastikan tidak ada nilai null atau format yang tidak sesuai

Keberhasilan integrasi Vendor A akan menjadi fondasi penting dalam membangun marketplace yang dapat menghubungkan vendor legacy dengan infrastruktur digital modern.

