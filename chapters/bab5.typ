
= Integrasi & Normalisasi Data

== Proses Integrasi
Lead Integrator bertugas membaca data dari ketiga vendor, melakukan parsing, dan menormalisasi ke format standar.

== Format Standar Output (Target)
```json
[
  {
	"id": "A001",
	"nama": "Kopi Bubuk 100g",
	"harga_final": 15000,
	"status": "Tersedia",
	"sumber": "Vendor A"
  }
]
```

== Logika Bisnis Wajib
- **Diskon Warung (Vendor A):** Harga final dikurangi diskon 10%.
- **Label Kuliner (Vendor C):** Jika kategori "Food", tambahkan label "(Recommended)" pada nama produk.
- **Type Safety:** Field `harga_final` wajib bertipe Integer.
- **Status:** Semua status distandarkan menjadi "Tersedia" atau "Habis".

== Contoh Pseudocode Integrasi
```python
def normalisasi_vendor_a(data):
	return [{
		"id": d["kd_produk"],
		"nama": d["nm_brg"],
		"harga_final": int(int(d["hrg"]) * 0.9),
		"status": "Tersedia" if d["ket_stok"] == "ada" else "Habis",
		"sumber": "Vendor A"
	} for d in data]

def normalisasi_vendor_b(data):
	return [{
		"id": d["sku"],
		"nama": d["productName"],
		"harga_final": int(d["price"]),
		"status": "Tersedia" if d["isAvailable"] else "Habis",
		"sumber": "Vendor B"
	} for d in data]

def normalisasi_vendor_c(data):
	return [{
		"id": str(d["id"]),
		"nama": d["details"]["name"] + (" (Recommended)" if d["details"]["category"] == "Food" else ""),
		"harga_final": int(d["pricing"]["base_price"] + d["pricing"]["tax"]),
		"status": "Tersedia" if d["stock"] > 0 else "Habis",
		"sumber": "Vendor C"
	} for d in data]
```