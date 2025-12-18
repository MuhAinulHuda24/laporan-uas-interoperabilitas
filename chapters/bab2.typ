
= Vendor A: WarungLegacy

== Simulasi Sistem Lama
Vendor A (WarungLegacy) menggunakan struktur data sederhana, seluruh tipe data berupa STRING, termasuk harga.

== Contoh Output JSON Vendor A
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
    "nm_brg": "Keripik Pisang",
    "hrg": "12000",
    "ket_stok": "habis"
  }
]
```

== Penjelasan Struktur
- `kd_produk`: Kode produk (String)
- `nm_brg`: Nama barang (String)
- `hrg`: Harga (String, harus dikonversi ke Integer saat normalisasi)
- `ket_stok`: Status stok, "ada" atau "habis" (String)

== Catatan
Pada proses integrasi, data dari Vendor A akan diberikan diskon otomatis 10% pada harga final.