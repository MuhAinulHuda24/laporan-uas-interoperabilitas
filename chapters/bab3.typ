

= Vendor B: DistroModern

== Simulasi Sistem Standar Internasional
Vendor B (DistroModern) menggunakan penamaan field berbahasa Inggris, camelCase, dan tipe data sudah sesuai standar (harga: Number, stok: Boolean).

== Contoh Output JSON Vendor B
```json
[
	{
		"sku": "TSHIRT-001",
		"productName": "Kaos Ijen Crater",
		"price": 75000,
		"isAvailable": true
	},
	{
		"sku": "TSHIRT-002",
		"productName": "Kaos Gandrung",
		"price": 80000,
		"isAvailable": false
	}
]
```

== Penjelasan Struktur
- `sku`: Kode produk (String)
- `productName`: Nama produk (String)
- `price`: Harga (Number/Integer)
- `isAvailable`: Status ketersediaan (Boolean)

== Catatan
Data Vendor B tidak memerlukan konversi tipe data harga, hanya perlu penyesuaian nama field dan status pada proses normalisasi.