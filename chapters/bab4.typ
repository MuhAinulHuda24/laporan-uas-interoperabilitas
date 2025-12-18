
= Vendor C: Resto & Kuliner

== Simulasi Struktur Data Kompleks (Nested Object)
Vendor C menggunakan struktur data nested, harga terpisah dengan pajak, dan stok berupa angka.

== Contoh Output JSON Vendor C
```json
[
	{
		"id": 501,
		"details": {
			"name": "Nasi Tempong",
			"category": "Food"
		},
		"pricing": {
			"base_price": 20000,
			"tax": 2000
		},
		"stock": 50
	},
	{
		"id": 502,
		"details": {
			"name": "Es Teh Manis",
			"category": "Drink"
		},
		"pricing": {
			"base_price": 5000,
			"tax": 500
		},
		"stock": 0
	}
]
```

== Penjelasan Struktur
- `id`: Kode produk (Integer)
- `details.name`: Nama produk (String)
- `details.category`: Kategori produk (String)
- `pricing.base_price`: Harga dasar (Integer)
- `pricing.tax`: Pajak (Integer)
- `stock`: Jumlah stok (Integer)

== Catatan
Jika kategori adalah "Food", maka pada proses integrasi nama produk akan ditambah label "(Recommended)".